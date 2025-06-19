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
            Schema::create('avis', function (Blueprint $table) {
                $table->id('avis_id');
                $table->unsignedBigInteger('logement_id');
                $table->unsignedBigInteger('etudiant_id');
                $table->integer('note')->comment('Note de 1 à 5');
                $table->text('commentaire');
                $table->timestamp('dateAvis')->useCurrent();
                $table->timestamps();

                $table->foreign('logement_id')
                    ->references('logement_id')
                    ->on('logements')
                    ->onDelete('cascade');

                $table->foreign('etudiant_id')
                    ->references('etudiant_id')
                    ->on('etudiants')
                    ->onDelete('cascade');

                // Un étudiant ne peut donner qu'un seul avis par logement
                $table->unique(['logement_id', 'etudiant_id']);
            });
        }

        /**
         * Reverse the migrations.
         */
        public function down(): void
        {
            Schema::dropIfExists('avis');
        }
    };