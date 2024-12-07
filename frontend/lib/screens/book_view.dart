import 'package:flutter/material.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/book.dart';

class BookView extends StatelessWidget {
  final Book? book;
  final String bookId;
  const BookView({super.key, required this.bookId, this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: kBase2,
          title: Text(
            'Book View',
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
          future: book != null ? ApiService.getBookDetails(book!) : ApiService.getBookById(bookId),
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
              final isButtonDisabled = !book.canHold!;
              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // book cover
                        Center(
                          child: Image.network(
                            book.imageUrl,
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                        ),
                        // book info
                        Utils.displayInfo('Title', book.title),
                        Utils.displayInfo('Author', book.author),
                        Utils.displayInfo('Category', book.category),
                        Utils.displayInfo('Publisher', book.publisher),
                        Utils.displayInfo('Available', '${book.availableCopies} / ${book.noOfCopies} copies'),
                        Utils.displayInfo('No of Pages', book.noOfPages.toString()),
                        Utils.displayInfo('Rating', '${book.rating} / 5'),
                        Utils.displayInfo('Description', book.description),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton.extended(
                      label: Text('Hold this book'),
                      backgroundColor: isButtonDisabled ? Colors.grey : kBase3,
                      onPressed: isButtonDisabled ?
                      null
                      : () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final DateTime now = DateTime.now();
                            final DateTime deadline = now.add(Duration(days: maxHoldTicketDays));

                            return AlertDialog(
                              title: Text('Hold Ticket Information'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.displayInfo("Title", book.title),
                                  Utils.displayInfo("Author", book.author),
                                  Utils.displayInfo("Edition", book.edition),
                                  Utils.displayInfo("Start holding date", now),
                                  Utils.displayInfo("Due date", deadline),
                                  Text("You must come to the library to borrow "
                                      "this book before the due date, otherwise "
                                      "your hold ticket will be canceled."),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      final message = await ApiService.createHoldTicket(thisUser!.id, bookId);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(message),
                                            backgroundColor: greenStatus,
                                          ),
                                        );
                                        Navigator.pop(context); // close dialog
                                        Navigator.pop(context); // return to previous screen
                                      }
                                    }
                                    catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Error: $e'),
                                            backgroundColor: redStatus,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Text('Confirm'),
                                )
                              ],
                            );
                          }
                        );
                      },
                    ),
                  )
                ],
              );
            }
          }
        ),
    );
  }
}
