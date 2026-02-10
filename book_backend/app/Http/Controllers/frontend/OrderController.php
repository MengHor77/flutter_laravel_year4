<?php

namespace App\Http\Controllers\frontend;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class OrderController extends Controller
{
    /**
     * Get all orders for the current user (History)
     */
    public function getUserOrders()
    {
        $user = Auth::user();

        // Fetches orders with their items (sales) and book info
        $orders = Order::with(['sales.book'])
            ->where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'status' => 'success',
            'orders' => $orders
        ]);
    }

    /**
     * Get a single order by ID
     */
    public function show($id)
    {
        $order = Order::with(['sales.book'])
            ->where('user_id', Auth::id())
            ->find($id);

        if (!$order) {
            return response()->json(['message' => 'Order not found'], 404);
        }

        return response()->json(['status' => 'success', 'order' => $order]);
    }
}