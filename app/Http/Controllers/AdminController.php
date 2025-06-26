<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\{Logement, Reservation, Paiement, Message, Avis, User, Universite, Parametre};

class AdminController extends Controller
{
 public function dashboard()
{
    return response()->json([
        'total_utilisateurs' => \App\Models\User::count(),
        'total_logements' => \App\Models\Logement::count(),
        'total_reservations' => \App\Models\Reservation::count(),
        'total_paiements' => \App\Models\Paiement::count(),
        'total_messages' => \App\Models\Message::count(),
        'total_avis' => \App\Models\Avis::count(),
        'total_universites' => \App\Models\Universite::count(),
    ]);

    }

    // Gestion des paramètres système
    public function parametres()
    {
        $parametres = Parametre::all();
        return view('admin.parametres.index', compact('parametres'));
    }

    public function updateParametre(Request $request, $id)
    {
        $parametre = Parametre::findOrFail($id);
        $parametre->valeur = $request->input('valeur');
        $parametre->save();

        return back()->with('success', 'Paramètre mis à jour.');
    }

    // Gestion des universités
    public function universites()
    {
        $universites = Universite::all();
        return view('admin.universites.index', compact('universites'));
    }

    public function ajouterUniversite(Request $request)
    {
        $request->validate([
            'nom' => 'required|string|max:255',
            'localisation' => 'required|string|max:255',
        ]);

        Universite::create($request->only(['nom', 'localisation']));
        return back()->with('success', 'Université ajoutée.');
    }

    public function supprimerUniversite($id)
    {
        Universite::destroy($id);
        return back()->with('success', 'Université supprimée.');
    }

    // Liste des logements
    public function logements()
    {
        $logements = Logement::with('bailleur')->get();
        return view('admin.logements.index', compact('logements'));
    }

    // Liste des réservations
    public function reservations()
    {
        $reservations = Reservation::with(['logement', 'etudiant'])->get();
        return view('admin.reservations.index', compact('reservations'));
    }

    // Liste des paiements
    public function paiements()
    {
        $paiements = Paiement::with('reservation')->get();
        return view('admin.paiements.index', compact('paiements'));
    }

    // Liste des messages
    public function messages()
    {
        $messages = Message::with(['expediteur', 'destinataire'])->get();
        return view('admin.messages.index', compact('messages'));
    }

    // Liste des avis
    public function avis()
    {
        $avis = Avis::with(['etudiant', 'logement'])->get();
        return view('admin.avis.index', compact('avis'));
    }

    // Liste des utilisateurs
    public function utilisateurs()
    {
        $utilisateurs = User::all();
        return view('admin.utilisateurs.index', compact('utilisateurs'));
    }

    public function supprimerUtilisateur($id)
    {
        User::destroy($id);
        return back()->with('success', 'Utilisateur supprimé.');
    }
}