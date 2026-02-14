import 'dart:io';
import 'dart:convert';
import '../api_config.dart';
import 'package:http/http.dart' as http;

class FreeBookPdfService {
  static Future<http.Response> fetchAll() async {
    return await http.get(
      Uri.parse(ApiConfig.freeBooks),
      headers: ApiConfig.getHeaders(),
    );
  }

  static Future<http.StreamedResponse> store({
    required Map<String, String> fields,
    required File imageFile,
    required File pdfFile,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiConfig.freeBooks));
    request.headers.addAll(ApiConfig.getHeaders());

    request.fields.addAll(fields);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.files.add(await http.MultipartFile.fromPath('pdf_file', pdfFile.path));

    return await request.send();
  }

  static Future<http.Response> delete(String id) async {
    return await http.delete(
      Uri.parse("${ApiConfig.freeBooks}/$id"),
      headers: ApiConfig.getHeaders(),
    );
  }

  // FIXED: Uses POST with _method spoofing for Laravel compatibility
 static Future<http.Response> update(String id, Map<String, String> fields) async {
  // Use POST even for updates when dealing with Multipart/Laravel
  var request = http.MultipartRequest('POST', Uri.parse("${ApiConfig.freeBooks}/$id"));
  
  request.headers.addAll(ApiConfig.getHeaders());

  // Method Spoofing: This tells Laravel to treat the POST as a PUT
  request.fields['_method'] = 'PUT';
  request.fields.addAll(fields);

  var streamedResponse = await request.send();
  return await http.Response.fromStream(streamedResponse);
}
}