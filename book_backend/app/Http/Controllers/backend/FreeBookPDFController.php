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

        // Save Image and generate Full URL for the DB
        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('uploads/books', 'public');
            // This creates the http://192.168.1.105:8000/storage/uploads/books/... link
            $data['image'] = url('storage/' . $path);
        }

        if ($request->hasFile('pdf_file')) {
            $pdfPath = $request->file('pdf_file')->store('uploads/pdfs', 'public');
            $data['pdf_file'] = url('storage/' . $pdfPath);
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
            if ($book->image) {
                // Extract local path from full URL to delete from disk
                $oldPath = str_replace(url('storage/'), '', $book->image);
                Storage::disk('public')->delete($oldPath);
            }
            $path = $request->file('image')->store('uploads/books', 'public');
            $data['image'] = url('storage/' . $path);
        }

        if ($request->hasFile('pdf_file')) {
            if ($book->pdf_file) {
                $oldPdfPath = str_replace(url('storage/'), '', $book->pdf_file);
                Storage::disk('public')->delete($oldPdfPath);
            }
            $pdfPath = $request->file('pdf_file')->store('uploads/pdfs', 'public');
            $data['pdf_file'] = url('storage/' . $pdfPath);
        }

        $book->update($data);
        return response()->json(['message' => 'Book updated successfully', 'data' => $book]);
    }

    public function destroy($id)
    {
        $book = FreeBookPDF::find($id);
        if (!$book) return response()->json(['message' => 'Book not found'], 404);

        if ($book->image) {
            $imagePath = str_replace(url('storage/'), '', $book->image);
            Storage::disk('public')->delete($imagePath);
        }
        
        $book->delete();
        return response()->json(['message' => 'Book deleted successfully']);
    }
}