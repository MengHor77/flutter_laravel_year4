<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Sale extends Model
{
    use HasFactory;

    // Define the table name (since it's 'sales', Laravel usually finds it, 
    // but being explicit is safer)
    protected $table = 'sales';

    // Allow these fields to be filled during mass assignment
    protected $fillable = [
        'user_id',
        'order_id',
        'book_id',
        'price',
        'quantity',
        'total_amount',
    ];

    /**
     * Relationships
     */

    // A sale belongs to a user
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // A sale belongs to an order
    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    // A sale belongs to a book
    public function book()
    {
        // Note: Change 'book' to 'Book' class name and ensure 
        // the table name in migration matches (you used 'book' singular)
        return $this->belongsTo(Book::class, 'book_id');
    }  
}