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
        Schema::create('order_list', function (Blueprint $table) {
        $table->id();
        $table->foreignId('book_id')->constrained('book')->onDelete('cascade');
        $table->decimal('price', 8, 2); 
        $table->integer('quantity')->default(1);
        $table->timestamps();
        });
    }

   
    public function down(): void
    {
        Schema::dropIfExists('order_list');
    }
};