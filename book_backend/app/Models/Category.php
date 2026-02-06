<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasFactory;

    // IMPORTANT: Match your migration table name
    protected $table = 'category';

    // Allow these fields to be filled via the API
    protected $fillable = [
        'name',
        'description',
    ];
}