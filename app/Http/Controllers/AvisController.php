<?php

namespace App\Http\Controllers;

use App\Models\Avis;
use App\Models\Reservation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class AvisController extends Controller
{
    /**
     * Display a listing of all reviews (Admin only).
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'admin') {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Admin privileges required.'
            ], 403);
        }

        $avis = Avis::with(['etudiant.utilisateur', 'logement'])
            ->orderBy('dateAvis', 'desc')
            ->paginate(15);

        return response()->json([
            'status' => true,
            'avis' => $avis
        ], 200);
    }

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
     * Display the specified review.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $id)
    {
        $user = $request->user();
        $avis = Avis::with(['etudiant.utilisateur', 'logement'])->find($id);

        if (!$avis) {
            return response()->json([
                'status' => false,
                'message' => 'Review not found'
            ], 404);
        }

        // Admin peut voir n'importe quel avis
        if ($user->role !== 'admin') {
            // Vérifier si l'utilisateur peut voir cet avis
            if ($user->isEtudiant() && $avis->etudiant_id != $user->etudiant->etudiant_id) {
                return response()->json([
                    'status' => false,
                    'message' => 'You can only view your own reviews'
                ], 403);
            } elseif ($user->isBailleur()) {
                // Les bailleurs peuvent voir les avis de leurs logements
                if ($avis->logement->bailleur_id != $user->bailleur->bailleur_id) {
                    return response()->json([
                        'status' => false,
                        'message' => 'You can only view reviews for your properties'
                    ], 403);
                }
            }
        }

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
        $avis = Avis::find($id);

        if (!$avis) {
            return response()->json([
                'status' => false,
                'message' => 'Review not found'
            ], 404);
        }

        // Admin peut modifier n'importe quel avis
        if ($user->role === 'admin') {
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
            $avis->load(['etudiant.utilisateur', 'logement']);

            return response()->json([
                'status' => true,
                'message' => 'Review updated successfully by admin',
                'avis' => $avis
            ], 200);
        }

        // Logique existante pour les étudiants
        if (!$user->isEtudiant()) {
            return response()->json([
                'status' => false,
                'message' => 'Only students and admins can update reviews'
            ], 403);
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
        $avis = Avis::find($id);

        if (!$avis) {
            return response()->json([
                'status' => false,
                'message' => 'Review not found'
            ], 404);
        }

        // Admin peut supprimer n'importe quel avis
        if ($user->role === 'admin') {
            $avis->delete();
            return response()->json([
                'status' => true,
                'message' => 'Review deleted successfully by admin'
            ], 200);
        }

        // Logique existante pour les étudiants
        if (!$user->isEtudiant()) {
            return response()->json([
                'status' => false,
                'message' => 'Only students and admins can delete reviews'
            ], 403);
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

    /**
     * Search reviews (Admin only).
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function search(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'admin') {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Admin privileges required.'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'search' => 'required|string|min:1',
            'type' => 'in:comment,student,housing,note', // recherche par commentaire, étudiant, logement ou note
            'note' => 'integer|min:1|max:5', // filtre optionnel par note
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $search = $request->input('search');
        $type = $request->input('type', 'comment');
        $noteFilter = $request->input('note');

        $query = Avis::with(['etudiant.utilisateur', 'logement']);

        switch ($type) {
            case 'student':
                $query->whereHas('etudiant.utilisateur', function($q) use ($search) {
                    $q->where('nom', 'LIKE', "%{$search}%")
                    ->orWhere('prenom', 'LIKE', "%{$search}%");
                });
                break;
            case 'housing':
                $query->whereHas('logement', function($q) use ($search) {
                    $q->where('titre', 'LIKE', "%{$search}%")
                    ->orWhere('description', 'LIKE', "%{$search}%");
                });
                break;
            case 'note':
                $query->where('note', $search);
                break;
            default: // comment
                $query->where('commentaire', 'LIKE', "%{$search}%");
                break;
        }

        // Filtre optionnel par note
        if ($noteFilter) {
            $query->where('note', $noteFilter);
        }

        $avis = $query->orderBy('dateAvis', 'desc')
                    ->paginate(15);

        return response()->json([
            'status' => true,
            'avis' => $avis
        ], 200);
    }

    /**
     * Get reviews statistics (Admin only).
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function statistics(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'admin') {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Admin privileges required.'
            ], 403);
        }

        $stats = [
            'total_reviews' => Avis::count(),
            'average_rating' => round(Avis::avg('note'), 2),
            'reviews_by_rating' => [
                '5_stars' => Avis::where('note', 5)->count(),
                '4_stars' => Avis::where('note', 4)->count(),
                '3_stars' => Avis::where('note', 3)->count(),
                '2_stars' => Avis::where('note', 2)->count(),
                '1_star' => Avis::where('note', 1)->count(),
            ],
            'reviews_today' => Avis::whereDate('dateAvis', today())->count(),
            'reviews_this_week' => Avis::whereBetween('dateAvis', [now()->startOfWeek(), now()->endOfWeek()])->count(),
            'reviews_this_month' => Avis::whereMonth('dateAvis', now()->month)->count(),
            'top_rated_housings' => Avis::select('logement_id')
                ->selectRaw('AVG(note) as avg_rating, COUNT(*) as review_count')
                ->with('logement:logement_id,titre')
                ->groupBy('logement_id')
                ->having('review_count', '>=', 3) // Au moins 3 avis
                ->orderBy('avg_rating', 'desc')
                ->limit(5)
                ->get(),
            'most_active_reviewers' => Avis::select('etudiant_id')
                ->selectRaw('COUNT(*) as review_count')
                ->with('etudiant.utilisateur:user_id,nom,prenom')
                ->groupBy('etudiant_id')
                ->orderBy('review_count', 'desc')
                ->limit(5)
                ->get()
        ];

        return response()->json([
            'status' => true,
            'statistics' => $stats
        ], 200);
    }

    /**
     * Moderate review (Admin only) - Marquer un avis comme inapproprié ou le restaurer.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function moderate(Request $request, $id)
    {
        $user = $request->user();

        if ($user->role !== 'admin') {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Admin privileges required.'
            ], 403);
        }

        $avis = Avis::find($id);
        if (!$avis) {
            return response()->json([
                'status' => false,
                'message' => 'Review not found'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'action' => 'required|in:hide,show',
            'reason' => 'string|max:500'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $action = $request->input('action');
        $reason = $request->input('reason', '');

        // Supposons qu'il y ait un champ 'moderated' dans la table avis
        $avis->update([
            'moderated' => $action === 'hide',
            'moderation_reason' => $reason,
            'moderated_by' => $user->user_id,
            'moderated_at' => now()
        ]);

        return response()->json([
            'status' => true,
            'message' => $action === 'hide' ? 'Review hidden successfully' : 'Review shown successfully',
            'avis' => $avis
        ], 200);
    }
}