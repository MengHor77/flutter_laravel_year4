<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\OrderList;

class OrderListController extends Controller
{
    /**
     * ADMIN INDEX: Returns ALL orders from ALL users.
     * Includes both 'book' and 'user' relationships.
     */
    public function index()
    {
        $allOrders = OrderList::with(['book', 'user'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($allOrders, 200);
    }

    /**
     * Optional: Admin can delete any order if needed
     */
    public function destroy($id)
    {
        $item = OrderList::find($id);
        if ($item) {
            $item->delete();
            return response()->json(['message' => 'Order removed by admin'], 200);
        }
        return response()->json(['message' => 'Order not found'], 404);
    }
}