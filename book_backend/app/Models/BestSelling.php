<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BestSelling extends Model
{
    use HasFactory;

    protected $table = 'best_selling_book';

    protected $fillable = [
        'book_id',
    ];

   
    public function book()
    {
        return $this->belongsTo(Book::class, 'book_id');
    }
}