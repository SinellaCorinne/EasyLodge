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
            Schema::create('logements', function (Blueprint $table) {
                $table->id('logement_id');
                $table->string('titre');
                $table->text('description');
                $table->string('type');
                $table->decimal('prix', 10, 2);
                $table->string('localisation');
                $table->boolean('disponibilite')->default(true);
                $table->LongText('photo')->nullable();
                $table->unsignedBigInteger('bailleur_id');
                $table->timestamps();

                $table->foreign('bailleur_id')
                    ->references('bailleur_id')
                    ->on('bailleurs')
                    ->onDelete('cascade');
            });
        }

        /**
         * Reverse the migrations.
         */
        public function down(): void
        {
            Schema::dropIfExists('logements');
        }
    };
