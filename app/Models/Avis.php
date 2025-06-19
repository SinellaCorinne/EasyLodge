<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Avis extends Model
{
    use HasFactory;

    protected $table = 'avis';
    protected $primaryKey = 'avis_id';
    public $timestamps = true;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'logement_id',
        'etudiant_id',
        'note',
        'commentaire',
        'dateAvis',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'dateAvis' => 'datetime',
        'note' => 'integer',
    ];

    /**
     * Get the housing unit associated with the review.
     */
    public function logement()
    {
        return $this->belongsTo(Logement::class, 'logement_id', 'logement_id');
    }

    /**
     * Get the student who wrote the review.
     */
    public function etudiant()
    {
        return $this->belongsTo(Etudiant::class, 'etudiant_id', 'etudiant_id');
    }
}
