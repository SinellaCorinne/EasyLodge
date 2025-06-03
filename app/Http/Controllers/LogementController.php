<?php

namespace App\Http\Controllers;

use App\Models\Logement;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class LogementController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $logements = Logement::with('bailleur.utilisateur')->get();

        return response()->json([
            'status' => true,
            'logements' => $logements
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

        if (!$user->isBailleur()) {
            return response()->json([
                'status' => false,
                'message' => 'Only landlords can create housing listings'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'titre' => 'required|string|max:255',
            'description' => 'required|string',
            'type' => 'required|string|max:255',
            'prix' => 'required|numeric|min:0',
            'localisation' => 'required|string|max:255',
            'photo' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $bailleur = $user->bailleur;

        $logement = Logement::create([
            'titre' => $request->titre,
            'description' => $request->description,
            'type' => $request->type,
            'prix' => $request->prix,
            'localisation' => $request->localisation,
            'disponibilite' => true,
            'photo' => $request->photo,
            'bailleur_id' => $bailleur->bailleur_id,
        ]);

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
        $logement = Logement::with('bailleur.utilisateur')->find($id);

        if (!$logement) {
            return response()->json([
                'status' => false,
                'message' => 'Housing not found'
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

        if (!$user->isBailleur()) {
            return response()->json([
                'status' => false,
                'message' => 'Only landlords can update housing listings'
            ], 403);
        }

        $logement = Logement::find($id);

        if (!$logement) {
            return response()->json([
                'status' => false,
                'message' => 'Housing not found'
            ], 404);
        }

        if ($logement->bailleur_id != $user->bailleur->bailleur_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only update your own housing listings'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'titre' => 'string|max:255',
            'description' => 'string',
            'type' => 'string|max:255',
            'prix' => 'numeric|min:0',
            'localisation' => 'string|max:255',
            'disponibilite' => 'boolean',
            'photo' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $logement->update($request->all());

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

        if (!$user->isBailleur()) {
            return response()->json([
                'status' => false,
                'message' => 'Only landlords can delete housing listings'
            ], 403);
        }

        $logement = Logement::find($id);

        if (!$logement) {
            return response()->json([
                'status' => false,
                'message' => 'Housing not found'
            ], 404);
        }

        if ($logement->bailleur_id != $user->bailleur->bailleur_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only delete your own housing listings'
            ], 403);
        }

        $logement->delete();

        return response()->json([
            'status' => true,
            'message' => 'Housing deleted successfully'
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
        $query = Logement::query();

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

        if ($request->has('disponibilite')) {
            $query->where('disponibilite', $request->disponibilite);
        } else {
            // By default, only show available housing
            $query->where('disponibilite', true);
        }

        $logements = $query->with('bailleur.utilisateur')->get();

        return response()->json([
            'status' => true,
            'logements' => $logements
        ], 200);
    }
}