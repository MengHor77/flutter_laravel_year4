class Book {
  final String id;
  final String name;
  final String author;
  final String price;
  final String? image;
  final String categoryName;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.price,
    this.image,
    required this.categoryName,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      name: json['name'] ?? 'Untitled',
      author: json['author'] ?? 'Unknown',
      price: json['price']?.toString() ?? '0.00',
      image: json['image'],
      categoryName: json['category'] != null ? json['category']['name'] : 'General',
    );
  }
}