<?php

namespace App\Http\Controllers;

use App\Models\Universite;
use Illuminate\Http\Request;
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
        $universites = Universite::orderBy('nom')->get();

        return response()->json([
            'status' => true,
            'universites' => $universites
        ], 200);
    }

    /**
     * Store a newly created university.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nom' => 'required|string|max:255|unique:universites',
            'localisation' => 'required|string|max:255',
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
        $universite = Universite::find($id);

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
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
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
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $universite->update($request->only(['nom', 'localisation']));

        return response()->json([
            'status' => true,
            'message' => 'University updated successfully',
            'universite' => $universite
        ], 200);
    }

    /**
     * Remove the specified university.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $universite = Universite::find($id);

        if (!$universite) {
            return response()->json([
                'status' => false,
                'message' => 'University not found'
            ], 404);
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

        if ($request->has('nom')) {
            $query->where('nom', 'like', '%' . $request->nom . '%');
        }

        if ($request->has('localisation')) {
            $query->where('localisation', 'like', '%' . $request->localisation . '%');
        }

        $universites = $query->orderBy('nom')->get();

        return response()->json([
            'status' => true,
            'universites' => $universites
        ], 200);
    }
}
