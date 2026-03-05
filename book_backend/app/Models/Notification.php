<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model; 


class Notification extends Model
{
    protected $fillable = [
        'user_id', // បន្ថែម user_id ក្នុង fillable
        'title',
        'message',
        'type',
        'target_id',
        'is_read',
    ];

    // បង្កើតទំនាក់ទំនងទៅកាន់ User (Notification នេះជារបស់ User ម្នាក់)
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}