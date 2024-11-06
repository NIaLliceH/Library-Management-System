class Book {
  final String title;
  final String image;
  final String author;
  final double price;
  final int id;

  Book(
      {required this.title,
      required this.image,
      required this.author,
      required this.price,
      required this.id});
}

List<Book> newBooks = [
  Book(
    title: "Book 1",
    id: 1,
    image: "assets/images/book1.jpg",
    author: 'Alicia Browns',
    price: 5.34,
  ),
  Book(
      title: "Book 2",
      id: 2,
      image: "assets/images/book2.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Book 3",
      id: 3,
      image: "assets/images/book3.jpg",
      author: 'Alicia Browns',
      price: 5.34),
];

List<Book> popularBooks = [
  Book(
      title: "Out Of The Blue",
      id: 4,
      image: "assets/images/book1.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Soul",
      id: 5,
      image: "assets/images/book2.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Harry Potter and the Deathly Hallows",
      id: 6,
      image: "assets/images/book3.jpg",
      author: 'J.K. Rowling',
      price: 5.34),
  Book(
      title: "Book 4",
      id: 7,
      image: "assets/images/book1.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Book 5",
      id: 8,
      image: "assets/images/book2.jpg",
      author: 'Alicia Browns',
      price: 5.34),
  Book(
      title: "Book 6",
      id: 9,
      image: "assets/images/book3.jpg",
      author: 'Alicia Browns',
      price: 5.34),
];
