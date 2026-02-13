<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Sale extends Model
{
    use HasFactory;

     
    protected $table = 'sales';

    protected $fillable = [
        'user_id',
        'order_id',
        'book_id',
        'price',
        'quantity',
        'total_amount',
    ];

  

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
       
        return $this->belongsTo(Book::class, 'book_id');
    }  
}