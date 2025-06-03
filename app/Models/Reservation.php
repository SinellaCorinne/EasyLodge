<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Reservation extends Model
{
    use HasFactory;

    protected $table = 'reservations';
    protected $primaryKey = 'reservation_id';
    public $timestamps = true;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'logement_id',
        'etudiant_id',
        'statut',
    ];

    /**
     * Get the housing unit associated with the reservation.
     */
    public function logement()
    {
        return $this->belongsTo(Logement::class, 'logement_id', 'logement_id');
    }

    /**
     * Get the student who made the reservation.
     */
    public function etudiant()
    {
        return $this->belongsTo(Etudiant::class, 'etudiant_id', 'etudiant_id');
    }

    /**
     * Get the payment associated with the reservation.
     */
    public function paiement()
    {
        return $this->hasOne(Paiement::class, 'reservation_id', 'reservation_id');
    }
}