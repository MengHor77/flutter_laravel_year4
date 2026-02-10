<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Sale; // Ensure you have the Sale model
use Carbon\Carbon;
use Illuminate\Http\Request;

class SaleController extends Controller
{
    // Keep your old code
    public function getSummary()
    {
        try {
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
            return response()->json(['success' => false, 'message' => 'Server Error'], 500);
        }
    }

    // NEW: Get every transaction detail
    public function getDetailedSales()
    {
        try {
            // Fetch all sales with related book and user info
            $details = Sale::with(['book', 'user'])
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $details
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false, 
                'error' => $e->getMessage()
            ], 500);
        }
    }
}