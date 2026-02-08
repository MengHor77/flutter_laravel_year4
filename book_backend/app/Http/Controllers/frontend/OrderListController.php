<?php

namespace App\Http\Controllers\frontend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\OrderList;
use Illuminate\Support\Facades\Auth;

class OrderListController extends Controller
{
    public function index(Request $request)
    {
        $orders = OrderList::with('book')
            ->where('user_id', $request->user()->id)
            ->get();
        return response()->json($orders, 200);
    }

    public function store(Request $request)
    {
        $request->validate([
            'book_id' => 'required|exists:book,id',
            'price'   => 'required',
        ]);

        $userId = $request->user()->id;
        $cleanPrice = preg_replace('/[^0-9.]/', '', $request->price);

        $order = OrderList::where('user_id', $userId)
            ->where('book_id', $request->book_id)
            ->first();

        if ($order) {
            $order->increment('quantity');
        } else {
            $order = OrderList::create([
                'user_id'  => $userId,
                'book_id'  => $request->book_id,
                'price'    => (float)$cleanPrice,
                'quantity' => 1,
            ]);
        }

        return response()->json($order->load('book'), 201);
    }

    public function decrementQuantity(Request $request, $bookId)
    {
        $order = OrderList::where('user_id', $request->user()->id)
            ->where('book_id', $bookId)
            ->first();

        if ($order) {
            if ($order->quantity > 1) {
                $order->decrement('quantity');
            } else {
                $order->delete();
            }
            return response()->json(['message' => 'Updated'], 200);
        }
        return response()->json(['message' => 'Not found'], 404);
    }

    public function destroy(Request $request, $bookId)
    {
        OrderList::where('user_id', $request->user()->id)
            ->where('book_id', $bookId)
            ->delete();
        return response()->json(['message' => 'Deleted'], 200);
    }
}