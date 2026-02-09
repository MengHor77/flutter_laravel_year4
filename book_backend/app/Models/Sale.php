<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    // Mass assignable attributes
    protected $fillable = [
        'user_id',
        'total_amount',
        'status',
    ];

    /**
     * Relationship to the User who made the order
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Relationship to the specific items in this order
     */
    public function items()
    {
        return $this->hasMany(OrderItem::class);
    }
}