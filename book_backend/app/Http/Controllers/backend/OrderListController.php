<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\OrderList;
use Illuminate\Support\Facades\Validator;

class OrderListController extends Controller
{
    
    public function index(Request $request)
    {
        // 1. Filter by the logged-in user's ID
        $userId = $request->user()->id; 
        
        $orders = OrderList::where('user_id', $userId)
            ->with('book')
            ->orderBy('created_at', 'desc')
            ->get();
            
        return response()->json($orders, 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'book_id' => 'required|exists:book,id',
            'price'   => 'required|numeric',
        ]);

        $userId = $request->user()->id;

        // 2. Check for existing order belonging ONLY to THIS user
        $existingOrder = OrderList::where('user_id', $userId)
            ->where('book_id', $request->book_id)
            ->first();

        if ($existingOrder) {
            $existingOrder->increment('quantity');
            $orderItem = $existingOrder;
        } else {
            $orderItem = OrderList::create([
                'user_id' => $userId, // Save the user owner
                'book_id' => $request->book_id,
                'price'   => $request->price,
                'quantity' => 1,
            ]);
        }

        return response()->json(['data' => $orderItem->load('book')], 201);
    }

    public function decrementQuantity(Request $request, $bookId)
    {
        $userId = $request->user()->id;
        
        // 3. Ensure we only decrement the logged-in user's items
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

    public function destroy(Request $request, $id)
    {
        $userId = $request->user()->id;

        // 4. Ensure user can only delete their own order
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