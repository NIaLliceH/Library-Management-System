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
      id: json['borrowTicket_ID'] ?? 'N/A',
      bookTitle: json['title'] ?? 'N/A',
      bookAuthor: List<String>.from(json['author']).isEmpty ? ['N/A'] : List<String>.from(json['author']),
      bookCategory: json['category'] ?? 'N/A',
      returned: json['status'] == 'borrowing' ? false : true,
      createdDate: DateTime.parse(json['createdDate']),
      dueDate: DateTime.parse(json['expiredDate']),
    );
  }

  void updateDetails(Map<String, dynamic> json) {
    bookId = json['bookID'];
    bookImageUrl = json['imageUrl'] ?? 'https://drive.google.com/uc?export=view&id=1oxjzdaMKjybjbwoduSXd9mGGJDPTcJD6'; // placeholder image
    bookEdition = json['edition'] ?? 'N/A';
    if (returned) {
      returnedDate = DateTime.parse(json['returnedDate']);
    }
    hasRated = json['hasRated'].toString() == '1' ? true : false;
  }
}