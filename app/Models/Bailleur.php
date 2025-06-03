<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Bailleur extends Model
{
    use HasFactory;

    protected $table = 'bailleurs';
    protected $primaryKey = 'bailleur_id';
    public $timestamps = true;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'utilisateur_id',
        'carte_identite',
    ];

    /**
     * Get the user associated with the landlord.
     */
    public function utilisateur()
    {
        return $this->belongsTo(User::class, 'utilisateur_id', 'user_id');
    }

    /**
     * Get the housing units owned by the landlord.
     */
    public function logements()
    {
        return $this->hasMany(Logement::class, 'bailleur_id', 'bailleur_id');
    }
}