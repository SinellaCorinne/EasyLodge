<?php

namespace App\Http\Controllers;

use App\Models\Avis;
use App\Models\Reservation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AvisController extends Controller
{
    /**
     * Display reviews for a specific housing.
     *
     * @param  int  $logementId
     * @return \Illuminate\Http\Response
     */
    public function getAvisByLogement($logementId)
    {
        $avis = Avis::with(['etudiant.utilisateur'])
            ->where('logement_id', $logementId)
            ->orderBy('dateAvis', 'desc')
            ->get();

        return response()->json([
            'status' => true,
            'avis' => $avis
        ], 200);
    }

    /**
     * Store a newly created review.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $user = $request->user();

        if (!$user->isEtudiant()) {
            return response()->json([
                'status' => false,
                'message' => 'Only students can write reviews'
            ], 403);
        }



        $validator = Validator::make($request->all(), [
            'logement_id' => 'required|exists:logements,logement_id',
            'note' => 'required|integer|min:1|max:5',
            'commentaire' => 'required|string|max:1000',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Vérifier si l'étudiant a une réservation confirmée pour ce logement
        $reservation = Reservation::where('logement_id', $request->logement_id)
            ->where('etudiant_id', $user->etudiant->etudiant_id)
            ->where('statut', 'confirmee')
            ->first();

        if (!$reservation) {
            return response()->json([
                'status' => false,
                'message' => 'You can only review housing you have reserved'
            ], 403);
        }

        // Vérifier si l'étudiant a déjà donné un avis pour ce logement
        $existingAvis = Avis::where('logement_id', $request->logement_id)
            ->where('etudiant_id', $user->etudiant->etudiant_id)
            ->first();

        if ($existingAvis) {
            return response()->json([
                'status' => false,
                'message' => 'You have already reviewed this housing'
            ], 400);
        }

        $avis = Avis::create([
            'logement_id' => $request->logement_id,
            'etudiant_id' => $user->etudiant->etudiant_id,
            'note' => $request->note,
            'commentaire' => $request->commentaire,
            'dateAvis' => now(),
        ]);

        // Load relationships
        $avis->load(['etudiant.utilisateur', 'logement']);

        return response()->json([
            'status' => true,
            'message' => 'Review created successfully',
            'avis' => $avis
        ], 201);
    }

    /**
     * Update the specified review.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $user = $request->user();

        if (!$user->isEtudiant()) {
            return response()->json([
                'status' => false,
                'message' => 'Only students can update reviews'
            ], 403);
        }

        $avis = Avis::find($id);

        if (!$avis) {
            return response()->json([
                'status' => false,
                'message' => 'Review not found'
            ], 404);
        }

        if ($avis->etudiant_id != $user->etudiant->etudiant_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only update your own reviews'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'note' => 'integer|min:1|max:5',
            'commentaire' => 'string|max:1000',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $avis->update($request->only(['note', 'commentaire']));

        // Load relationships
        $avis->load(['etudiant.utilisateur', 'logement']);

        return response()->json([
            'status' => true,
            'message' => 'Review updated successfully',
            'avis' => $avis
        ], 200);
    }

    /**
     * Remove the specified review.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $id)
    {
        $user = $request->user();

        if (!$user->isEtudiant()) {
            return response()->json([
                'status' => false,
                'message' => 'Only students can delete reviews'
            ], 403);
        }

        $avis = Avis::find($id);

        if (!$avis) {
            return response()->json([
                'status' => false,
                'message' => 'Review not found'
            ], 404);
        }

        if ($avis->etudiant_id != $user->etudiant->etudiant_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only delete your own reviews'
            ], 403);
        }

        $avis->delete();

        return response()->json([
            'status' => true,
            'message' => 'Review deleted successfully'
        ], 200);
    }

    /**
     * Get current user's reviews.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function myAvis(Request $request)
    {
        $user = $request->user();

        if (!$user->isEtudiant()) {
            return response()->json([
                'status' => false,
                'message' => 'Only students can view their reviews'
            ], 403);
        }

        $avis = Avis::with(['logement'])
            ->where('etudiant_id', $user->etudiant->etudiant_id)
            ->orderBy('dateAvis', 'desc')
            ->get();

        return response()->json([
            'status' => true,
            'avis' => $avis
        ], 200);
    }
}