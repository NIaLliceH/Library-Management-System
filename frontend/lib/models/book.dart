class Book {
  final String id;
  final String title;
  final List<String> author;
  final String category;
  final String imageUrl;
  final int availableCopies;

  int? noOfCopies;
  int? noOfPages;
  double? rating;
  String? publisher;
  String? edition;
  String? publishDate;
  String? description;
  bool? canHold;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.imageUrl,
    required this.availableCopies,

    this.noOfCopies,
    this.noOfPages,
    this.rating,
    this.publisher,
    this.edition,
    this.publishDate,
    this.description,
    this.canHold,
  });

  factory Book.fromBasicJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['name'],
      author: json['Author'] ?? 'N/A',
      category: json['Category'] ?? 'N/A',
      imageUrl: json['imageUrl'] ?? 'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6', // placeholder image
      availableCopies: int.parse(json['NoValidCopies'] ?? '-1'),
    );
  }

  void updateDetails(Map<String, dynamic> json) {
    noOfCopies = int.parse(json['NoOfCopies'] ?? '-1');
    noOfPages = int.parse(json['NoOfPages'] ?? '-1');
    rating = double.parse(json['Rating'] ?? '-1');
    publisher = json['Publisher'] ?? 'N/A';
    edition = json['Edition'] ?? 'N/A';
    publishDate = json['PublishDate'] ?? 'N/A';
    description = json['Description'] ?? 'N/A';
    canHold = json['canHold'] ?? false;
  }
}