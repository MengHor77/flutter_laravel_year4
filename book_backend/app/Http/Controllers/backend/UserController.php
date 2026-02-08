<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;


class UserController extends Controller
{
    
    public function index()
    {
            $users = User::all();
            return response()->json($users, 200);
    }
    
    public function login(Request $request)
     {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
            'device_name' => 'required', 
        ]);

        // 1. Try to find the person in the Users table
        $user = User::where('email', $request->email)->first();
        
        if ($user && Hash::check($request->password, $user->password)) {
            $token = $user->createToken($request->device_name)->plainTextToken;
            return response()->json([
                'status' => 'success',
                'role' => 'user',
                'token' => $token,
                'user' => $user,
            ], 200);
        }

        // 2. If not found in Users, try the Admin table
        $admin = DB::table('admin')->where('email', $request->email)->first();

        if ($admin && Hash::check($request->password, $admin->password)) {
            // Note: If you want to use Sanctum tokens for Admin, 
            // the Admin needs to be a Model using the HasApiTokens trait.
            return response()->json([
                'status' => 'success',
                'role' => 'admin',
                'token' => 'admin_session_token', // Placeholder or generated token
                'user' => $admin,
            ], 200);
        }

        return response()->json(['message' => 'Invalid credentials'], 401);
     }

    // Register Logic (unchanged)
    public function register(Request $request)
     {
        $validateData = $request->validate([
            'name' => 'required|max:255',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:8'
        ]);

        $user = User::create([
            'name' => $validateData['name'],
            'email' => $validateData['email'],
            'password' => Hash::make($validateData['password']),
        ]);

        return response()->json(['message' => 'User created successfully', 'user' => $user], 201); 
     }
}