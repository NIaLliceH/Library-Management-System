import 'package:flutter/material.dart';
import 'package:frontend/models/book.dart';
import 'package:frontend/api_service.dart';

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
                    )
                  ],
                ),
              );
            }
          }
        ),
    );
  }
}
