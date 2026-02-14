class FreeBookPdf {
  final String id;
  final String name;
  final String author;
  final String image;
  final String pdfFile;
  final String categoryName;
  final String categoryId;

  FreeBookPdf({
    required this.id,
    required this.name,
    required this.author,
    required this.image,
    required this.pdfFile,
    required this.categoryName,
    required this.categoryId,
  });

  factory FreeBookPdf.fromJson(Map<String, dynamic> json) {
    return FreeBookPdf(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      author: json['author'] ?? '',
      image: json['image'] ?? '',
      pdfFile: json['pdf_file'] ?? '',
      // Display name from the joined category table
      categoryName: json['category'] != null
          ? json['category']['name']
          : 'Free',
      // The actual ID needed for database updates
      categoryId: (json['category_id'] ?? '1').toString(),
    );
  }
}
