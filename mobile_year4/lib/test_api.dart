// import 'dart:convert';
// import 'package:http/http.dart' as http;

// void main() async {
//   // 1. USE THE EXACT TOKEN FROM TINKER
//   const String token = "7|3YWbVcavsYEoBgvKhZmViEbuSgFpb6ZIE9OYPfd74c06e2c3";

//   // 2. USE THE CORRECT URL (api/orders)
//   const String url = "http://172.20.10.2:8000/api/orders";

//   print("🚀 Connecting to API with Token...");

//   try {
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token', // Ensure "Bearer " has a space!
//       },   
//     );

//     print("📡 Status: ${response.statusCode}");
//     if (response.statusCode == 200) {
//       print("✅ SUCCESS! Data: ${response.body}");
//     } else {

//       print("❌ FAILED: ${response.body}");
//     }
//   } catch (e) {
//     print("💥 Error: $e");
//   }
// }
