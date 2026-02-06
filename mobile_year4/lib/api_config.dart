class ApiConfig {
  // 1. The Base URL (Using your machine's Wi-Fi IP)
  // This works for both Physical Devices and Emulators on the same Wi-Fi
  static const String _baseUrl = "http://192.168.1.102:8000";

  // 2. The API Domain
  static const String _domain = "$_baseUrl/api";

  // 3. Auth Endpoints
  static const String login = "$_domain/login";
  static const String register = "$_domain/register";

  // 4. Admin Endpoints
  static const String categories = "$_domain/categories";
  static const String books = "$_domain/books";
  static const String users = "$_domain/users";
  static const String orders = "$_domain/orders";
  static const String sales = "$_domain/sales";
  static const String specialOffers = "$_domain/special-offers";
  static const String bestSelling = "$_domain/best-selling";


  // 5. Storage / Image Path
  // Use this for: Image.network("${ApiConfig.storage}${book.imagePath}")
  static const String storage = "$_baseUrl/storage/";

  // Helper for Headers (Consistency across all files)
  static Map<String, String> getHeaders([String? token]) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}