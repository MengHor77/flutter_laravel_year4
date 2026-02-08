<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderList extends Model
{
    use HasFactory;

    protected $table = 'order_list';

    protected $fillable = [
        'user_id', 
        'book_id', 
        'price', 
        'quantity'
    ];

    /**
     * Relationship to get Book info
     * This allows us to see book title, image, and description for an order.
     */
    public function book()
    {
        return $this->belongsTo(Book::class, 'book_id');
    }

    /**
     * Relationship to get User info
     * Crucial for ADMIN: Allows the admin to see the name/email of the customer.
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * Helper: Get Total Price for this specific item line
     * Usage: $order->total_line_price
     */
    public function getTotalLinePriceAttribute()
    {
        return $this->price * $this->quantity;
    }
}