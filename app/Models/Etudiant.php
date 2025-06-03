<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Etudiant extends Model
{
    use HasFactory;

    protected $table = 'etudiants';
    protected $primaryKey = 'etudiant_id';
    public $timestamps = true;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'utilisateur_id',
        'universite',
        'carte_etudiant',
    ];

    /**
     * Get the user associated with the student.
     */
    public function utilisateur()
    {
        return $this->belongsTo(User::class, 'utilisateur_id', 'user_id');
    }

    /**
     * Get the reservations made by the student.
     */
    public function reservations()
    {
        return $this->hasMany(Reservation::class, 'etudiant_id', 'etudiant_id');
    }
}