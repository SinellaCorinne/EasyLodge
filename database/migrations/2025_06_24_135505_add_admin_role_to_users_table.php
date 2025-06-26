<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Modifier l'enum pour ajouter 'Admin'
        DB::statement("ALTER TABLE utilisateurs MODIFY COLUMN role_user ENUM('Etudiant', 'Bailleur', 'Admin') NOT NULL");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Revenir à l'enum original
        DB::statement("ALTER TABLE utilisateurs MODIFY COLUMN role_user ENUM('Etudiant', 'Bailleur') NOT NULL");
    }
};
