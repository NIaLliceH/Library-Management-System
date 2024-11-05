class Book {
  final String title;
  final String image;
  final String author;
  final double price;

  Book(
      {required this.title,
      required this.image,
      required this.author,
      required this.price});
}

List<Book> newBooks = [
  Book(
      title: "Book 1",
      image: "assets/images/book1.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Book 2",
      image: "assets/images/book2.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Book 3",
      image: "assets/images/book3.jpg",
      author: 'Alicia Browns',
      price: 5.34),
];

List<Book> popularBooks = [
  Book(
      title: "Out Of The Blue",
      image: "assets/images/book1.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Soul",
      image: "assets/images/book2.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Harry Potter and the Deathly Hallows",
      image: "assets/images/book3.jpg",
      author: 'J.K. Rowling',
      price: 5.34),
  Book(
      title: "Book 4",
      image: "assets/images/book1.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Book 5",
      image: "assets/images/book2.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Book 6",
      image: "assets/images/book3.jpg",
      author: 'Alicia Browns',
      price: 5.34),
];
