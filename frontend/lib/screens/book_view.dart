import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/screens/issue_form.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/constants.dart';

class BookView extends StatelessWidget {
  final String bookId;
  const BookView({super.key, required this.bookId});

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
          future: ApiService.getBookById(bookId),
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
              return Stack(
                children: [
                  SingleChildScrollView(
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
                        displayBookInfo('Title', book.title),
                        displayBookInfo('Author', book.author),
                        displayBookInfo('Category', book.category),
                        displayBookInfo('Publisher', book.publisher),
                        displayBookInfo('Available', '${book.availableCopies} / ${book.noOfCopies} copies'),
                        displayBookInfo('No of Pages', book.noOfPages.toString()),
                        displayBookInfo('Rating', '${book.rating} / 5'),
                        displayBookInfo('Description', book.description),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton.extended(
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
                  )
                ],
              );
            }
          }
        ),
    );
  }

  Widget displayBookInfo(String label, dynamic value) {
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
              Utils.processDisplayValue(value),
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
