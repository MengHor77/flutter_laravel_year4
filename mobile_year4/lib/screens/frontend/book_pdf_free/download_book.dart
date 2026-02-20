import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class BookSaver {
  static Future<void> saveAndNotify(
    String url,
    String fileName,
    BuildContext context,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Downloading $fileName..."),
        duration: const Duration(seconds: 1),
      ),
    );

    File? file = await BookDownloader.downloadFile(url, fileName);

    if (!context.mounted) return;

    if (file != null && await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Success! Saved to Downloads"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
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
    // 1. Configure Dio to be more patient with local servers
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 0), // Wait as long as needed
        persistentConnection: true,
      ),
    );

    String savePath = "";

    try {
      // 2. Determine the save folder
      Directory? dir;
      if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      if (dir == null) return null;
      savePath = "${dir.path}/$fileName";

      // 3. Start download
      await dio.download(
        url,
        savePath,
        deleteOnError:
            false, // CRITICAL: Don't delete if connection snaps at 100%
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint(
              "Download Progress: ${(received / total * 100).toStringAsFixed(0)}%",
            );
          }
        },
      );

      File downloadedFile = File(savePath);
      if (await downloadedFile.exists() && await downloadedFile.length() > 0) {
        return downloadedFile;
      }
      return null;
    } on DioException catch (e) {
      // 4. Handle the "Connection closed" error specifically
      debugPrint("Dio Error: ${e.type} - ${e.message}");

      if (savePath.isNotEmpty) {
        File file = File(savePath);
        // If the file actually exists and has content, ignore the error
        if (await file.exists() && await file.length() > 0) {
          debugPrint("File downloaded despite connection error. Proceeding.");
          return file;
        }
      }
      return null;
    } catch (e) {
      debugPrint("General Error: $e");
      return null;
    }
  }
}
