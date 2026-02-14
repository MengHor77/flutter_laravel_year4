import 'dart:io';
import 'download_book.dart';
import 'package:flutter/material.dart';

class BookSaver {
  static Future<void> saveAndNotify(String url, String fileName, BuildContext context) async {
    // 1. Show "Starting" snackbar immediately
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Downloading $fileName...")),
    );

    // 2. Perform the download
    File? file = await BookDownloader.downloadFile(url, fileName);

    // 3. Guard against "Async Gaps"
    if (!context.mounted) return;

    if (file != null && await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Saved to: ${file.path.split('/').last}"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to download book."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}