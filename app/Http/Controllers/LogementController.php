<?php

namespace App\Http\Controllers;

use App\Models\Logement;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;

class LogementController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $user = Auth::user();

        if ($user && $user->isAdmin()) {
            // Les admins voient tous les logements avec toutes les relations et statistiques
            $logements = Logement::with([
                'bailleur.utilisateur',
                'reservations' => function($query) {
                    $query->latest()->take(5);
                },
                'paiements' => function($query) {
                    $query->latest()->take(3);
                }
            ])
            ->withCount(['reservations', 'paiements'])
            ->orderBy('created_at', 'desc')
            ->get();

        } elseif ($user && $user->isBailleur()) {
            // Les bailleurs voient seulement leurs logements avec relations complètes
            $logements = Logement::with([
                'bailleur.utilisateur',
                'reservations',
                'paiements'
            ])
            ->where('bailleur_id', $user->bailleur->bailleur_id)
            ->withCount(['reservations', 'paiements'])
            ->orderBy('created_at', 'desc')
            ->get();

        } else {
            // Utilisateurs normaux (étudiants) voient seulement les logements disponibles
            $logements = Logement::with(['bailleur.utilisateur'])
                ->where('disponibilite', true)
                ->where('is_active', true)
                ->orderBy('created_at', 'desc')
                ->get();
        }

        return response()->json([
            'status' => true,
            'logements' => $logements,
            'total' => $logements->count()
        ], 200);
    }

    /**
     * Store a newly created resource in storage.
     * Bailleurs créent leurs logements, admins peuvent créer pour n'importe quel bailleur.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $user = $request->user();

        if (!$user->isBailleur() && !$user->isAdmin()) {
            return response()->json([
                'status' => false,
                'message' => 'Only landlords and administrators can create housing listings'
            ], 403);
        }

        $validationRules = [
            'titre' => 'required|string|max:255',
            'description' => 'required|string',
            'type' => 'required|string|max:255',
            'prix' => 'required|numeric|min:0',
            'localisation' => 'required|string|max:255',
            'photo' => 'nullable|string',
            'superficie' => 'nullable|numeric|min:0',
            'nombre_pieces' => 'nullable|integer|min:1',
            'equipements' => 'nullable|string',
            'is_active' => 'boolean',
        ];

        // Les admins peuvent spécifier pour quel bailleur créer le logement
        if ($user->isAdmin()) {
            $validationRules['bailleur_id'] = 'nullable|exists:bailleurs,bailleur_id';
        }

        $validator = Validator::make($request->all(), $validationRules);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Déterminer le bailleur_id
        if ($user->isAdmin() && $request->has('bailleur_id')) {
            $bailleur_id = $request->bailleur_id;
        } else {
            $bailleur = $user->bailleur;
            if (!$bailleur) {
                return response()->json([
                    'status' => false,
                    'message' => 'User is not associated with a landlord profile'
                ], 400);
            }
            $bailleur_id = $bailleur->bailleur_id;
        }

        $logement = Logement::create([
            'titre' => $request->titre,
            'description' => $request->description,
            'type' => $request->type,
            'prix' => $request->prix,
            'localisation' => $request->localisation,
            'disponibilite' => true,
            'photo' => $request->photo,
            'superficie' => $request->superficie,
            'nombre_pieces' => $request->nombre_pieces,
            'equipements' => $request->equipements,
            'is_active' => $request->get('is_active', true),
            'bailleur_id' => $bailleur_id,
            'created_by' => $user->utilisateur_id,
        ]);

        // Load the relationships
        $logement->load('bailleur.utilisateur');

        return response()->json([
            'status' => true,
            'message' => 'Housing created successfully',
            'logement' => $logement
        ], 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $user = Auth::user();

        if ($user && $user->isAdmin()) {
            // Les admins voient tout avec toutes les relations
            $logement = Logement::with([
                'bailleur.utilisateur',
                'reservations.etudiant.utilisateur',
                'paiements',
                'evaluations'
            ])
            ->withCount(['reservations', 'paiements', 'evaluations'])
            ->find($id);

        } elseif ($user && $user->isBailleur()) {
            // Les bailleurs voient leurs logements avec détails complets
            $logement = Logement::with([
                'bailleur.utilisateur',
                'reservations.etudiant.utilisateur',
                'paiements',
                'evaluations'
            ])
            ->find($id);

            // Vérifier que le logement appartient au bailleur (sauf si admin)
            if ($logement && $logement->bailleur_id != $user->bailleur->bailleur_id) {
                $logement = Logement::with(['bailleur.utilisateur'])
                    ->where('disponibilite', true)
                    ->where('is_active', true)
                    ->find($id);
            }

        } else {
            // Étudiants et visiteurs voient seulement les infos de base des logements disponibles
            $logement = Logement::with(['bailleur.utilisateur', 'evaluations'])
                ->where('disponibilite', true)
                ->where('is_active', true)
                ->find($id);
        }

        if (!$logement) {
            return response()->json([
                'status' => false,
                'message' => 'Housing not found or not accessible'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'logement' => $logement
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $user = $request->user();

        if (!$user->isBailleur() && !$user->isAdmin()) {
            return response()->json([
                'status' => false,
                'message' => 'Only landlords and administrators can update housing listings'
            ], 403);
        }

        $logement = Logement::find($id);

        if (!$logement) {
            return response()->json([
                'status' => false,
                'message' => 'Housing not found'
            ], 404);
        }

        // Vérifier les permissions (admins peuvent tout modifier)
        if ($user->isBailleur() && $logement->bailleur_id != $user->bailleur->bailleur_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only update your own housing listings'
            ], 403);
        }

        $validationRules = [
            'titre' => 'string|max:255',
            'description' => 'string',
            'type' => 'string|max:255',
            'prix' => 'numeric|min:0',
            'localisation' => 'string|max:255',
            'disponibilite' => 'boolean',
            'photo' => 'nullable|string',
            'superficie' => 'nullable|numeric|min:0',
            'nombre_pieces' => 'nullable|integer|min:1',
            'equipements' => 'nullable|string',
        ];

        // Les admins peuvent modifier des champs supplémentaires
        if ($user->isAdmin()) {
            $validationRules['is_active'] = 'boolean';
            $validationRules['bailleur_id'] = 'exists:bailleurs,bailleur_id';
            $validationRules['featured'] = 'boolean';
            $validationRules['admin_notes'] = 'nullable|string';
        }

        $validator = Validator::make($request->all(), $validationRules);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Préparer les données à mettre à jour
        $updateData = $request->only([
            'titre', 'description', 'type', 'prix', 'localisation',
            'disponibilite', 'photo', 'superficie', 'nombre_pieces', 'equipements'
        ]);

        // Ajouter les champs admin si nécessaire
        if ($user->isAdmin()) {
            $adminFields = $request->only([
                'is_active', 'bailleur_id', 'featured', 'admin_notes'
            ]);
            $updateData = array_merge($updateData, $adminFields);
        }

        $logement->update($updateData);

        // Load the relationships
        $logement->load('bailleur.utilisateur');

        return response()->json([
            'status' => true,
            'message' => 'Housing updated successfully',
            'logement' => $logement
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $id)
    {
        $user = $request->user();

        if (!$user->isBailleur() && !$user->isAdmin()) {
            return response()->json([
                'status' => false,
                'message' => 'Only landlords and administrators can delete housing listings'
            ], 403);
        }

        $logement = Logement::find($id);

        if (!$logement) {
            return response()->json([
                'status' => false,
                'message' => 'Housing not found'
            ], 404);
        }

        // Les admins peuvent supprimer n'importe quel logement
        // Les bailleurs ne peuvent supprimer que leurs propres logements
        if ($user->isBailleur() && $logement->bailleur_id != $user->bailleur->bailleur_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only delete your own housing listings'
            ], 403);
        }

        // Vérifier s'il y a des réservations actives
        $activeReservations = $logement->reservations()->where('statut', 'confirmee')->count();

        if ($activeReservations > 0 && $user->isBailleur()) {
            return response()->json([
                'status' => false,
                'message' => 'Cannot delete housing with active reservations. Please contact an administrator.',
                'active_reservations' => $activeReservations
            ], 422);
        }

        // Les admins peuvent forcer la suppression même avec des réservations actives
        if ($activeReservations > 0 && $user->isAdmin()) {
            // Annuler toutes les réservations actives
            $logement->reservations()->where('statut', 'confirmee')->update([
                'statut' => 'annulee',
                'raison_annulation' => 'Logement supprimé par l\'administrateur'
            ]);
        }

        $logement->delete();

        return response()->json([
            'status' => true,
            'message' => 'Housing deleted successfully',
            'cancelled_reservations' => $activeReservations
        ], 200);
    }

    /**
     * Search for housing based on criteria.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function search(Request $request)
    {
        $user = Auth::user();
        $query = Logement::query();

        // Filtres de base
        if ($request->has('type')) {
            $query->where('type', 'like', '%' . $request->type . '%');
        }

        if ($request->has('localisation')) {
            $query->where('localisation', 'like', '%' . $request->localisation . '%');
        }

        if ($request->has('prix_min')) {
            $query->where('prix', '>=', $request->prix_min);
        }

        if ($request->has('prix_max')) {
            $query->where('prix', '<=', $request->prix_max);
        }

        if ($request->has('superficie_min')) {
            $query->where('superficie', '>=', $request->superficie_min);
        }

        if ($request->has('nombre_pieces')) {
            $query->where('nombre_pieces', $request->nombre_pieces);
        }

        // Gestion de la disponibilité selon le rôle
        if ($user && $user->isAdmin()) {
            // Les admins peuvent rechercher tous les logements
            if ($request->has('disponibilite')) {
                $query->where('disponibilite', $request->disponibilite);
            }
            if ($request->has('is_active')) {
                $query->where('is_active', $request->is_active);
            }
            if ($request->has('bailleur_id')) {
                $query->where('bailleur_id', $request->bailleur_id);
            }
            if ($request->has('featured')) {
                $query->where('featured', $request->featured);
            }

            // Relations complètes pour les admins
            $query->with([
                'bailleur.utilisateur',
                'reservations' => function($q) { $q->latest()->take(3); }
            ])->withCount(['reservations', 'paiements']);

        } elseif ($user && $user->isBailleur()) {
            // Les bailleurs peuvent voir leurs logements et ceux disponibles des autres
            if ($request->has('mes_logements') && $request->mes_logements) {
                $query->where('bailleur_id', $user->bailleur->bailleur_id);
                if ($request->has('disponibilite')) {
                    $query->where('disponibilite', $request->disponibilite);
                }
            } else {
                $query->where('disponibilite', true)->where('is_active', true);
            }

            $query->with(['bailleur.utilisateur'])->withCount(['reservations']);

        } else {
            // Utilisateurs normaux voient seulement les logements disponibles et actifs
            $query->where('disponibilite', true)->where('is_active', true);
            $query->with(['bailleur.utilisateur']);
        }

        $logements = $query->orderBy('created_at', 'desc')->get();

        return response()->json([
            'status' => true,
            'logements' => $logements,
            'total' => $logements->count(),
            'filters_applied' => $request->all()
        ], 200);
    }

    /**
     * Get housing statistics (Admin only).
     *
     * @return \Illuminate\Http\Response
     */
    public function getStatistics()
    {
        $user = Auth::user();

        if (!$user || !$user->isAdmin()) {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Only administrators can view housing statistics.'
            ], 403);
        }

        $statistics = [
            'total_logements' => Logement::count(),
            'logements_disponibles' => Logement::where('disponibilite', true)->count(),
            'logements_actifs' => Logement::where('is_active', true)->count(),
            'logements_avec_reservations' => Logement::has('reservations')->count(),
            'prix_moyen' => Logement::avg('prix'),
            'superficie_moyenne' => Logement::avg('superficie'),
            'logements_par_type' => Logement::selectRaw('type, COUNT(*) as count')
                ->groupBy('type')
                ->get(),
            'logements_par_localisation' => Logement::selectRaw('localisation, COUNT(*) as count')
                ->groupBy('localisation')
                ->orderBy('count', 'desc')
                ->take(10)
                ->get(),
        ];

        return response()->json([
            'status' => true,
            'statistics' => $statistics
        ], 200);
    }

    /**
     * Toggle housing status (Admin only).
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function toggleStatus($id)
    {
        $user = Auth::user();

        if (!$user || !$user->isAdmin()) {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Only administrators can toggle housing status.'
            ], 403);
        }

        $logement = Logement::find($id);

        if (!$logement) {
            return response()->json([
                'status' => false,
                'message' => 'Housing not found'
            ], 404);
        }

        $logement->is_active = !$logement->is_active;
        $logement->save();

        return response()->json([
            'status' => true,
            'message' => 'Housing status updated successfully',
            'logement' => $logement
        ], 200);
    }

    /**
     * Feature/unfeature a housing (Admin only).
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function toggleFeatured($id)
    {
        $user = Auth::user();

        if (!$user || !$user->isAdmin()) {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Only administrators can feature housing.'
            ], 403);
        }

        $logement = Logement::find($id);

        if (!$logement) {
            return response()->json([
                'status' => false,
                'message' => 'Housing not found'
            ], 404);
        }

        $logement->featured = !$logement->featured;
        $logement->save();

        return response()->json([
            'status' => true,
            'message' => 'Housing featured status updated successfully',
            'logement' => $logement
        ], 200);
    }
}
