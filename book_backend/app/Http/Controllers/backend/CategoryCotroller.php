<?php

namespace App\Http\Controllers\backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Category;

class CategoryController extends Controller
{
    // 1. GET ALL
    public function index()
    {
        return response()->json(Category::all(), 200);
    }

    // 2. CREATE
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|unique:category,name|max:255',
            'description' => 'required'
        ]);

        $category = Category::create($validated);
        return response()->json($category, 201);
    }

    // 3. UPDATE
    public function update(Request $request, $id)
    {
        $category = Category::find($id);
        if (!$category) {
            return response()->json(['message' => 'Category not found'], 404);
        }

        $validated = $request->validate([
            'name' => 'required|max:255|unique:category,name,' . $id,
            'description' => 'required'
        ]);

        $category->update($validated);
        return response()->json($category, 200);
    }

    // 4. DELETE
    public function destroy($id)
    {
        $category = Category::find($id);
        if (!$category) {
            return response()->json(['message' => 'Category not found'], 404);
        }
        
        $category->delete();
        return response()->json(['message' => 'Deleted successfully'], 200);
    }
}