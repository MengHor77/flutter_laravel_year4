<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use App\Models\FreeBookPDF;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class FreeBookPDFController extends Controller
{
    public function index()
    {
        $book_pdfs = FreeBookPDF::with('category')->get();
        return response()->json($book_pdfs);
    }

    public function show($id)
    {
        $book = FreeBookPDF::with('category')->find($id);
        if (!$book) return response()->json(['message' => 'Book not found'], 404);
        return response()->json($book);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'author' => 'required|string',
            'image' => 'required|image|mimes:jpeg,png,jpg|max:2048', 
            'pdf_file' => 'required|mimes:pdf|max:10000',           
            'category_id' => 'required|exists:category,id', 
        ]);

        $data = $request->all();

        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('uploads/covers', 'public');
        }

        if ($request->hasFile('pdf_file')) {
            $data['pdf_file'] = $request->file('pdf_file')->store('uploads/pdfs', 'public');
        }

        $book = FreeBookPDF::create($data);
        return response()->json(['message' => 'Book created successfully', 'data' => $book], 201);
    }

    public function update(Request $request, $id) 
    {
        $book = FreeBookPDF::find($id);
        if (!$book) return response()->json(['message' => 'Book not found'], 404);

        $request->validate([
            'name' => 'sometimes|required|string',
            'author' => 'sometimes|required|string',
            'category_id' => 'sometimes|required|exists:category,id',
            'price' => 'nullable|numeric'
        ]);

        $data = $request->all();

        if ($request->hasFile('image')) {
            if($book->image) Storage::disk('public')->delete($book->image);
            $data['image'] = $request->file('image')->store('uploads/covers', 'public');
        }

        if ($request->hasFile('pdf_file')) {
            if($book->pdf_file) Storage::disk('public')->delete($book->pdf_file);
            $data['pdf_file'] = $request->file('pdf_file')->store('uploads/pdfs', 'public');
        }

        $book->update($data);
        return response()->json(['message' => 'Book updated successfully', 'data' => $book]);
    }

    public function destroy($id)
    {
        $book = FreeBookPDF::find($id);
        if (!$book) return response()->json(['message' => 'Book not found'], 404);

        if ($book->image) Storage::disk('public')->delete($book->image);
        if ($book->pdf_file) Storage::disk('public')->delete($book->pdf_file);
        
        $book->delete();

        return response()->json(['message' => 'Book deleted successfully']);
    }
}