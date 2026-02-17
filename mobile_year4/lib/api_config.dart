class ApiConfig {
// Change this line temporarily to test
static const String baseUrl = "http://192.168.1.104:8000";  
static const String _domain = "$baseUrl/api";

  static String? userToken;

  static const String login = "$_domain/login";
  static const String register = "$_domain/register";

  // Admin Endpoints
  static const String categories = "$_domain/categories";
  static const String books = "$_domain/books";
  static const String users = "$_domain/users";

  // Cart/User Orders (Frontend)
  static const String orders = "$_domain/orders";

  // NEW: Admin specific order list (Backend)
  static const String adminOrders = "$_domain/admin-orders";

  static const String sales = "$_domain/sales";
  static const String saleDetails = "$_domain/sale-details";

  static const String specialOffers = "$_domain/special-offers";
  static const String bestSelling = "$_domain/best-selling";
  static const String freeBooks = "$_domain/free-books";

  // Storage / Image Path
  static const String storage = "$baseUrl/";

  // Helper for Headers (Consistency across all files)
  static Map<String, String> getHeaders() {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (userToken != null) "Authorization": "Bearer $userToken",
    };
  }
}
