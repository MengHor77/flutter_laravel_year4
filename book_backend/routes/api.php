<?php
// in D:\flutter\book_backend\routes\api.php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\backend\UserController;
use App\Http\Controllers\backend\CategoryController;
use App\Http\Controllers\backend\BookController;
use App\Http\Controllers\backend\BestSellingController;
use App\Http\Controllers\backend\SpecialOfferController;
use App\Http\Controllers\frontend\CheckoutController;
use App\Http\Controllers\backend\SaleController;
use App\Http\Controllers\frontend\OrderController;
use App\Http\Controllers\backend\FreeBookPDFController;
use App\Http\Controllers\backend\ProfileController;

// FIX: Import both controllers with different names
use App\Http\Controllers\frontend\OrderListController as FrontendOrder;
use App\Http\Controllers\backend\OrderListController as BackendOrder;

// Auth Routes
Route::get('/users', [UserController::class, 'index']);
Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);

// Categories
Route::get('/categories', [CategoryController::class, 'index']);
Route::post('/categories', [CategoryController::class, 'store']);
Route::put('/categories/{id}', [CategoryController::class, 'update']);
Route::delete('/categories/{id}', [CategoryController::class, 'destroy']);

// Books 
Route::get('/books', [BookController::class, 'index']);         
Route::post('/books', [BookController::class, 'store']);         
Route::put('/books/{id}', [BookController::class, 'update']);    
Route::delete('/books/{id}', [BookController::class, 'destroy']);


// Free Book PDFs CRUD
Route::get('/free-books', [FreeBookPDFController::class, 'index']);      // List
Route::post('/free-books', [FreeBookPDFController::class, 'store']);     // Create (Standard POST)
Route::get('/free-books/{id}', [FreeBookPDFController::class, 'show']);  // Single View
Route::put('free-books/{id}', [FreeBookPdfController::class, 'update']);
Route::delete('/free-books/{id}', [FreeBookPDFController::class, 'destroy']); // Delete

// --- ORDERS SECTION ---

// 1. FOR ADMIN (See ALL users and ALL orders)
// Point your Admin Flutter View to this route
Route::get('/admin-orders', [BackendOrder::class, 'index']);

// 2. FOR FRONTEND / MOBILE APP (Cart logic filtered by User ID)
// Use Sanctum middleware to ensure request->user() is not null
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/admin/profile', [ProfileController::class, 'getProfile']);
    Route::post('/admin/update-profile', [ProfileController::class, 'updateProfile']);
    
    Route::get('/orders', [FrontendOrder::class, 'index']);
    Route::post('/orders', [FrontendOrder::class, 'store']);
    Route::delete('/orders/{id}', [FrontendOrder::class, 'destroy']);
    Route::post('/orders/decrement/{book_id}', [FrontendOrder::class, 'decrementQuantity']);
    Route::post('/checkout', [CheckoutController::class, 'processCheckout']);
    Route::get('/sales', [SaleController::class, 'getSummary']);
    Route::get('/orders/{id}', [OrderController::class, 'show']);
    Route::get('/sale-details', [SaleController::class, 'getDetailedSales']);
    
});

// --- END ORDERS SECTION ---

// Best Sellers
Route::get('best-selling', [BestSellingController::class, 'index']);
Route::post('best-selling', [BestSellingController::class, 'store']);
Route::put('best-selling/{id}', [BestSellingController::class, 'update']);
Route::delete('best-selling/{id}', [BestSellingController::class, 'destroy']);

// Special Offers
Route::get('/special-offers', [SpecialOfferController::class, 'index']);
Route::post('/special-offers', [SpecialOfferController::class, 'store']);
Route::delete('/special-offers/{id}', [SpecialOfferController::class, 'destroy']);
Route::put('special-offers/{id}', [SpecialOfferController::class, 'update']);  