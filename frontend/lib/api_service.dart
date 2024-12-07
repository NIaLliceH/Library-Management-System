import 'dart:async';
import 'dart:convert';
import 'package:frontend/models/borrow_ticket.dart';
import 'package:frontend/models/hold_ticket.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/book.dart';
import 'package:frontend/constants.dart';

import 'globals.dart';
import 'models/admin.dart';
import 'models/student.dart';
import 'models/user.dart';

class ApiService {
  static const String baseUrl = apiUrl;

  // might never use this
  static Future<List<Book>> getAllBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      List<Book> books = data.map<Book>((dynamic item) => Book.fromBasicJson(item)).toList();
      return books;
    } else {
      throw 'Failed to load books';
    }
  }

  static Future<Book> getBookDetails(Book book, String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/books/${book.id}/$userId'));
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body)['data'];
      book.updateDetails(data);
      return book;
    } else {
      throw 'Failed to load book details';
    }
  }

  static Future<Book> getBookById(String id, String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/books/$id?userId=$userId'));
    if (response.statusCode == 200) {
      dynamic data = jsonDecode(response.body)['data'];
      Book book = Book.fromBasicJson(data);
      book.updateDetails(data);
      return book;
    } else {
      throw 'Failed to load book';
    }
  }

  static Future<List<Book>> getBooksByCategory(String category) async {
    if (category == 'All') {
      return getAllBooks();
    }

    final response = await http.get(Uri.parse('$baseUrl/books/category/$category'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      List<Book> books = data.map<Book>((dynamic item) => Book.fromBasicJson(item)).toList();
      return books;
    } else {
      throw 'Failed to load books';
    }
  }

  static Future<List<Book>> searchBookByName(String name) async {
    final response = await http.get(Uri.parse('$baseUrl/books/search?name=$name'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      List<Book> books = data.map((dynamic item) => Book.fromBasicJson(item)).toList();
      return books;
    } else if (response.statusCode == 404) {
      throw 'No book found';
    }
    else {
      throw 'Failed to load books';
    }
  }

  static Future<List<Book>> getBooksFiltered(BookFilter filter) async {
    String filterString;
    switch (filter) {
      case BookFilter.newRelease:
        filterString = 'newest';
        break;
      case BookFilter.topRated:
        filterString = 'top-rated';
        break;
      case BookFilter.mostBorrowed:
        filterString = 'most-borrowed';
        break;
    }
    final response = await http.get(Uri.parse('$baseUrl/books/$filterString'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      List<Book> books = data.map<Book>((dynamic item) => Book.fromBasicJson(item)).toList();
      return books;
    } else {
      throw 'Failed to load books';
    }
  }

  static Future<List<String>> getAllCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/books/categories'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']; // !!! data
      List<String> categories = data.map<String>((dynamic item) => item.toString()).toList();
      return categories;
    } else {
      throw 'Failed to load categories';
    }
  }

  static Future<List<HoldTicket>> getHoldTicketsOfUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/ticket/$userId/hold'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<HoldTicket> tickets = body.map((dynamic item) => HoldTicket.fromBasicJson(item)).toList();
      return tickets;
    } else {
      throw 'Failed to load hold tickets';
    }
  }

  static Future<HoldTicket> getHoldTicketInfo(String ticketId) async {
    final response = await http.get(Uri.parse('$baseUrl/hold_infor/$ticketId'));
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      HoldTicket ticket = HoldTicket.fromBasicJson(json);
      ticket.updateDetails(json);
      return ticket;
    } else {
      throw 'Failed to load hold ticket';
    }
  }

  static Future<HoldTicket> getHoldTicketDetails(HoldTicket ticket) async {
    final response = await http.get(Uri.parse('$baseUrl/hold_infor/${ticket.id}'));
    if (response.statusCode == 200) {
      ticket.updateDetails(jsonDecode(response.body));
      return ticket;
    } else {
      throw 'Failed to load hold ticket';
    }
  }

  static Future<List<BorrowTicket>> getBorrowTicketsOfUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/ticket/$userId/borrow'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<BorrowTicket> tickets = body.map((dynamic item) => BorrowTicket.fromBasicJson(item)).toList();
      return tickets;
    } else {
      throw 'Failed to load borrow tickets';
    }
  }

  static Future<BorrowTicket> getBorrowTicketInfo(String ticketId) async {
    final response = await http.get(Uri.parse('$baseUrl/borrow_infor/$ticketId'));
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.body);
      BorrowTicket ticket = BorrowTicket.fromBasicJson(json);
      ticket.updateDetails(json);
      return ticket;
    } else {
      throw 'Failed to load borrow ticket';
    }
  }

  static Future<BorrowTicket> getBorrowTicketDetails(BorrowTicket ticket) async {
    final response = await http.get(Uri.parse('$baseUrl/borrow_infor/${ticket.id}'));
    if (response.statusCode == 200) {
      ticket.updateDetails(jsonDecode(response.body));
      return ticket;
    } else {
      throw 'Failed to load borrow ticket';
    }
  }

  static Future<Student> loginStudent(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authen/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': username,
        'password': password,
        'role': 'student',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      if (data['role'] != 'student') {
        throw 'Invalid role';
      }
      Student student = Student.fromJson(data);
      if (!student.status) {
        throw 'Account is banned, please contact the library for more information';
      }
      return student;
    } else if (response.statusCode == 400) { // !!! should be 401
      throw 'Invalid username or password';
    } else {
      throw 'Other status code';
    }
  }

  static Future<String> createHoldTicket(String userId, String bookId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$userId/hold'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'ID_book': bookId,
      }),
    );

    if (response.statusCode == 200) {
      throw 'Hold ticket exists'; // this should not happen
    } else if (response.statusCode == 201) {
      return 'Hold ticket created successfully';
    } else {
      throw 'Failed to create hold ticket';
    }
  }

  // not implemented yet
  static Future<void> cancelHoldTicket(String userId, String ticketId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ticket/$ticketId/cancel'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw 'Failed to cancel hold ticket';
    }
  }

  static Future<String> rateBook(String bookId, String userId, int rating) async {
    final response = await http.post(
      Uri.parse('$baseUrl/books/$bookId/rate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'studentId': userId,
        'rating': rating,
      }),
    );

    if (response.statusCode == 200) {
      return 'Book rated successfully';
    } else {
      throw 'Failed to rate book';
    }
  }
}