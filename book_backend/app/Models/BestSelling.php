<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BestSelling extends Model
{
    use HasFactory;

    // 1. Define the table name (matching your migration)
    protected $table = 'best_selling_book';

    // 2. Define which fields can be filled
    protected $fillable = [
        'book_id',
    ];

    /**
     * Get the book associated with the best seller record.
     * This creates the relationship so you can call $bestSelling->book
     */
    public function book()
    {
        return $this->belongsTo(Book::class, 'book_id');
    }
}