<?php

namespace App\Http\Controllers\frontend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class CheckoutController extends Controller
{
    public function processCheckout(Request $request)
    {
        $request->validate([
            'total_amount' => 'required',
            'items' => 'required|array',
        ]);

        try {
            return DB::transaction(function () use ($request) {
                $user = $request->user();

                //  Create the main Order record
                // This assumes you have an 'orders' table for history
                $orderId = DB::table('orders')->insertGetId([
                    'user_id' => $user->id,
                    'total_amount' => $request->total_amount,
                    'status' => 'completed',
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                        foreach ($request->items as $item) {
                $itemTotal = $item['price'] * $item['quantity'];

                DB::table('order_items')->insert([
                    'order_id'     => $orderId,
                    'user_id'      => $user->id,
                    'book_id'      => $item['book_id'],
                    'quantity'     => $item['quantity'],
                    'price'        => $item['price'],
                    'total_amount' => $itemTotal, // Now this works
                    'created_at'   => now(),
                    'updated_at'   => now(), 
                ]);
            }

                DB::table('order_list')->where('user_id', $user->id)->delete();

                return response()->json([
                    'status' => 'success',
                    'message' => 'Checkout successful!',
                    'order_id' => $orderId
                ], 201);
            });

        } catch (\Exception $e) {
            Log::error("Checkout Error: " . $e->getMessage());
            return response()->json([
                'status' => 'error',
                'message' => 'Something went wrong during checkout',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}