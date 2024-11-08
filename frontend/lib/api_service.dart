import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/book.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<List<Book>> getAllBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Book> books = body.map((dynamic item) => Book.fromJson(item)).toList();
      return books;
    } else {
      throw 'Failed to load books';
    }
  }

  static Future<Book> getBookById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to load book';
    }
  }
}