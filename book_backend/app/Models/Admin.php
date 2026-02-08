<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable; // Required for Auth
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens; // Allows $admin->createToken()
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Admin extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    // Specify the table name because it is 'admin', not 'admins'
    protected $table = 'admin';

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];
}