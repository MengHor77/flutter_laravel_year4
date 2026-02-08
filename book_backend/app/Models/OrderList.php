<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderList extends Model
{
    use HasFactory;

    protected $table = 'order_list';
   protected $fillable = ['user_id', 'book_id', 'price', 'quantity'];

    // Relationship to get Book info
    public function book()
    {
        return $this->belongsTo(Book::class, 'book_id');
    }
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
    
}