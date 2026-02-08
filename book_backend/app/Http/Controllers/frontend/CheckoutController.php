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
        // 1. Validate data from Flutter
        $request->validate([
            'total_amount' => 'required',
            'items' => 'required|array',
        ]);

        try {
            // Use Database Transaction for safety
            return DB::transaction(function () use ($request) {
                $user = $request->user();

                // 2. Create the main Order record
                // This assumes you have an 'orders' table for history
                $orderId = DB::table('orders')->insertGetId([
                    'user_id' => $user->id,
                    'total_amount' => $request->total_amount,
                    'status' => 'completed',
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                // 3. Save each item from the cart into an 'order_items' table
                foreach ($request->items as $item) {
                    DB::table('order_items')->insert([
                        'order_id' => $orderId,
                        'book_id'  => $item['book_id'],
                        'quantity' => $item['quantity'],
                        'price'    => $item['price'],
                        'created_at' => now(),
                    ]);
                }

                // 4. CLEAR THE CART (The temporary 'order_list' table)
                // This makes the cart empty in Flutter after a successful purchase
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