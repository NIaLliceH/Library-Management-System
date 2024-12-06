class HoldTicket {
  final String id;
  final String bookTitle;
  final List<String> bookAuthor;
  final String bookCategory;
  final bool canceled; // true: canceled, false: active
  final DateTime createdDate;
  final DateTime dueDate;

  String? bookId;
  String? bookImageUrl;
  String? bookEdition;
  DateTime? canceledDate;

  HoldTicket({
    required this.id,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCategory,
    required this.canceled,
    required this.createdDate,
    required this.dueDate,

    this.bookId,
    this.bookImageUrl,
    this.bookEdition,
    this.canceledDate,
  });

  factory HoldTicket.fromBasicJson(Map<String, dynamic> json) {
    return HoldTicket(
      id: json['_id'],
      bookTitle: json['bookTitle'],
      bookAuthor: List<String>.from(json['bookAuthor']),
      bookCategory: json['bookCategory'] ?? 'N/A',
      canceled: json['status'],
      createdDate: DateTime.parse(json['createdDate']),
      dueDate: DateTime.parse(json['dueDate']),
    );
  }

  void updateDetails(Map<String, dynamic> json) {
    bookId = json['bookId'];
    bookImageUrl = json['bookImageUrl'] ?? 'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6'; // placeholder image
    bookEdition = json['bookEdition'];
    if (canceled) {
      canceledDate = DateTime.parse(json['canceledDate']);
    }
  }
}