class Book {
  final String id;
  final String title;
  final List<String> author;
  final List<String> category;
  final String imageUrl;
  final int noOfCopies;
  final int availableCopies;
  final int noOfPages;
  final double rating;
  final String publisher;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.imageUrl,
    required this.noOfCopies,
    required this.availableCopies,
    required this.noOfPages,
    required this.rating,
    required this.publisher,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['name'],
      noOfCopies: int.parse(json['NoCopies']) ?? -1,
      availableCopies: int.parse(json['NoValidCopies']) ?? -1,
      noOfPages: int.parse(json['NoPages']) ?? -1,
      rating: double.parse(json['AvgRate']) ?? -1,
      publisher: json['Publisher'] ?? 'N/A',
      description: json['Description'] ?? 'N/A',
      imageUrl: json['imageUrl'] ??
          'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6', // placeholder image
      author: json['Author'] ?? 'N/A',
      category: json['Category'] ?? 'N/A',
    );
  }
}