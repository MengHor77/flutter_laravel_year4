<?php
// in  D:\flutter\book_backend\routes\api.php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\backend\UserController;
use App\Http\Controllers\backend\CategoryController;
use App\Http\Controllers\backend\BookController;
use App\Http\Controllers\backend\OrderListController;
use App\Http\Controllers\backend\BestSellingController;
use App\Http\Controllers\backend\SpecialOfferController;





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


// If ApiConfig.orders is "$_domain/orders"
Route::post('/orders', [OrderListController::class, 'store']);
Route::get('/orders', [OrderListController::class, 'index']);
Route::delete('/orders/{id}', [OrderListController::class, 'destroy']);
Route::post('/orders/decrement/{book_id}', [OrderListController::class, 'decrementQuantity']);


// GET: Fetch all best sellers (For your Flutter lists)
Route::get('best-selling', [BestSellingController::class, 'index']);
Route::post('best-selling', [BestSellingController::class, 'store']);
Route::put('best-selling/{id}', [BestSellingController::class, 'update']);
Route::delete('best-selling/{id}', [BestSellingController::class, 'destroy']);



Route::get('/special-offers', [SpecialOfferController::class, 'index']);
Route::post('/special-offers', [SpecialOfferController::class, 'store']);
Route::delete('/special-offers/{id}', [SpecialOfferController::class, 'destroy']);
Route::put('special-offers/{id}', [SpecialOfferController::class, 'update']);