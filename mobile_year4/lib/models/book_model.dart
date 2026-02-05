class Book {
  final String id;
  final String title;
  final String author;
  final String price;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
  });

  //  include a factory for JSON (Mock API ready)
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      price: json['price'],
      imageUrl: json['image'],
    );
  }
}