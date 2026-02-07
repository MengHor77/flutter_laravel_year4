<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SpecialOffer extends Model
{
    use HasFactory;

    protected $table = 'special_offer';

    protected $fillable = [
        'book_id', 
        'title', 
        'discount_percentage', 
        'offer_price', 
        'start_date', 
        'end_date', 
        'is_active'
    ];

    // Relationship: A special offer belongs to a book
    public function book()
    {
        return $this->belongsTo(Book::class);
    }
}