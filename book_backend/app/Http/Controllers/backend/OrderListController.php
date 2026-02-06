<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\OrderList;
use Illuminate\Support\Facades\Validator;

class OrderListController extends Controller
{
    public function index()
    {
        // Fetches the order list and the linked book details
        $orders = OrderList::with('book')->orderBy('created_at', 'desc')->get();
        return response()->json($orders, 200);
    }

public function store(Request $request)
{
    // 1. Validate the data
    $request->validate([
        'book_id' => 'required|exists:book,id',
        'price'   => 'required|numeric',
    ]);

    // 2. Insert into the table
    $orderItem = OrderList::create([
        'book_id' => $request->book_id,
        'price'   => $request->price,
    ]);

    return response()->json([
        'message' => 'Successfully inserted into order_list table',
        'data' => $orderItem
    ], 201);
}

    /**
     * FIXED: This now deletes by book_id to match your Flutter Provider logic
     */
    public function destroy($id)
    {
        // Search for the row where the book_id matches what Flutter sent
        $item = OrderList::where('book_id', $id)->first();
        
        if (!$item) {
            return response()->json(['message' => 'Item not found in order list'], 404);
        }
        
        $item->delete();
        return response()->json(['message' => 'Item removed from list'], 200);
    }
}