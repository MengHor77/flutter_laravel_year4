<?php

namespace App\Http\Controllers\frontend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\OrderList;
use Illuminate\Support\Facades\Validator;

class OrderListController extends Controller
{
    /**
     * CUSTOMER INDEX: See only their own items
     */
    public function index(Request $request)
    {
        $userId = $request->user()->id; 
        
        $orders = OrderList::where('user_id', $userId)
            ->with('book')
            ->orderBy('created_at', 'desc')
            ->get();
            
        return response()->json($orders, 200);
    }

    /**
     * ADD TO CART logic
     */
    public function store(Request $request)
    {
        $request->validate([
            'book_id' => 'required|exists:book,id',
            'price'   => 'required|numeric',
        ]);

        $userId = $request->user()->id;

        $existingOrder = OrderList::where('user_id', $userId)
            ->where('book_id', $request->book_id)
            ->first();

        if ($existingOrder) {
            $existingOrder->increment('quantity');
            $orderItem = $existingOrder;
        } else {
            $orderItem = OrderList::create([
                'user_id' => $userId,
                'book_id' => $request->book_id,
                'price'   => $request->price,
                'quantity' => 1,
            ]);
        }

        return response()->json(['data' => $orderItem->load('book')], 201);
    }

    /**
     * DECREMENT Quantity logic
     */
    public function decrementQuantity(Request $request, $bookId)
    {
        $userId = $request->user()->id;
        
        $item = OrderList::where('user_id', $userId)
            ->where('book_id', $bookId)
            ->first();
        
        if (!$item) {
            return response()->json(['message' => 'Not found'], 404);
        }

        if ($item->quantity > 1) {
            $item->decrement('quantity');
            return response()->json(['message' => 'Decremented', 'quantity' => $item->quantity], 200);
        } else {
            $item->delete();
            return response()->json(['message' => 'Removed'], 200);
        }
    }

    /**
     * REMOVE item from cart logic
     */
    public function destroy(Request $request, $id)
    {
        $userId = $request->user()->id;

        $item = OrderList::where('user_id', $userId)
            ->where('book_id', $id)
            ->first();

        if ($item) {
            $item->delete();
            return response()->json(['message' => 'Item removed'], 200);
        }
        return response()->json(['message' => 'Not found'], 404);
    }
}