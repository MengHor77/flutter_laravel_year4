<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\OrderList;
use Illuminate\Support\Facades\Validator;

class OrderListController extends Controller
{
    /**
     * GET ALL ORDERS
     */
    public function index()
    {
        // Fetches the order list and the linked book details
        // We include 'quantity' so Flutter can show the count
        $orders = OrderList::with('book')->orderBy('created_at', 'desc')->get();
        return response()->json($orders, 200);
    }

    /**
     * ADD TO CART (With Quantity Counting)
     */
    public function store(Request $request)
    {
        // 1. Validate the data
        $validator = Validator::make($request->all(), [
            'book_id' => 'required|exists:book,id',
            'price'   => 'required|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        // 2. LOGIC: Check if book already exists in order_list
        $existingOrder = OrderList::where('book_id', $request->book_id)->first();

        if ($existingOrder) {
            // If it exists, increment the quantity
            $existingOrder->increment('quantity');
            $orderItem = $existingOrder;
            $message = 'Quantity updated successfully';
        } else {
            // If it's new, create the record with default quantity 1
            $orderItem = OrderList::create([
                'book_id' => $request->book_id,
                'price'   => $request->price,
                'quantity' => 1,
            ]);
            $message = 'Successfully inserted into order_list table';
        }

        return response()->json([
            'message' => $message,
            'data' => $orderItem->load('book')
        ], 201);
    }

    /**
     * DELETE ITEM
     * Fixed: If you want to remove just ONE from quantity, use increment(-1)
     * Current Logic: Removes the whole row (standard for cart "Delete" buttons)
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