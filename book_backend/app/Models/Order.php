<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $table = 'orders';

    protected $fillable = [
        'user_id',
        'total_amount',  
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    
    public function sales()
    {
        return $this->hasMany(Sale::class, 'order_id');
    }
    
}