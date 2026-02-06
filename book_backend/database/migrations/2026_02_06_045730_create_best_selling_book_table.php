<?php



use Illuminate\Database\Migrations\Migration;

use Illuminate\Database\Schema\Blueprint;

use Illuminate\Support\Facades\Schema;



return new class extends Migration

{

public function up(): void

{

    Schema::create('best_selling_book', function (Blueprint $table) {

        $table->id();
        $table->foreignId('book_id')
            ->constrained('book') // References the 'book' table
            ->onDelete('cascade'); // If a book is deleted, remove it from best sellers too
        $table->timestamps();

    });

}



    public function down(): void

    {

    Schema::dropIfExists('best_selling_book');

    }

};