<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Book;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File;

class BookController extends Controller
{
    public function index() {
        $books = Book::with(['category', 'specialOffers' => function($query) {
            $query->where('is_active', true);
        }])->get();

        $books->map(function ($book) {
            $activeOffer = $book->specialOffers->first();
            $book->is_on_sale = $activeOffer ? true : false;
            $book->display_price = $activeOffer ? $activeOffer->offer_price : $book->price;
            
            if ($book->image && !filter_var($book->image, FILTER_VALIDATE_URL)) {
                $book->image = asset($book->image);
            }
            
            return $book;
        });

        return response()->json($books, 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'author' => 'required|string|max:255',
            'price' => 'required|numeric',
            'category_id' => 'required|exists:category,id',
            // UPDATED: Added webp and increased max size to 5MB for high-res emulator images
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:5120', 
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $data = $request->all();

        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('uploads/books'), $filename);
            $data['image'] = 'uploads/books/' . $filename;
        }

        $book = Book::create($data);
        $book->image = asset($book->image); 
        
        return response()->json($book->load('category'), 201);
    }

    public function update(Request $request, $id)
    {
        $book = Book::find($id);
        if (!$book) return response()->json(['message' => 'Book not found'], 404);

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'author' => 'required|string|max:255',
            'price' => 'required|numeric',
            'category_id' => 'required|exists:category,id',
            // UPDATED: Added webp to allow images downloaded from emulator browsers
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:5120',
        ]);

        if ($validator->fails()) return response()->json(['errors' => $validator->errors()], 422);

        $data = $request->all();

        if ($request->hasFile('image')) {
            // Delete old image if it exists
            if ($book->image) {
                $oldPath = str_replace(asset(''), '', $book->image);
                $fullOldPath = public_path($oldPath);
                if (File::exists($fullOldPath)) {
                    File::delete($fullOldPath);
                }
            }

            $file = $request->file('image');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('uploads/books'), $filename);
            $data['image'] = 'uploads/books/' . $filename;
        }

        $book->update($data);
        $book->image = asset($book->image); 
        
        return response()->json($book->load('category'), 200);
    }

    public function destroy($id)
    {
        $book = Book::find($id);
        if (!$book) return response()->json(['message' => 'Book not found'], 404);

        if ($book->image) {
            $oldPath = str_replace(asset(''), '', $book->image);
            $fullPath = public_path($oldPath);
            if (File::exists($fullPath)) {
                File::delete($fullPath);
            }
        }

        $book->delete();
        return response()->json(['message' => 'Book deleted successfully'], 200);
    }
}