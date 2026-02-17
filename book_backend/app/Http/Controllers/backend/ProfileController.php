<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    public function getProfile(Request $request)
    {
        // Get only the authenticated admin data
        $user = $request->user();

        return response()->json([
            'status' => 'success',
            'data' => $user
        ]);
    }
}