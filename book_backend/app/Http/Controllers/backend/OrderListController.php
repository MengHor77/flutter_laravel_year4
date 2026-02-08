<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use App\Models\OrderList;
use Illuminate\Http\Request;

class OrderListController extends Controller
{
    
    public function index()
    {
       
        $orders = OrderList::with(['book', 'user'])
            ->latest()
            ->get();

        return response()->json($orders, 200);
    }

   
    public function destroy($id)
    {
        $order = OrderList::find($id);
        if ($order) {
            $order->delete();
            return response()->json(['message' => 'Order cleared'], 200);
        }
        return response()->json(['message' => 'Not found'], 404);
    }
}