<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\OrderList;

class AdminController extends Controller
{
    /**
     * Dashboard Stats for Admin
     */
    public function dashboardStats()
    {
        return response()->json([
            'total_users' => User::count(),
            'total_orders' => OrderList::count(),
            'total_revenue' => OrderList::sum('price'),
        ], 200);
    }

    /**
     * Admin can delete a user
     */
    public function deleteUser($id)
    {
        $user = User::find($id);
        if ($user) {
            $user->delete();
            return response()->json(['message' => 'User deleted successfully'], 200);
        }
        return response()->json(['message' => 'User not found'], 404);
    }
}