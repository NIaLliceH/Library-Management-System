import 'package:flutter/material.dart';
import 'package:frontend/models/book.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/screens/issue_form.dart';

import '../constants.dart';

class BookView extends StatelessWidget {
  final Book book;

  const BookView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: kBase2Color,
          title: Text(
            'Book View',
            style: TextStyle(
              fontSize: 20,
              color: kBase4Color,
            ),
          ),
          leading: IconButton(
            color: kBase3Color,
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder(
          future: ApiService.getBookById('672d8ef58b1e31655e4df5c2'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            else if (!snapshot.hasData) {
              return Center(
                child: Text('No data available'),
              );
            }
            else {
              final book = snapshot.data!;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        book.imageUrl,
                        fit: BoxFit.cover,
                        height: 300,
                      ),
                    ),
                    buildBookInfo('Title', book.title),
                    buildBookInfo('Author', book.author),
                    buildBookInfo('Category', book.category),
                    buildBookInfo('Publisher', book.publisher),
                    buildBookInfo('Available', '${book.availableCopies} / ${book.noOfCopies} copies'),
                    buildBookInfo('No of Pages', book.noOfPages.toString()),
                    buildBookInfo('Rating', '${book.rating} / 5'),
                    buildBookInfo('Description', book.description),
                  ],
                ),
              );
            }
          }
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IssueForm(bookId: book.id),
              ),
            );
          },
          label: Text('Issue this book'),
        ),
    );
  }

  Widget buildBookInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              // fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
