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

            // Admin peut voir tous les messages du système
            if ($user->role === 'admin') {
                $messages = Message::with(['expediteur', 'destinataire'])
                    ->orderBy('date_envoie', 'desc')
                    ->paginate(15);
            } else {
                // Utilisateurs normaux voient uniquement leurs messages
                $messages = Message::where('expediteur_id', $user->user_id)
                    ->orWhere('destinataire_id', $user->user_id)
                    ->with(['expediteur', 'destinataire'])
                    ->orderBy('date_envoie', 'desc')
                    ->paginate(15); 
            }

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

            // Admin peut consulter n'importe quel message
            if ($user->role !== 'admin') {
                // Check if the user is authorized to view this message
                if ($message->expediteur_id != $user->user_id && $message->destinataire_id != $user->user_id) {
                    return response()->json([
                        'status' => false,
                        'message' => 'You are not authorized to view this message'
                    ], 403);
                }
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
        public function showConversation(Request $request, $userId)
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

            // Admin peut voir n'importe quelle conversation
            if ($user->role === 'admin') {
                // Pour les admins, on peut ajouter un paramètre optionnel pour spécifier l'autre utilisateur de la conversation
                $otherUserId = $request->input('other_user_id', $userId);

                $messages = Message::where(function ($query) use ($userId, $otherUserId) {
                        $query->where('expediteur_id', $userId)
                            ->where('destinataire_id', $otherUserId);
                    })
                    ->orWhere(function ($query) use ($userId, $otherUserId) {
                        $query->where('expediteur_id', $otherUserId)
                            ->where('destinataire_id', $userId);
                    })
                    ->with(['expediteur', 'destinataire'])
                    ->orderBy('date_envoie', 'asc')
                    ->get();
            } else {
                // Utilisateurs normaux voient uniquement leurs conversations
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
            }

            return response()->json([
                'status' => true,
                'messages' => $messages
            ], 200);
        }

        public function markAsRead($id)
        {
            $user = auth()->user();
            $message = Message::find($id);

            if (!$message) {
                return response()->json(['status' => false, 'message' => 'Message not found'], 404);
            }

            // Admin peut marquer n'importe quel message comme lu
            if ($user->role === 'admin' || $message->destinataire_id == $user->user_id) {
                $message->update(['lu_a' => now()]);
                return response()->json(['status' => true]);
            }

            return response()->json(['status' => false, 'message' => 'Unauthorized'], 403);
        }

        public function unreadCount(Request $request)
        {
            $user = $request->user();

            // Admin peut voir le nombre total de messages non lus dans le système
            if ($user->role === 'admin') {
                $unreadCount = Message::whereNull('lu_a')->count();
            } else {
                $unreadCount = Message::where('destinataire_id', $user->user_id)
                    ->whereNull('lu_a')
                    ->count();
            }

            return response()->json([
                'status' => true,
                'unread_count' => $unreadCount
            ], 200);
        }

        /**
        * Get all unique conversations for the authenticated user
        */
        public function conversations(Request $request)
        {
            $user = $request->user();

            // Admin peut voir toutes les conversations du système
            if ($user->role === 'admin') {
                $conversations = Message::selectRaw('
                    expediteur_id,
                    destinataire_id,
                    MAX(date_envoie) as last_message_date
                ')
                ->groupBy('expediteur_id', 'destinataire_id')
                ->with(['expediteur' => function($query) {
                    $query->select('user_id', 'nom', 'prenom');
                }, 'destinataire' => function($query) {
                    $query->select('user_id', 'nom', 'prenom');
                }])
                ->orderBy('last_message_date', 'desc')
                ->get();
            } else {
                $conversations = Message::selectRaw('
                    CASE
                        WHEN expediteur_id = ? THEN destinataire_id
                        ELSE expediteur_id
                    END as interlocutor_id,
                    MAX(date_envoie) as last_message_date
                ', [$user->user_id])
                ->where('expediteur_id', $user->user_id)
                ->orWhere('destinataire_id', $user->user_id)
                ->groupBy('interlocutor_id')
                ->with(['interlocutor' => function($query) {
                    $query->select('user_id', 'nom', 'prenom');
                }])
                ->orderBy('last_message_date', 'desc')
                ->get();
            }

            return response()->json([
                'status' => true,
                'conversations' => $conversations
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

            // Admin peut supprimer n'importe quel message
            if ($user->role === 'admin') {
                $message->delete();
                return response()->json([
                    'status' => true,
                    'message' => 'Message deleted successfully by admin'
                ], 200);
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

        /**
        * Nouvelle méthode: Rechercher des messages (Admin uniquement)
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
                'type' => 'in:content,sender,recipient' // recherche par contenu, expéditeur ou destinataire
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'status' => false,
                    'message' => 'Validation error',
                    'errors' => $validator->errors()
                ], 422);
            }

            $search = $request->input('search');
            $type = $request->input('type', 'content');

            $query = Message::with(['expediteur', 'destinataire']);

            switch ($type) {
                case 'sender':
                    $query->whereHas('expediteur', function($q) use ($search) {
                        $q->where('nom', 'LIKE', "%{$search}%")
                        ->orWhere('prenom', 'LIKE', "%{$search}%");
                    });
                    break;
                case 'recipient':
                    $query->whereHas('destinataire', function($q) use ($search) {
                        $q->where('nom', 'LIKE', "%{$search}%")
                        ->orWhere('prenom', 'LIKE', "%{$search}%");
                    });
                    break;
                default: // content
                    $query->where('contenu', 'LIKE', "%{$search}%");
                    break;
            }

            $messages = $query->orderBy('date_envoie', 'desc')
                            ->paginate(15);

            return response()->json([
                'status' => true,
                'messages' => $messages
            ], 200);
        }

        /**
        * Nouvelle méthode: Statistiques des messages (Admin uniquement)
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
                'total_messages' => Message::count(),
                'unread_messages' => Message::whereNull('lu_a')->count(),
                'messages_today' => Message::whereDate('date_envoie', today())->count(),
                'messages_this_week' => Message::whereBetween('date_envoie', [now()->startOfWeek(), now()->endOfWeek()])->count(),
                'messages_this_month' => Message::whereMonth('date_envoie', now()->month)->count(),
                'active_conversations' => Message::distinct(['expediteur_id', 'destinataire_id'])->count(),
            ];

            return response()->json([
                'status' => true,
                'statistics' => $stats
            ], 200);
        }
    }