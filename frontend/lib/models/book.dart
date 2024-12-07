import '../globals.dart';

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
    String url = 'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6'; // placeholder image
    if (json['imageUrl'] != null && json['imageUrl'].toString().trim() != '') {
      url = json['imageUrl'];
    }

    return Book(
      id: json['bookId'],
      title: json['name'] ?? 'N/A',
      // author: List<String>.from(json['author']).isEmpty ? ['N/A'] : List<String>.from(json['author']),
      author: List<String>.from(json['authors'] ?? ['N/A']),
      category: json['category'] ?? 'N/A',
      imageUrl: url,
      availableCopies: json['NoAvaiCopies'] ?? 0,
    );
  }

  void updateDetails(Map<String, dynamic> json) {
    noOfCopies = json['noCopies'] ?? -1;
    noOfPages = json['noPages'] ?? -1;
    rating = double.parse(json['avgRating'] ?? '-1');
    publisher = json['publisher'] ?? 'N/A';
    edition = json['edition'] ?? 'N/A';
    publishDate = json['publishDate'] == null ? 'N/A' : json['publishDate'].toString().substring(0, 10);
    description = json['description'] ?? 'N/A';
    canHold = json['canHold'] == 1 ? true : false;
  }
}