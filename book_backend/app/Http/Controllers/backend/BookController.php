<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Book;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File; // ✅ បន្ថែមនេះដើម្បីលុបរូបភាពចាស់

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
            
            // ✅ កែសម្រួល៖ ប្រើ config('app.url') ដើម្បីធានាថា URL ត្រូវជាមួយ IP ក្នុង Flutter
            if ($book->image && !filter_var($book->image, FILTER_VALIDATE_URL)) {
                // ប្រសិនបើក្នុង DB ទុក 'uploads/books/file.jpg' យើងប្តូរវាទៅជា Full URL
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
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048', 
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $data = $request->all();

        // ✅ Handle Image Upload
        if ($request->hasFile('image')) {
            $file = $request->file('image');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('uploads/books'), $filename);
            
            // រក្សាទុកត្រឹម Path បែបនេះក្នុង DB: uploads/books/name.jpg
            $data['image'] = 'uploads/books/' . $filename;
        }

        $book = Book::create($data);
        
        // បោះ URL ពេញទៅឱ្យ Flutter វិញភ្លាមៗ
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
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        if ($validator->fails()) return response()->json(['errors' => $validator->errors()], 422);

        $data = $request->all();

        if ($request->hasFile('image')) {
            // ✅ លុបរូបភាពចាស់ចេញពី Folder ដើម្បីកុំឱ្យពេញទំហំ Disk
            if ($book->image) {
                // ដក Domain ចេញដើម្បីយក Path ក្នុងម៉ាស៊ីនមកលុប
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
        
        // កែ URL សម្រាប់ Response
        $book->image = asset($book->image);
        
        return response()->json($book->load('category'), 200);
    }

    public function destroy($id)
    {
        $book = Book::find($id);
        if (!$book) {
            return response()->json(['message' => 'Book not found'], 404);
        }

        // ✅ លុបរូបភាពចេញពី Folder ពេលលុប Data ចេញពី DB
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