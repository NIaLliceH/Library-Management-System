class HoldTicket {
  final String id;
  final String bookTitle;
  final List<String> bookAuthor;
  final String bookCategory;
  final bool canceled; // true: canceled, false: active
  final DateTime createdDate;
  final DateTime dueDate;

  // String? bookId;
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

    // this.bookId,
    this.bookImageUrl,
    this.bookEdition,
    this.canceledDate,
  });

  factory HoldTicket.fromBasicJson(Map<String, dynamic> json) {
    return HoldTicket(
      id: json['holdTicket_ID'] ?? 'N/A',
      bookTitle: json['title'] ?? 'N/A',
      bookAuthor: List<String>.from(json['author']).isEmpty ? ['N/A'] : List<String>.from(json['author']),
      bookCategory: json['category'] ?? 'N/A',
      canceled: json['status'] == 'valid' ? false : true,
      createdDate: DateTime.parse(json['createdDate']),
      dueDate: DateTime.parse(json['expiredDate']),
    );
  }

  void updateDetails(Map<String, dynamic> json) {
    // bookId = json['bookId'];
    bookImageUrl = json['imageUrl'] ?? 'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6'; // placeholder image
    bookEdition = json['edition'];
    if (canceled) {
      canceledDate = DateTime.parse(json['canceledDate']);
    }
  }
}