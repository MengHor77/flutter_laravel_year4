class Book {
  final String id;
  final String name;
  final String author;
  final String price;        
  final String displayPrice; 
  final String? image;
  final String categoryName;
  final bool isOnSale;
  int quantity; // Added quantity field

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.price,
    required this.displayPrice,
    this.image,
    required this.categoryName,
    required this.isOnSale,
    this.quantity = 1, // Default to 1
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Untitled',
      author: json['author'] ?? 'Unknown',
      price: json['price']?.toString() ?? '0.00',
      displayPrice: (json['display_price'] ?? json['price']).toString(),
      image: json['image'],
      categoryName: (json['category'] != null && json['category']['name'] != null) 
          ? json['category']['name'].toString() 
          : 'General',
      isOnSale: json['is_on_sale'] ?? false,
      // If the API returns quantity (from orders table), use it; else 1
      quantity: json['quantity'] ?? 1, 
    );
  }
}