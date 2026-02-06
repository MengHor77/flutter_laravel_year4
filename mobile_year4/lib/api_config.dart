class ApiConfig {
  static const String _baseUrl = "http://192.168.1.102:8000"; // No /api here
  static const String _domain = "$_baseUrl/api";

  static const String categories = "$_domain/categories";
  static const String books = "$_domain/books";
  static const String login = "$_domain/login";
  static const String register = "$_domain/register";
  
  // Use this for Image.network()
  static const String storage = "$_baseUrl/storage/"; 
}