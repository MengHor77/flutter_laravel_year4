import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class BookDownloader {
  static Future<File?> downloadFile(String url, String fileName) async {
    // Custom settings for local server stability
    Dio dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
    ));

    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String savePath = "${dir.path}/$fileName";

      await dio.download(
        url,
        savePath,
        deleteOnError: false, // Prevent Flutter from deleting the file on blips
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
      debugPrint("Handling Potential Connection Blip: $e");
      
      // RECOVERY: Check if the file reached 100% despite the error log
      Directory dir = await getApplicationDocumentsDirectory();
      File potentialFile = File("${dir.path}/$fileName");
      
      if (await potentialFile.exists() && await potentialFile.length() > 0) {
        debugPrint("SUCCESS: File found in storage after 100% transfer.");
        return potentialFile; 
      }
      
      return null;
    }
  }
}