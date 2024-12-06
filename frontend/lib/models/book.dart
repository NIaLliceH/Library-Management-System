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
    test(id: '2');
    print(json);
    return Book(
      id: json['_id'],
      title: json['name'] ?? 'N/A',
      author: List<String>.from(json['authors'] ?? ['N/A']),
      category: json['category'] ?? 'N/A',
      // imageUrl: json['imageUrl'] ?? 'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6', // placeholder image
      imageUrl: 'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6', // testing
      availableCopies: int.parse(json['NoValidCopies'] ?? '-1'),
    );
  }

  void updateDetails(Map<String, dynamic> json) {
    noOfCopies = int.parse(json['NoOfCopies'] ?? '-1');
    noOfPages = int.parse(json['NoPages'] ?? '-1');
    rating = double.parse(json['AvgRate'] ?? '-1');
    publisher = json['Publisher'] ?? 'N/A';
    edition = json['Edition'] ?? 'N/A';
    publishDate = json['dataPublish'] ?? 'N/A';
    description = json['Description'] ?? 'N/A';
    canHold = json['canHold'] ?? false;
  }
}