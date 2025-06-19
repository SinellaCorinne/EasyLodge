<?php

namespace App\Http\Controllers;

use App\Models\Paiement;
use App\Models\Reservation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PaiementController extends Controller
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
            $paiements = Paiement::with('reservation.logement')
                ->whereHas('reservation', function ($query) use ($user) {
                    $query->where('etudiant_id', $user->etudiant->etudiant_id);
                })
                ->get();
        } elseif ($user->isBailleur()) {
            $bailleurId = $user->bailleur->bailleur_id;
            $paiements = Paiement::with('reservation.etudiant.utilisateur')
                ->whereHas('reservation.logement', function ($query) use ($bailleurId) {
                    $query->where('bailleur_id', $bailleurId);
                })
                ->get();
        } else {
            return response()->json([
                'status' => false,
                'message' => 'Unauthorized'
            ], 403);
        }

        return response()->json([
            'status' => true,
            'paiements' => $paiements
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

        if (!$user->isEtudiant()) {
            return response()->json([
                'status' => false,
                'message' => 'Only students can make payments'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'reservation_id' => 'required|exists:reservations,reservation_id',
            'montant' => 'required|numeric|min:0',
            'methode_paie' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $reservation = Reservation::find($request->reservation_id);

        if (!$reservation) {
            return response()->json([
                'status' => false,
                'message' => 'Reservation not found'
            ], 404);
        }

        if ($reservation->etudiant_id != $user->etudiant->etudiant_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only make payments for your own reservations'
            ], 403);
        }

        if ($reservation->statut !== 'confirmee') {
            return response()->json([
                'status' => false,
                'message' => 'You can only make payments for confirmed reservations'
            ], 400);
        }

        // Check if payment already exists
        $existingPayment = Paiement::where('reservation_id', $request->reservation_id)->first();
        if ($existingPayment) {
            return response()->json([
                'status' => false,
                'message' => 'A payment already exists for this reservation'
            ], 400);
        }

        // Generate unique reference
        $reference = $this->generatePaymentReference();

        $paiement = Paiement::create([
            'reference' => $reference,
            'reservation_id' => $request->reservation_id,
            'montant' => $request->montant,
            'methode_paie' => $request->methode_paie,
            'statut' => 'en_attente',
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Payment created successfully',
            'paiement' => $paiement
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
        $paiement = Paiement::with(['reservation.logement', 'reservation.etudiant.utilisateur'])->find($id);

        if (!$paiement) {
            return response()->json([
                'status' => false,
                'message' => 'Payment not found'
            ], 404);
        }

        // Check if the user is authorized to view this payment
        if ($user->isEtudiant() && $paiement->reservation->etudiant_id != $user->etudiant->etudiant_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only view your own payments'
            ], 403);
        } elseif ($user->isBailleur()) {
            $logement = $paiement->reservation->logement;
            if ($logement->bailleur_id != $user->bailleur->bailleur_id) {
                return response()->json([
                    'status' => false,
                    'message' => 'You can only view payments for your own housing listings'
                ], 403);
            }
        }

        return response()->json([
            'status' => true,
            'paiement' => $paiement
        ], 200);
    }

    /**
     * Update the status of a payment.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function updateStatus(Request $request, $id)
    {
        $user = $request->user();
        $paiement = Paiement::find($id);

        if (!$paiement) {
            return response()->json([
                'status' => false,
                'message' => 'Payment not found'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'statut' => 'required|in:en_attente,complete,annule',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Check if the user is authorized to update this payment
        if ($user->isBailleur()) {
            $logement = $paiement->reservation->logement;
            if ($logement->bailleur_id != $user->bailleur->bailleur_id) {
                return response()->json([
                    'status' => false,
                    'message' => 'You can only update payments for your own housing listings'
                ], 403);
            }
        } else {
            return response()->json([
                'status' => false,
                'message' => 'Only landlords can update payment status'
            ], 403);
        }

        $paiement->update([
            'statut' => $request->statut
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Payment status updated successfully',
            'paiement' => $paiement
        ], 200);
    }

    /**
     * Search payments by reference.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function search(Request $request)
    {
        $user = $request->user();

        $validator = Validator::make($request->all(), [
            'reference' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $query = Paiement::with(['reservation.logement', 'reservation.etudiant.utilisateur'])
            ->where('reference', $request->reference);

        // Filter based on user role
        if ($user->isEtudiant()) {
            $query->whereHas('reservation', function ($q) use ($user) {
                $q->where('etudiant_id', $user->etudiant->etudiant_id);
            });
        } elseif ($user->isBailleur()) {
            $bailleurId = $user->bailleur->bailleur_id;
            $query->whereHas('reservation.logement', function ($q) use ($bailleurId) {
                $q->where('bailleur_id', $bailleurId);
            });
        }

        $paiement = $query->first();

        if (!$paiement) {
            return response()->json([
                'status' => false,
                'message' => 'Payment not found'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'paiement' => $paiement
        ], 200);
    }

    /**
     * Generate a unique payment reference.
     *
     * @return string
     */
    private function generatePaymentReference()
    {
        do {
            $reference = 'PAY-' . date('Ymd') . '-' . strtoupper(substr(uniqid(), -8));
        } while (Paiement::where('reference', $reference)->exists());

        return $reference;
    }
}
