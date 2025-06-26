<?php

namespace App\Http\Controllers;

use App\Models\Reservation;
use App\Models\Logement;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ReservationController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->isEtudiant()) {
            $reservations = Reservation::with(['logement', 'paiement'])
                ->where('etudiant_id', $user->etudiant->etudiant_id)
                ->get();
        } elseif ($user->isBailleur()) {
            $bailleurId = $user->bailleur->bailleur_id;
            $reservations = Reservation::with(['etudiant.utilisateur', 'logement', 'paiement'])
                ->whereHas('logement', function ($query) use ($bailleurId) {
                    $query->where('bailleur_id', $bailleurId);
                })
                ->get();
        } elseif ($user->isAdmin()) {
            // Admin peut voir toutes les réservations
            $reservations = Reservation::with(['etudiant.utilisateur', 'logement', 'paiement'])->get();
        } else {
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized'
            ], 403);
        }

        return response()->json([
            'status' => true,
            'reservations' => $reservations
        ], 200);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $user = $request->user();

        // Seuls les étudiants peuvent faire des réservations (pas les admins)
        if (!$user->isEtudiant()) {
            return response()->json([
                'status' => false,
                'message' => 'Only students can make reservations'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'logement_id' => 'required|exists:logements,logement_id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $logement = Logement::find($request->logement_id);

        if (!$logement->disponibilite) {
            return response()->json([
                'status' => false,
                'message' => 'This housing is not available for reservation'
            ], 400);
        }

        $reservation = Reservation::create([
            'logement_id' => $request->logement_id,
            'etudiant_id' => $user->etudiant->etudiant_id,
            'statut' => 'en_attente',
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Reservation created successfully',
            'reservation' => $reservation
        ], 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $id)
    {
        $user = $request->user();
        $reservation = Reservation::with(['logement', 'etudiant.utilisateur', 'paiement'])->find($id);

        if (!$reservation) {
            return response()->json([
                'status' => false,
                'message' => 'Reservation not found'
            ], 404);
        }

        // Check if the user is authorized to view this reservation
        if ($user->isEtudiant() && $reservation->etudiant_id != $user->etudiant->etudiant_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only view your own reservations'
            ], 403);
        } elseif ($user->isBailleur() && $reservation->logement->bailleur_id != $user->bailleur->bailleur_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only view reservations for your own housing listings'
            ], 403);
        }
        // Admin peut voir toutes les réservations - pas de vérification supplémentaire

        return response()->json([
            'status' => true,
            'reservation' => $reservation
        ], 200);
    }

    /**
     * Update the status of a reservation.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function updateStatus(Request $request, $id)
    {
        $user = $request->user();
        $reservation = Reservation::find($id);

        if (!$reservation) {
            return response()->json([
                'status' => false,
                'message' => 'Reservation not found'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'statut' => 'required|in:en_attente,confirmee,annulee',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Check if the user is authorized to update this reservation
        if ($user->isEtudiant()) {
            if ($reservation->etudiant_id != $user->etudiant->etudiant_id) {
                return response()->json([
                    'status' => false,
                    'message' => 'You can only update your own reservations'
                ], 403);
            }

            // Students can only cancel their reservations
            if ($request->statut != 'annulee') {
                return response()->json([
                    'status' => false,
                    'message' => 'Students can only cancel reservations'
                ], 403);
            }
        } elseif ($user->isBailleur()) {
            // Check if the reservation is for a housing owned by this landlord
            $logement = Logement::find($reservation->logement_id);
            if ($logement->bailleur_id != $user->bailleur->bailleur_id) {
                return response()->json([
                    'status' => false,
                    'message' => 'You can only update reservations for your own housing listings'
                ], 403);
            }
        } elseif (!$user->isAdmin()) {
            // Si ce n'est ni étudiant, ni bailleur, ni admin
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized'
            ], 403);
        }
        // Admin peut modifier toutes les réservations sans restriction

        $reservation->update([
            'statut' => $request->statut
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Reservation status updated successfully',
            'reservation' => $reservation
        ], 200);
    }

    /**
     * Remove the specified reservation from storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $id)
    {
        $user = $request->user();
        $reservation = Reservation::find($id);

        if (!$reservation) {
            return response()->json([
                'status' => false,
                'message' => 'Reservation not found'
            ], 404);
        }

        // Check if the user is authorized to delete this reservation
        if ($user->isEtudiant()) {
            if ($reservation->etudiant_id != $user->etudiant->etudiant_id) {
                return response()->json([
                    'status' => false,
                    'message' => 'You can only delete your own reservations'
                ], 403);
            }
        } elseif ($user->isBailleur()) {
            if ($reservation->logement->bailleur_id != $user->bailleur->bailleur_id) {
                return response()->json([
                    'status' => false,
                    'message' => 'You can only delete reservations for your own housing listings'
                ], 403);
            }
        } elseif (!$user->isAdmin()) {
            // Si ce n'est ni étudiant, ni bailleur, ni admin
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized'
            ], 403);
        }
        // Admin peut supprimer toutes les réservations

        // Check if the reservation has an associated payment
        if ($reservation->paiement) {
            return response()->json([
                'status' => false,
                'message' => 'Cannot delete reservation with an existing payment'
            ], 400);
        }

        $reservation->delete();

        return response()->json([
            'status' => true,
            'message' => 'Reservation deleted successfully'
        ], 200);
    }
}
