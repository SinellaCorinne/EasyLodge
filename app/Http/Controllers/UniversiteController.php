<?php

namespace App\Http\Controllers;

use App\Models\Universite;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class UniversiteController extends Controller
{
    /**
     * Display a listing of universities.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        // Les admins peuvent voir toutes les universités avec plus de détails
        if (Auth::user() && Auth::user()->role === 'admin') {
            $universites = Universite::withCount(['etudiants', 'logements'])
                ->orderBy('nom')
                ->get();
        } else {
            // Utilisateurs normaux voient seulement les informations de base
            $universites = Universite::select('universite_id', 'nom', 'localisation')
                ->orderBy('nom')
                ->get();
        }

        return response()->json([
            'status' => true,
            'universites' => $universites
        ], 200);
    }

    /**
     * Store a newly created university.
     * Seuls les admins peuvent créer des universités.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        // Vérifier si l'utilisateur est admin
        if (!Auth::user() || Auth::user()->role !== 'admin') {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Only administrators can create universities.'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'nom' => 'required|string|max:255|unique:universites',
            'localisation' => 'required|string|max:255',
            'description' => 'nullable|string|max:1000',
            'site_web' => 'nullable|url|max:255',
            'email_contact' => 'nullable|email|max:255',
            'telephone' => 'nullable|string|max:20',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $universite = Universite::create([
            'nom' => $request->nom,
            'localisation' => $request->localisation,
            'description' => $request->description,
            'site_web' => $request->site_web,
            'email_contact' => $request->email_contact,
            'telephone' => $request->telephone,
            'created_by' => Auth::id(),
        ]);

        return response()->json([
            'status' => true,
            'message' => 'University created successfully',
            'universite' => $universite
        ], 201);
    }

    /**
     * Display the specified university.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        // Les admins peuvent voir toutes les informations détaillées
        if (Auth::user() && Auth::user()->role === 'admin') {
            $universite = Universite::with(['etudiants', 'logements'])
                ->withCount(['etudiants', 'logements'])
                ->find($id);
        } else {
            // Utilisateurs normaux voient les informations de base
            $universite = Universite::select('universite_id', 'nom', 'localisation', 'description', 'site_web')
                ->find($id);
        }

        if (!$universite) {
            return response()->json([
                'status' => false,
                'message' => 'University not found'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'universite' => $universite
        ], 200);
    }

    /**
     * Update the specified university.
     * Seuls les admins peuvent modifier les universités.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        // Vérifier si l'utilisateur est admin
        if (!Auth::user() || Auth::user()->role !== 'admin') {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Only administrators can update universities.'
            ], 403);
        }

        $universite = Universite::find($id);

        if (!$universite) {
            return response()->json([
                'status' => false,
                'message' => 'University not found'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'nom' => 'string|max:255|unique:universites,nom,' . $id . ',universite_id',
            'localisation' => 'string|max:255',
            'description' => 'nullable|string|max:1000',
            'site_web' => 'nullable|url|max:255',
            'email_contact' => 'nullable|email|max:255',
            'telephone' => 'nullable|string|max:20',
            'is_active' => 'boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $universite->update($request->only([
            'nom',
            'localisation',
            'description',
            'site_web',
            'email_contact',
            'telephone',
            'is_active'
        ]));

        return response()->json([
            'status' => true,
            'message' => 'University updated successfully',
            'universite' => $universite
        ], 200);
    }

    /**
     * Remove the specified university.
     * Seuls les admins peuvent supprimer les universités.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        // Vérifier si l'utilisateur est admin
        if (!Auth::user() || Auth::user()->role !== 'admin') {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Only administrators can delete universities.'
            ], 403);
        }

        $universite = Universite::find($id);

        if (!$universite) {
            return response()->json([
                'status' => false,
                'message' => 'University not found'
            ], 404);
        }

        // Vérifier s'il y a des étudiants ou logements liés
        $etudiants_count = $universite->etudiants()->count();
        $logements_count = $universite->logements()->count();

        if ($etudiants_count > 0 || $logements_count > 0) {
            return response()->json([
                'status' => false,
                'message' => 'Cannot delete university. It has associated students or accommodations.',
                'details' => [
                    'students_count' => $etudiants_count,
                    'accommodations_count' => $logements_count
                ]
            ], 422);
        }

        $universite->delete();

        return response()->json([
            'status' => true,
            'message' => 'University deleted successfully'
        ], 200);
    }

    /**
     * Search universities.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function search(Request $request)
    {
        $query = Universite::query();

        // Les admins peuvent voir plus d'informations dans les résultats
        if (Auth::user() && Auth::user()->role === 'admin') {
            $query->withCount(['etudiants', 'logements']);
        } else {
            $query->select('universite_id', 'nom', 'localisation', 'description');
        }

        if ($request->has('nom')) {
            $query->where('nom', 'like', '%' . $request->nom . '%');
        }

        if ($request->has('localisation')) {
            $query->where('localisation', 'like', '%' . $request->localisation . '%');
        }

        // Recherche avancée pour les admins
        if (Auth::user() && Auth::user()->role === 'admin') {
            if ($request->has('is_active')) {
                $query->where('is_active', $request->is_active);
            }

            if ($request->has('email_contact')) {
                $query->where('email_contact', 'like', '%' . $request->email_contact . '%');
            }
        }

        $universites = $query->orderBy('nom')->get();

        return response()->json([
            'status' => true,
            'universites' => $universites,
            'total' => $universites->count()
        ], 200);
    }

    /**
     * Get university statistics (Admin only).
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function getStatistics($id)
    {
        // Seuls les admins peuvent voir les statistiques
        if (!Auth::user() || Auth::user()->role !== 'admin') {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Only administrators can view university statistics.'
            ], 403);
        }

        $universite = Universite::find($id);

        if (!$universite) {
            return response()->json([
                'status' => false,
                'message' => 'University not found'
            ], 404);
        }

        $statistics = [
            'total_students' => $universite->etudiants()->count(),
            'active_students' => $universite->etudiants()->where('is_active', true)->count(),
            'total_accommodations' => $universite->logements()->count(),
            'available_accommodations' => $universite->logements()->where('disponible', true)->count(),
            'total_reservations' => $universite->reservations()->count(),
            'active_reservations' => $universite->reservations()->where('statut', 'confirmee')->count(),
        ];

        return response()->json([
            'status' => true,
            'universite' => $universite->nom,
            'statistics' => $statistics
        ], 200);
    }

    /**
     * Toggle university status (Admin only).
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function toggleStatus($id)
    {
        // Seuls les admins peuvent changer le statut
        if (!Auth::user() || Auth::user()->role !== 'admin') {
            return response()->json([
                'status' => false,
                'message' => 'Access denied. Only administrators can toggle university status.'
            ], 403);
        }

        $universite = Universite::find($id);

        if (!$universite) {
            return response()->json([
                'status' => false,
                'message' => 'University not found'
            ], 404);
        }

        $universite->is_active = !$universite->is_active;
        $universite->save();

        return response()->json([
            'status' => true,
            'message' => 'University status updated successfully',
            'universite' => $universite
        ], 200);
    }
}
