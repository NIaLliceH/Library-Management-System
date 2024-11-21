import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/book_view.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/api_service.dart';

class CategoryResult extends StatelessWidget {
  final String category;
  const CategoryResult({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: kBase2,
        title: Text(
          'Category: $category',
          style: TextStyle(
            fontSize: 20,
            color: kBase4,
          ),
        ),
        leading: IconButton(
          color: kBase3,
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: ApiService.getBooksByCategory(category),
        // future: ApiService.getAllBooks(), // temporary
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true, // because no wrapping Container to set height
              itemCount: books.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookView(bookId: books[index].id),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 8),
                    height: 100,
                    decoration: BoxDecoration(
                      color: kBase0,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // book cover
                        Expanded(
                          flex: 1,
                          child: Container(
                            // height: 90,
                            margin: EdgeInsets.only(right: 10),
                            child: Image.network(
                              books[index].imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // book info
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // title
                              Text(
                                books[index].title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: kBase3
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // author and category
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          Utils.processDisplayValue(books[index].author),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300)
                                      ),
                                      Text(
                                          Utils.processDisplayValue(books[index].category),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w300,
                                              color: kBase3
                                          )
                                      ),
                                    ],
                                  ),
                                  // available copies
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${books[index].availableCopies} available',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: books[index].availableCopies > 0 ? greenStatus : redStatus,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}