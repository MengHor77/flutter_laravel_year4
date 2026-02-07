<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SpecialOffer;
use App\Models\Book;
use Illuminate\Support\Facades\Validator;

class SpecialOfferController extends Controller
{
    // Get all active special offers with book details
    public function index()
    {
        $offers = SpecialOffer::with('book')->where('is_active', true)->get();
        return response()->json($offers, 200);
    }

    // Create a new special offer
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

        // Fetch the book to get original price
        $book = Book::find($request->book_id);
        
        // Logic: offer_price = price - (price * (discount / 100))
        $discountAmount = $book->price * ($request->discount_percentage / 100);
        $offerPrice = $book->price - $discountAmount;

        $offer = SpecialOffer::create([
            'book_id' => $request->book_id,
            'title' => $request->title,
            'discount_percentage' => $request->discount_percentage,
            'offer_price' => $offerPrice,
            'is_active' => true,
        ]);

        return response()->json($offer->load('book'), 201);
    }

    // Remove a special offer
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