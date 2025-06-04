<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\LogementController;
use App\Http\Controllers\ReservationController;
use App\Http\Controllers\PaiementController;
use App\Http\Controllers\MessageController;

// Authentication routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);

// Public routes for logements
Route::get('/logements', [LogementController::class, 'index']);
Route::get('/logements/{id}', [LogementController::class, 'show']);
Route::get('/logements/search', [LogementController::class, 'search']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // User routes
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [AuthController::class, 'updateProfile']);

    // Protected Logement routes
    Route::post('/logements', [LogementController::class, 'store']);
    Route::put('/logements/{id}', [LogementController::class, 'update']);
    Route::delete('/logements/{id}', [LogementController::class, 'destroy']);

    // Reservation routes
    Route::get('/reservations', [ReservationController::class, 'index']);
    Route::post('/reservations', [ReservationController::class, 'store']);
    Route::get('/reservations/{id}', [ReservationController::class, 'show']);
    Route::put('/reservations/{id}/status', [ReservationController::class, 'updateStatus']);
    Route::delete('/reservations/{id}', [ReservationController::class, 'destroy']);

    // Paiement routes
    Route::get('/paiements', [PaiementController::class, 'index']);
    Route::post('/paiements', [PaiementController::class, 'store']);
    Route::get('/paiements/{id}', [PaiementController::class, 'show']);
    Route::put('/paiements/{id}/status', [PaiementController::class, 'updateStatus']);

    // Message routes
    Route::get('/messages', [MessageController::class, 'index']);
    Route::post('/messages', [MessageController::class, 'store']);
    Route::get('/messages/{id}', [MessageController::class, 'show']);
    Route::get('/conversations/{userId}', [MessageController::class, 'getConversation']);
    Route::delete('/messages/{id}', [MessageController::class, 'destroy']);
});
