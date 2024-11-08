class Book {
  final String name;
  final String author;
  final String category;
  final String imageUrl;
  final int noOfCopies;
  final int availableCopies;
  final int noOfPages;
  final double rating;
  final String publisher;
  final String description;

  Book({
    required this.name,
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
      name: json['name'],
      noOfCopies: int.parse(json['NoCopies']),
      availableCopies: int.parse(json['NoValidCopies']),
      noOfPages: int.parse(json['NoPages']),
      rating: double.parse(json['Rating']),
      publisher: json['Publisher'],
      description: json['Description'],
      imageUrl: json['ImageURL'] ?? 'https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w',
      author: json['Author'] ?? 'Unknown',
      category: json['Category'] ?? 'Unknown',
    );
}


// List<Book> newBooks = [
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
// ];
//
// List<Book> scienceCategory = [
//   Book(
//       title: "This is a very long book title that will be cut off This is a very long book",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 1,
//       category: 'Science'),
//   Book(
//       title: "This is a very long book title that will be cut off",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 1,
//       category: 'Science'),
//   Book(
//       title: "This is a very long book title that will be cut off",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 1,
//       category: 'Science'),
//   Book(
//       title: "This is a very long book title that will be cut off",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 1,
//       category: 'Science'),
// ];
//
// List<Book> artCategory = [
//   Book(
//       title: "This is a very long book title that will be cut off This is a very long book",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 1,
//       category: 'Science'),
//   Book(
//       title: "This is a very long book title that will be cut off",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 1,
//       category: 'Science'),
//   Book(
//       title: "This is a very long book title that will be cut off",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
// ];
//
// List<Book> computerCategory = [
//   Book(
//       title: "This is a very long book title that will be cut off This is a very long book",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 1,
//       category: 'Science'),
//   Book(
//       title: "This is a very long book title that will be cut off",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
// ];
//
// List<Book> topRatedBooks = [
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
// ];
//
// List<Book> mostBorrowedBooks = [
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
// ];
//
// List<Book> popularBooks = [
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "assets/images/book1.jpg",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
// ];
//
// List<Book> thesisBooks = [
//   Book(
//       title: "This is a very long book title that will be cut off This is a very long book",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 5,
//       category: 'Science'),
//   Book(
//       title: "Book 1",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 1,
//       category: 'Science'),
//   Book(
//       title: "This is a very long book title that will be cut off",
//       image: "https://drive.google.com/uc?export=view&id=1wOuHRLI_dIdiuNnv1XYcm3aDERsZVN0w",
//       author: 'Alicia Browns',
//       availableCopies: 0,
//       category: 'Science'),
// ];
//
// final List<String> categories = [
//   'Science',
//   'Art',
//   'Computer',
//   'Thesis'
// ];
//
// final Map<String, List<Book>> booksByCategory = {
//   'Science': scienceCategory,
//   'Art': artCategory,
//   'Computer': computerCategory,
//   'Thesis': thesisBooks,
// };
