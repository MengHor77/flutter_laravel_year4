<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FreeBookPDF extends Model
{
    use HasFactory;

    protected $table = 'free_book_pdfs';  

    protected $fillable = [
        'name', 
        'author', 
        'image',    
        'pdf_file',  
        'price', 
        'category_id'
    ];

    public function category()
    {
        return $this->belongsTo(Category::class, 'category_id');
    }
}