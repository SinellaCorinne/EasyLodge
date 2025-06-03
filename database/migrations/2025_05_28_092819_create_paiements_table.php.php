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
            Schema::create('paiements', function (Blueprint $table) {
                $table->id('paiement_id');
                $table->unsignedBigInteger('reservation_id');
                $table->decimal('montant', 10, 2);
                $table->string('methode_paie');
                $table->enum('statut', ['en_attente', 'complete', 'annule'])->default('en_attente');
                $table->timestamps();

                $table->foreign('reservation_id')
                    ->references('reservation_id')
                    ->on('reservations')
                    ->onDelete('cascade');
            });
        }

        /**
         * Reverse the migrations.
         */
        public function down(): void
        {
            Schema::dropIfExists('paiements');
        }
    };
