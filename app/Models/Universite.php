<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Universite extends Model
{
    use HasFactory;

    protected $table = 'universites';
    protected $primaryKey = 'universite_id';
    public $timestamps = true;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nom',
        'localisation',
    ];

    /**
     * Get the students associated with this university.
     */
    public function etudiants()
    {
        return $this->hasMany(Etudiant::class, 'universite', 'nom');
    }
}
