<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $table = 'utilisateurs';
    protected $primaryKey = 'user_id';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nom',
        'prenom',
        'email',
        'password',
        'tel',
        'role_user',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    /**
     * Get the etudiant associated with the user.
     */
    public function etudiant()
    {
        return $this->hasOne(Etudiant::class, 'utilisateur_id', 'user_id');
    }

    /**
     * Get the bailleur associated with the user.
     */
    public function bailleur()
    {
        return $this->hasOne(Bailleur::class, 'utilisateur_id', 'user_id');
    }

    /**
     * Get the messages sent by the user.
     */
    public function messagesSent()
    {
        return $this->hasMany(Message::class, 'expediteur_id', 'user_id');
    }

    /**
     * Get the messages received by the user.
     */
    public function messagesReceived()
    {
        return $this->hasMany(Message::class, 'destinataire_id', 'user_id');
    }

    /**
     * Determine if the user is a student.
     */
    public function isEtudiant()
    {
        return $this->role_user === 'Etudiant';
    }

    /**
     * Determine if the user is a landlord.
     */
    public function isBailleur()
    {
        return $this->role_user === 'Bailleur';
    }
}
