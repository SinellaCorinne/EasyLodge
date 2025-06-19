<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\LogementController;
use App\Http\Controllers\ReservationController;
use App\Http\Controllers\PaiementController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\AvisController;
use App\Http\Controllers\UniversiteController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// Authentication routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);

// Public routes for logements
Route::get('/logements', [LogementController::class, 'index']);
Route::get('/logements/search', [LogementController::class, 'search']);
Route::get('/logements/{id}', [LogementController::class, 'show']);

// Public routes for universities
Route::get('/universites', [UniversiteController::class, 'index']);
Route::get('/universites/search', [UniversiteController::class, 'search']);
Route::get('/universites/{id}', [UniversiteController::class, 'show']);


// Public routes for reviews
Route::get('/logements/{logementId}/avis', [AvisController::class, 'getAvisByLogement']);


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
    Route::get('/paiements/search', [PaiementController::class, 'search']);
    Route::get('/paiements/{id}', [PaiementController::class, 'show']);
    Route::put('/paiements/{id}/status', [PaiementController::class, 'updateStatus']);

});

//messages routes
Route::middleware(['auth:sanctum'])->group(function () {
    // Messages standards
    Route::get('/messages', [MessageController::class, 'index']);
    Route::post('/messages', [MessageController::class, 'store']);
    Route::get('/messages/{id}', [MessageController::class, 'show']);
    Route::delete('/messages/{id}', [MessageController::class, 'destroy']);
    
    // Conversations
    Route::get('/conversations', [MessageController::class, 'conversations']);
    Route::get('/conversations/{interlocutorId}', [MessageController::class, 'showConversation']);
    
    // Statistiques
    Route::get('/messages/unread-count', [MessageController::class, 'unreadCount']);
});

    // Avis routes
// Routes protégées par Sanctum (authentification requise)
Route::middleware(['auth:sanctum'])->group(function () {
    // Créer un avis
    Route::post('/avis', [AvisController::class, 'store']);
    
    // Lister les avis de l'utilisateur connecté
    Route::get('/my-avis', [AvisController::class, 'myAvis']);
    
    // Mettre à jour un avis
    Route::put('/avis/{id}', [AvisController::class, 'update']);
    
    // Supprimer un avis
    Route::delete('/avis/{id}', [AvisController::class, 'destroy']);
});


    // University management routes (protected)
    Route::post('/universites', [UniversiteController::class, 'store']);
    Route::put('/universites/{id}', [UniversiteController::class, 'update']);
    Route::delete('/universites/{id}', [UniversiteController::class, 'destroy']);