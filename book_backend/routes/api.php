<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\backened\UserController;

Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);