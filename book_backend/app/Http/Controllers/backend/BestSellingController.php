<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use App\Models\BestSelling;
use App\Models\Book;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class BestSellingController extends Controller
{
    /**
     * Display a listing of best-selling books with book details.
     * Use this for your Flutter "Home" or "Trending" screen.
     */
    public function index()
    {
        $bestSellers = BestSelling::with('book')->latest()->get();
        return response()->json($bestSellers, 200);
    }

    /**
     * Store a new book in the best-selling list.
     */
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

        return response()->json([
            'message' => 'Book added to Best Sellers',
            'data' => $bestSelling->load('book')
        ], 201);
    }

    /**
     * Display a specific best-selling record.
     */
    public function show($id)
    {
        $bestSelling = BestSelling::with('book')->find($id);

        if (!$bestSelling) {
            return response()->json(['message' => 'Record not found'], 404);
        }

        return response()->json($bestSelling, 200);
    }

    /**
     * Update a best-selling record (e.g., swapping a book).
     */
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

        return response()->json([
            'message' => 'Best seller updated',
            'data' => $bestSelling->load('book')
        ], 200);
    }

    /**
     * Remove a book from the best-selling list.
     */
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