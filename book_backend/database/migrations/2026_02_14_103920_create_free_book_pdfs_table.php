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
        Schema::create('free_book_pdfs', function (Blueprint $table) {
          $table->id();
        $table->string('name');
        $table->string('author');
        $table->string('image');    // Stores path like "uploads/covers/abc.jpg"
        $table->string('pdf_file'); // Stores path like "uploads/pdfs/xyz.pdf"
        $table->decimal('price', 8, 2)->default(0.00);  
        $table->foreignId('category_id')->constrained('category')->onDelete('cascade');
        $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('free_book_pdfs');
    }
};