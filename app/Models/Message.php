<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Message extends Model
{
    use HasFactory;

    protected $table = 'messages';
    protected $primaryKey = 'message_id';
    public $timestamps = true;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'expediteur_id',
        'destinataire_id',
        'contenu',
        'date_envoie',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'date_envoie' => 'datetime',
    ];

    /**
     * Get the user who sent the message.
     */
    public function expediteur()
    {
        return $this->belongsTo(User::class, 'expediteur_id', 'user_id');
    }

    /**
     * Get the user who received the message.
     */
    public function destinataire()
    {
        return $this->belongsTo(User::class, 'destinataire_id', 'user_id');
    }
}