<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SpecialOffer;
use App\Models\Book;
use App\Models\User;         // បន្ថែមនេះ
use App\Models\Notification; // បន្ថែមនេះ
use Illuminate\Support\Facades\Validator;

class SpecialOfferController extends Controller
{
    public function index()
    {
        $offers = SpecialOffer::with('book')->where('is_active', true)->get();
        return response()->json($offers, 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'book_id' => 'required|exists:book,id',
            'title' => 'required|string|max:255',
            'discount_percentage' => 'required|numeric|min:0|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $book = Book::find($request->book_id);
        
        // Logic: offer_price = price - (price * (discount / 100))
        $discountAmount = $book->price * ($request->discount_percentage / 100);
        $offerPrice = $book->price - $discountAmount;

        // ១. បង្កើត Special Offer
        $offer = SpecialOffer::create([
            'book_id' => $request->book_id,
            'title' => $request->title,
            'discount_percentage' => $request->discount_percentage,
            'offer_price' => $offerPrice,
            'is_active' => true,
        ]);

        // ២. បន្ថែមកូដថ្មី៖ បង្កើត Notification សម្រាប់គ្រប់ Users ទាំងអស់
        // ចំណុចនេះនឹងធ្វើឱ្យ unreadCount ក្នុង Flutter កើនឡើង
        $users = User::all();
        foreach ($users as $user) {
            Notification::create([
                'user_id'   => $user->id,
                'title'     => 'Promotion: ' . $request->discount_percentage . '% Off!',
                'message'   => 'Get "' . ($book->name ?? 'this book') . '" now for only $' . number_format($offerPrice, 2),
                'type'      => 'promotion',
                'target_id' => $request->book_id,
                'is_read'   => false, // ដាក់ false ដើម្បីឱ្យលោតលេខ Badge ពណ៌ក្រហម
            ]);
        }

        return response()->json($offer->load('book'), 201);
    }

    public function update(Request $request, $id)
    {
        $offer = SpecialOffer::find($id);

        if (!$offer) {
            return response()->json(['message' => 'Offer not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'book_id' => 'required|exists:book,id',
            'title' => 'required|string|max:255',
            'discount_percentage' => 'required|numeric|min:0|max:100',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // Recalculate price based on the (potentially new) book or discount
        $book = Book::find($request->book_id);
        $discountAmount = $book->price * ($request->discount_percentage / 100);
        $offerPrice = $book->price - $discountAmount;

        $offer->update([
            'book_id' => $request->book_id,
            'title' => $request->title,
            'discount_percentage' => $request->discount_percentage,
            'offer_price' => $offerPrice,
        ]);

        return response()->json($offer->load('book'), 200);
    }

    public function destroy($id)
    {
        $offer = SpecialOffer::find($id);
        if (!$offer) {
            return response()->json(['message' => 'Offer not found'], 404);
        }

        $offer->delete();
        return response()->json(['message' => 'Offer deleted successfully'], 200);
    }
}