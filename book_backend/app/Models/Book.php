<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Book extends Model
{
    use HasFactory;

    protected $table = 'book'; // Explicitly naming the table

    protected $fillable = ['name', 'author', 'category_id', 'price'];
    /**
     * Get the category that owns the book.
     */
    public function category()
    {
        // A book belongs to one category
        return $this->belongsTo(Category::class, 'category_id');
    }
}