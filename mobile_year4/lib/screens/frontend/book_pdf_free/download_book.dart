import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class BookDownloader {
  // Method correctly takes exactly 2 arguments
  static Future<File?> downloadFile(String url, String fileName) async {
    Dio dio = Dio();
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String savePath = "${dir.path}/$fileName";

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint("Download Progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );

      return File(savePath);
    } catch (e) {
      debugPrint("Download Error: $e");
      return null;
    }
  }
}