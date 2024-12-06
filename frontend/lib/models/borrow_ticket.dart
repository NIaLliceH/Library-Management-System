class BorrowTicket {
  final String id;
  final String bookTitle;
  final List<String> bookAuthor;
  final String bookCategory;
  final bool returned; // true: returned, false: active
  final DateTime createdDate;
  final DateTime dueDate;

  String? bookId;
  // String? copyId;
  String? bookImageUrl;
  String? bookEdition;
  DateTime? returnedDate;
  bool? hasRated;

  BorrowTicket({
    required this.id,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCategory,
    required this.returned,
    required this.createdDate,
    required this.dueDate,

    this.bookId,
    this.bookImageUrl,
    this.bookEdition,
    this.returnedDate,
    this.hasRated,
  });

  factory BorrowTicket.fromBasicJson(Map<String, dynamic> json) {
    return BorrowTicket(
      id: json['_id'],
      bookTitle: json['bookTitle'],
      bookAuthor: List<String>.from(json['bookAuthor']),
      bookCategory: json['bookCategory'] ?? 'N/A',
      returned: json['status'],
      createdDate: DateTime.parse(json['createdDate']),
      dueDate: DateTime.parse(json['dueDate']),
    );
  }

  void updateDetails(Map<String, dynamic> json) {
    bookId = json['bookId'];
    bookImageUrl = json['bookImageUrl'] ?? 'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6'; // placeholder image
    bookEdition = json['bookEdition'];
    if (returned) {
      returnedDate = DateTime.parse(json['returnedDate']);
    }
    hasRated = json['hasRated'] ?? true;
  }
}