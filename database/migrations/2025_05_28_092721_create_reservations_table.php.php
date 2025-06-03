    <?php

    use Illuminate\Database\Migrations\Migration;
    use Illuminate\Database\Schema\Blueprint;
    use Illuminate\Support\Facades\Schema;

    return new class extends Migration
    {
        /**
         * Run the migrations.
         */
        public function up(): void
        {
            Schema::create('reservations', function (Blueprint $table) {
                $table->id('reservation_id');
                $table->unsignedBigInteger('logement_id');
                $table->unsignedBigInteger('etudiant_id');
                $table->enum('statut', ['en_attente', 'confirmee', 'annulee'])->default('en_attente');
                $table->timestamps();

                $table->foreign('logement_id')
                    ->references('logement_id')
                    ->on('logements')
                    ->onDelete('cascade');

                $table->foreign('etudiant_id')
                    ->references('etudiant_id')
                    ->on('etudiants')
                    ->onDelete('cascade');
            });
        }

        /**
         * Reverse the migrations.
         */
        public function down(): void
        {
            Schema::dropIfExists('reservations');
        }
    };
