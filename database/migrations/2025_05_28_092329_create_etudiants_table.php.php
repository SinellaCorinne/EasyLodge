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
            Schema::create('etudiants', function (Blueprint $table) {
                $table->id('etudiant_id');
                $table->unsignedBigInteger('utilisateur_id');
                $table->string('universite');
                $table->string('carte_etudiant');
                $table->timestamps();

                $table->foreign('utilisateur_id')
                    ->references('user_id')
                    ->on('utilisateurs')
                    ->onDelete('cascade');
            });
        }

        /**
         * Reverse the migrations.
         */
        public function down(): void
        {
            Schema::dropIfExists('etudiants');
        }
    };
