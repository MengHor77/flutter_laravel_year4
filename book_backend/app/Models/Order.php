<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    // This ensures the model looks at the correct table from your migrations
    protected $table = 'orders';

    protected $fillable = [
        'user_id',
        'total_amount', // Matches your decimal(10,2) migration column
        'status',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}