<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Admin;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

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

        $admin = Admin::where('email', $request->email)->first();
        if ($admin && Hash::check($request->password, $admin->password)) {
            $token = $admin->createToken($request->device_name)->plainTextToken;
            return response()->json([
                'status' => 'success',
                'role' => 'admin',
                'token' => $token, 
                'user' => [
                    'id' => $admin->id,
                    'name' => $admin->name ?? $admin->username ?? 'Admin User', 
                    'email' => $admin->email,
                ],
            ], 200);
        }

        return response()->json(['message' => 'Invalid credentials'], 401);
    }
 
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
    
    public function update(Request $request, $id)
    {
        // 1. Validation
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $id,
            'current_password' => 'required',
            'new_password' => 'required|min:8',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        // 2. Find User
        $user = User::find($id);
        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        // 3. Verify Current Password
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'status' => 'error',
                'message' => 'Current password does not match our records.'
            ], 401);
        }

        // 4. Update Data
        $user->name = $request->name;
        $user->email = $request->email;
        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Profile updated successfully',
            'user' => $user
        ], 200);
    }
    
    

public function forgotPassword(Request $request)
{
    $request->validate(['email' => 'required|email']);

    $user = User::where('email', $request->email)->first();
    if (!$user) {
        return response()->json(['message' => 'User not found'], 404);
    }

    // Generate a 6-digit code
    $token = rand(100000, 999999);

    // Store in password_reset_tokens table
    DB::table('password_reset_tokens')->updateOrInsert(
        ['email' => $request->email],
        [
            'token' => Hash::make($token),
            'created_at' => now()
        ]
    );

    // TODO: Send Email here. For now, we return it in JSON for testing.
    return response()->json([
        'status' => 'success', 
        'message' => 'OTP sent to your email',
        'code OTP' => $token // Remove this line in production!
    ], 200);
}

public function resetPassword(Request $request)
{
    $request->validate([
        'email' => 'required|email',
        'token' => 'required', // This is the OTP code
        'password' => 'required|min:8|confirmed'
    ]);

    $reset = DB::table('password_reset_tokens')->where('email', $request->email)->first();

    if (!$reset || !Hash::check($request->token, $reset->token)) {
        return response()->json(['message' => 'Invalid OTP code'], 401);
    }

    // Check if token is expired (e.g., older than 60 mins)
    if (strtotime($reset->created_at) < strtotime("-60 minutes")) {
        return response()->json(['message' => 'OTP expired'], 401);
    }

    $user = User::where('email', $request->email)->first();
    $user->password = Hash::make($request->password);
    $user->save();

    // Delete the token after use
    DB::table('password_reset_tokens')->where('email', $request->email)->delete();

    return response()->json(['message' => 'Password reset successfully'], 200);
}


}