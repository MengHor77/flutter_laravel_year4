<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use App\Models\FreeBookPDF;
use App\Models\User;         // បន្ថែមនេះ
use App\Models\Notification; // បន្ថែមនេះ
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class FreeBookPDFController extends Controller
{
    public function index()
    {
        $book_pdfs = FreeBookPDF::with('category')->get()->map(function ($book) {
            // FIX: Handle both relative paths and old IP addresses
            if ($book->image) {
                if (!filter_var($book->image, FILTER_VALIDATE_URL)) {
                    // Convert "uploads/books/..." to "http://192.168.1.104:8000/storage/uploads/books/..."
                    $book->image = asset('storage/' . $book->image);
                } else {
                    // Replace old static IP with current server IP
                    $book->image = str_replace('192.168.1.105', '192.168.1.104', $book->image);
                }
            }
            if ($book->pdf_file) {
                if (!filter_var($book->pdf_file, FILTER_VALIDATE_URL)) {
                    $book->pdf_file = asset('storage/' . $book->pdf_file);
                } else {
                    $book->pdf_file = str_replace('192.168.1.105', '192.168.1.104', $book->pdf_file);
                }
            }
            return $book;
        });
        
        return response()->json($book_pdfs);
    }
    
    public function show($id)
    {
        $book = FreeBookPDF::with('category')->find($id);
        if (!$book) return response()->json(['message' => 'Book not found'], 404);
        
        // Ensure URLs are formatted correctly for single view
        if ($book->image && !filter_var($book->image, FILTER_VALIDATE_URL)) {
            $book->image = asset('storage/' . $book->image);
        }
        return response()->json($book);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'author' => 'required|string',
            'image' => 'required|image|mimes:jpeg,png,jpg,webp|max:2048', 
            'pdf_file' => 'required|mimes:pdf|max:10000',           
            'category_id' => 'required|exists:category,id', 
        ]);

        $data = $request->all();

        if ($request->hasFile('image')) {
            // Stores in storage/app/public/uploads/books
            $path = $request->file('image')->store('uploads/books', 'public');
            $data['image'] = $path; 
        }

        if ($request->hasFile('pdf_file')) {
            $pdfPath = $request->file('pdf_file')->store('uploads/pdfs', 'public');
            $data['pdf_file'] = $pdfPath;
        }

        $book = FreeBookPDF::create($data);

        // --- បន្ថែមកូដថ្មី៖ បង្កើត Notification សម្រាប់គ្រប់ Users ទាំងអស់ ---
        $users = User::all();
        foreach ($users as $user) {
            Notification::create([
                'user_id' => $user->id,
                'title' => '📚 New Free E-book!',
                'message' => 'The book "' . $book->name . '" is now available for free download.',
                'type' => 'free_pdf',
                'target_id' => $book->id,
                'is_read' => false, // កំណត់ថាជា Unread ដើម្បីឱ្យលោតលេខ Badge ក្នុង Flutter
            ]);
        }
        // -----------------------------------------------------------

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
                Storage::disk('public')->delete($book->image);
            }
            $path = $request->file('image')->store('uploads/books', 'public');
            $data['image'] = $path;
        }

        if ($request->hasFile('pdf_file')) {
            if ($book->pdf_file) {
                Storage::disk('public')->delete($book->pdf_file);
            }
            $pdfPath = $request->file('pdf_file')->store('uploads/pdfs', 'public');
            $data['pdf_file'] = $pdfPath;
        }

        $book->update($data);
        return response()->json(['message' => 'Book updated successfully', 'data' => $book]);
    }

    public function destroy($id)
    {
        $book = FreeBookPDF::find($id);
        if (!$book) return response()->json(['message' => 'Book not found'], 404);

        if ($book->image) {
            Storage::disk('public')->delete($book->image);
        }
        
        if ($book->pdf_file) {
            Storage::disk('public')->delete($book->pdf_file);
        }
        
        $book->delete();
        return response()->json(['message' => 'Book deleted successfully']);
    }
}