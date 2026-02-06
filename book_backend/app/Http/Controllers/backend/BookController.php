<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Book;
use Illuminate\Support\Facades\Validator;

class BookController extends Controller
{
    // 1. GET ALL BOOKS
    public function index()
    {
        $books = Book::with('category')->get();
        return response()->json($books, 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'author' => 'required|string|max:255',
            'price' => 'required|numeric',
            'category_id' => 'required|exists:category,id',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048', // Validation for image
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $data = $request->all();

        // Handle Image Upload
        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('uploads/books'), $filename);
            
            // Save the full URL or relative path
            $data['image'] = url('uploads/books/' . $filename);
        }

        $book = Book::create($data);
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
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) return response()->json(['errors' => $validator->errors()], 422);

        $data = $request->all();

        if ($request->hasFile('image')) {
            // Optional: Delete old image file here if it exists
            $file = $request->file('image');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('uploads/books'), $filename);
            $data['image'] = url('uploads/books/' . $filename);
        }

        $book->update($data);
        return response()->json($book->load('category'), 200);
    }

    public function destroy($id)
    {
        $book = Book::find($id);
        if (!$book) {
            return response()->json(['message' => 'Book not found'], 404);
        }

        $book->delete();
        return response()->json(['message' => 'Book deleted successfully'], 200);
    }
}