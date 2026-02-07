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
        Schema::create('special_offer', function (Blueprint $table) {
          $table->id();
            $table->foreignId('book_id')->constrained('book')->onDelete('cascade');
             
            $table->string('title'); // e.g., "Summer Sale" 
            $table->decimal('discount_percentage', 5, 2); // e.g., 20.00 for 20%
            $table->decimal('offer_price', 8, 2); // The price after discount
            
            $table->dateTime('start_date')->nullable();
            $table->dateTime('end_date')->nullable();
            $table->boolean('is_active')->default(true);
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('special_offer');
    }
};