import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/book.dart';
import 'package:frontend/constants.dart';

class ApiService {
  static const String baseUrl = apiUrl;

  static Future<List<Book>> getAllBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Book> books = body.map((dynamic item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw 'Failed to load books';
    }
  }

  static Future<Book> getBookById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/books/$id'));
    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to load book';
    }
  }

  static Future<List<Book>> getBooksByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/books/category/$category'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Book> books = body.map((dynamic item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw 'Failed to load books';
    }
  }

  static Future<List<Book>> searchBookByName(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/books/search?q=$query'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Book> books = body.map((dynamic item) => Book.fromJson(item)).toList();
      return books;
    } else {
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
      List<dynamic> body = jsonDecode(response.body);
      List<Book> books = body.map((dynamic item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw 'Failed to load books';
    }
  }

  static Future<List<String>> getCategoryList() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<String> categories = body.map((dynamic item) => item.toString()).toList();
      return categories;
    } else {
      throw 'Failed to load categories';
    }
  }

}