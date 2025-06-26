<?php

namespace App\Models;

//use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;



class Parametre extends Model
{
    use HasFactory;
    protected $table = 'parametres';
    protected $primaryKey = 'parametre_id';
    public $timestamps = true;

    protected $fillable = ['cle', 'valeur'];

    public static function getValeur($cle, $defaut = null)
    {
        return static::where('cle', $cle)->value('valeur') ?? $defaut;
    }
}