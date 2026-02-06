<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\backend\UserController;
use App\Http\Controllers\backend\CategoryController; // 1. Import the controller

Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);

// 2. Add these lines for Categories
Route::get('/categories', [CategoryController::class, 'index']);      // Fetch all
Route::post('/categories', [CategoryController::class, 'store']);     // Create
Route::put('/categories/{id}', [CategoryController::class, 'update']); // Update
Route::delete('/categories/{id}', [CategoryController::class, 'destroy']); // Delete