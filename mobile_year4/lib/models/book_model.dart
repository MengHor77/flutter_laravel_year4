class Book {
  final String id;
  final String name;
  final String author;
  final String price;        // Original Price
  final String displayPrice; // Special Offer Price
  final String? image;
  final String categoryName;
  final bool isOnSale;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.price,
    required this.displayPrice,
    this.image,
    required this.categoryName,
    required this.isOnSale,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '', // Safe conversion
      name: json['name'] ?? 'Untitled',
      author: json['author'] ?? 'Unknown',
      price: json['price']?.toString() ?? '0.00',
      // If on sale, use display_price from Laravel; otherwise use price
      displayPrice: (json['display_price'] ?? json['price']).toString(),
      image: json['image'],
      categoryName: (json['category'] != null && json['category']['name'] != null) 
          ? json['category']['name'].toString() 
          : 'General',
      isOnSale: json['is_on_sale'] ?? false,
    );
  }
}