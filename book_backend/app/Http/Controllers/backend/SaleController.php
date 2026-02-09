<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Carbon\Carbon;
use Illuminate\Http\Request;

class SaleController extends Controller
{
    public function getSummary()
    {
        try {
            // Updated to use 'total_amount' from your migration
            $todaySales = Order::whereDate('created_at', Carbon::today())
                ->where('status', 'completed')
                ->sum('total_amount');

            $monthlyRevenue = Order::whereMonth('created_at', Carbon::now()->month)
                ->whereYear('created_at', Carbon::now()->year)
                ->where('status', 'completed')
                ->sum('total_amount');

            return response()->json([
                'success' => true,
                'today_sales' => (double) $todaySales,
                'monthly_revenue' => (double) $monthlyRevenue,
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Server Error',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}