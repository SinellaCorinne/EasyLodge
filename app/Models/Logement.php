<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Logement extends Model
{
    use HasFactory;

    protected $table = 'logements';
    protected $primaryKey = 'logement_id';
    public $timestamps = true;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'titre',
        'description',
        'type',
        'prix',
        'localisation',
        'disponibilite',
        'photo',
        'bailleur_id',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'disponibilite' => 'boolean',
        'prix' => 'float',
    ];

    /**
     * Get the landlord who owns the housing unit.
     */
    public function bailleur()
    {
        return $this->belongsTo(Bailleur::class, 'bailleur_id', 'bailleur_id');
    }

    /**
     * Get the reservations for the housing unit.
     */
    public function reservations()
    {
        return $this->hasMany(Reservation::class, 'logement_id', 'logement_id');
    }
}