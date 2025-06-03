<?php

namespace App\Http\Controllers;

use App\Models\Message;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MessageController extends Controller
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

        $messages = Message::where('expediteur_id', $user->user_id)
            ->orWhere('destinataire_id', $user->user_id)
            ->with(['expediteur', 'destinataire'])
            ->orderBy('date_envoie', 'desc')
            ->get();

        return response()->json([
            'status' => true,
            'messages' => $messages
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

        $validator = Validator::make($request->all(), [
            'destinataire_id' => 'required|exists:utilisateurs,user_id',
            'contenu' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        if ($request->destinataire_id == $user->user_id) {
            return response()->json([
                'status' => false,
                'message' => 'You cannot send a message to yourself'
            ], 400);
        }

        $message = Message::create([
            'expediteur_id' => $user->user_id,
            'destinataire_id' => $request->destinataire_id,
            'contenu' => $request->contenu,
            'date_envoie' => now(),
        ]);

        return response()->json([
            'status' => true,
            'message' => 'Message sent successfully',
            'data' => $message
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
        $message = Message::with(['expediteur', 'destinataire'])->find($id);

        if (!$message) {
            return response()->json([
                'status' => false,
                'message' => 'Message not found'
            ], 404);
        }

        // Check if the user is authorized to view this message
        if ($message->expediteur_id != $user->user_id && $message->destinataire_id != $user->user_id) {
            return response()->json([
                'status' => false,
                'message' => 'You are not authorized to view this message'
            ], 403);
        }

        return response()->json([
            'status' => true,
            'message' => $message
        ], 200);
    }

    /**
     * Get conversation between two users.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $userId
     * @return \Illuminate\Http\Response
     */
    public function getConversation(Request $request, $userId)
    {
        $user = $request->user();

        // Check if the other user exists
        $otherUser = User::find($userId);
        if (!$otherUser) {
            return response()->json([
                'status' => false,
                'message' => 'User not found'
            ], 404);
        }

        $messages = Message::where(function ($query) use ($user, $userId) {
                $query->where('expediteur_id', $user->user_id)
                      ->where('destinataire_id', $userId);
            })
            ->orWhere(function ($query) use ($user, $userId) {
                $query->where('expediteur_id', $userId)
                      ->where('destinataire_id', $user->user_id);
            })
            ->with(['expediteur', 'destinataire'])
            ->orderBy('date_envoie', 'asc')
            ->get();

        return response()->json([
            'status' => true,
            'messages' => $messages
        ], 200);
    }

    /**
     * Delete a message.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $id)
    {
        $user = $request->user();
        $message = Message::find($id);

        if (!$message) {
            return response()->json([
                'status' => false,
                'message' => 'Message not found'
            ], 404);
        }

        // Check if the user is authorized to delete this message
        if ($message->expediteur_id != $user->user_id) {
            return response()->json([
                'status' => false,
                'message' => 'You can only delete messages you sent'
            ], 403);
        }

        $message->delete();

        return response()->json([
            'status' => true,
            'message' => 'Message deleted successfully'
        ], 200);
    }
}
