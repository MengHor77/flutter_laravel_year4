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
        $orders = OrderList::with('book')->orderBy('created_at', 'desc')->get();
        return response()->json($orders, 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'book_id' => 'required|exists:book,id',
            'price'   => 'required|numeric',
        ]);

        $existingOrder = OrderList::where('book_id', $request->book_id)->first();

        if ($existingOrder) {
            $existingOrder->increment('quantity');
            $orderItem = $existingOrder;
        } else {
            $orderItem = OrderList::create([
                'book_id' => $request->book_id,
                'price'   => $request->price,
                'quantity' => 1,
            ]);
        }

        return response()->json(['data' => $orderItem->load('book')], 201);
    }

    /**
     * Handle the Minus button logic
     */
    public function decrementQuantity($bookId)
    {
        $item = OrderList::where('book_id', $bookId)->first();
        
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

    public function destroy($id)
    {
        $item = OrderList::where('book_id', $id)->first();
        if ($item) {
            $item->delete();
            return response()->json(['message' => 'Item removed'], 200);
        }
        return response()->json(['message' => 'Not found'], 404);
    }
}