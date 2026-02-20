import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class BookSaver {
  /// This is the main function you call from your UI
  static Future<void> saveAndNotify(String url, String fileName, BuildContext context) async {
    // 1. Show "Starting" notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Downloading $fileName..."),
        duration: const Duration(seconds: 1),
      ),
    );

    // 2. Start the download
    File? file = await BookDownloader.downloadFile(url, fileName);

    // 3. Safety check: is the screen still open?
    if (!context.mounted) return;

    if (file != null && await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Success! Saved to Downloads"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: "OK",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Download failed. Check your connection."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class BookDownloader {
  static Future<File?> downloadFile(String url, String fileName) async {
    Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
    ));

    try {
      // Logic to get the Download directory (visible to user)
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      String savePath = "${dir!.path}/$fileName";

      await dio.download(
        url,
        savePath,
        deleteOnError: false,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint("Download Progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      File downloadedFile = File(savePath);
      if (await downloadedFile.exists() && await downloadedFile.length() > 0) {
        return downloadedFile;
      }
      return null;
    } catch (e) {
      debugPrint("Download Error: $e");
      return null;
    }
  }
}