<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use App\Models\BestSelling;
use App\Models\Book;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class BestSellingController extends Controller
{
    
    public function index()
    {
        $bestSellers = BestSelling::with(['book.category', 'book.specialOffers' => function($query) {
            $query->where('is_active', true);
        }])->latest()->get();

        $bestSellers->map(function ($item) {
            if ($item->book) {
                $activeOffer = $item->book->specialOffers->first();
                $item->book->is_on_sale = $activeOffer ? true : false;
                $item->book->display_price = $activeOffer ? $activeOffer->offer_price : $item->book->price;

                // ✅ បន្ថែមការត្រួតពិនិត្យ និងបំប្លែង Path រូបភាពទៅជា Full URL
                if ($item->book->image && !filter_var($item->book->image, FILTER_VALIDATE_URL)) {
                    $item->book->image = asset($item->book->image);
                }
            }
            return $item;
        });

        return response()->json($bestSellers, 200);
    }

   
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'book_id' => 'required|exists:book,id|unique:best_selling_book,book_id',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $bestSelling = BestSelling::create([
            'book_id' => $request->book_id
        ]);

        // ✅ បំប្លែងរូបភាពសម្រាប់ទិន្នន័យដែលទើបបង្កើតថ្មី
        $data = $bestSelling->load('book');
        if ($data->book && $data->book->image && !filter_var($data->book->image, FILTER_VALIDATE_URL)) {
            $data->book->image = asset($data->book->image);
        }

        return response()->json([
            'message' => 'Book added to Best Sellers',
            'data' => $data
        ], 201);
    }

  
    public function show($id)
    {
        $bestSelling = BestSelling::with('book')->find($id);

        if (!$bestSelling) {
            return response()->json(['message' => 'Record not found'], 404);
        }

        // ✅ បំប្លែងរូបភាពសម្រាប់មុខងារ Show
        if ($bestSelling->book && $bestSelling->book->image && !filter_var($bestSelling->book->image, FILTER_VALIDATE_URL)) {
            $bestSelling->book->image = asset($bestSelling->book->image);
        }

        return response()->json($bestSelling, 200);
    }

 
    public function update(Request $request, $id)
    {
        $bestSelling = BestSelling::find($id);

        if (!$bestSelling) {
            return response()->json(['message' => 'Record not found'], 404);
        }

        $validator = Validator::make($request->all(), [
            'book_id' => 'required|exists:book,id|unique:best_selling_book,book_id,' . $id,
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $bestSelling->update(['book_id' => $request->book_id]);

        // ✅ បំប្លែងរូបភាពសម្រាប់ទិន្នន័យដែលបាន Update
        $data = $bestSelling->load('book');
        if ($data->book && $data->book->image && !filter_var($data->book->image, FILTER_VALIDATE_URL)) {
            $data->book->image = asset($data->book->image);
        }

        return response()->json([
            'message' => 'Best seller updated',
            'data' => $data
        ], 200);
    }

    
    public function destroy($id)
    {
        $bestSelling = BestSelling::find($id);

        if (!$bestSelling) {
            return response()->json(['message' => 'Record not found'], 404);
        }

        $bestSelling->delete();

        return response()->json(['message' => 'Removed from best sellers'], 200);
    }
}