import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  
import '../models/free_book_pdf_model.dart';
import '../services/free_book_pdf_service.dart';

class FreeBookPdfProvider extends ChangeNotifier {
  List<FreeBookPdf> _freeBooks = [];
  bool _isSyncing = false;

  List<FreeBookPdf> get freeBooks => _freeBooks;
  bool get isSyncing => _isSyncing;

  Future<void> fetchFreeBooks() async {
    _isSyncing = true;
    notifyListeners();
    try {
      final response = await FreeBookPdfService.fetchAll();
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        _freeBooks = data.map((json) => FreeBookPdf.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<bool> addFreeBook(Map<String, String> fields, File image, File pdf) async {
    _isSyncing = true;
    notifyListeners();
    try {
      final streamedResponse = await FreeBookPdfService.store(
        fields: fields,
        imageFile: image,
        pdfFile: pdf,
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchFreeBooks();
        return true;
      }
    } catch (e) {
      debugPrint("Upload Error: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> updateFreeBook(
    String id, 
    Map<String, String> fields, {
    File? imageFile,
    File? pdfFile,
  }) async {
    _isSyncing = true;
    notifyListeners();
    try {
      final response = await FreeBookPdfService.update(
        id, 
        fields, 
        imageFile: imageFile, 
        pdfFile: pdfFile,
      );
      
      if (response.statusCode == 200) {
        await fetchFreeBooks(); 
        return true;
      } else {
        debugPrint("Update Failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> deleteFreeBook(String id) async {
    final response = await FreeBookPdfService.delete(id);
    if (response.statusCode == 200) {
      _freeBooks.removeWhere((book) => book.id == id);
      notifyListeners();
      return true;
    }
    return false;
  }
}