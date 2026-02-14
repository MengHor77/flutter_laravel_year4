import 'dart:io';
import 'download_book.dart';
import 'package:flutter/material.dart';

class BookSaver {
  static Future<void> saveAndNotify(String url, String fileName, BuildContext context) async {
    // Show "Starting" notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Downloading $fileName...")),
    );

    // Start download and wait for either the File or the Recovery File
    File? file = await BookDownloader.downloadFile(url, fileName);

    // Safety check: is the screen still open?
    if (!context.mounted) return;

    if (file != null && await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Success! Saved to: ${file.path.split('/').last}"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Download failed. Check your local IP connection."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}