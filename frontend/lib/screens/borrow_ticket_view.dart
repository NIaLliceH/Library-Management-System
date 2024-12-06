import 'package:flutter/material.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/models/borrow_ticket.dart';
import 'package:frontend/screens/book_view.dart';
import '../api_service.dart';
import '../constants.dart';
import '../utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BorrowTicketView extends StatelessWidget {
  final BorrowTicket ticket;
  final String userId = thisUser.id;
  BorrowTicketView({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: kBase2,
        title: Text(
          'Hold Ticket View',
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
          future: ApiService.getBorrowTicketDetails(ticket),
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
              final ticket = snapshot.data!;
              final bool disableRateButton = ticket.hasRated!;
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
                            ticket.bookImageUrl!, // sure to have a value
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                        ),
                        // book info
                        Utils.displayInfo('Ticket ID', ticket.id),
                        Utils.displayInfo('Title', ticket.bookTitle),
                        Utils.displayInfo('Author', ticket.bookAuthor),
                        Utils.displayInfo('Category', ticket.bookCategory),
                        Utils.displayInfo('Edition', ticket.bookEdition),
                        Utils.displayInfo('Borrowed on', ticket.createdDate),
                        Utils.displayInfo('Status', ticket.returned ?
                        'returned on ${Utils.processDisplayValue(ticket.returnedDate)}'
                            : ticket.dueDate.isBefore(DateTime.now()) ?
                        'overdue since ${Utils.processDisplayValue(ticket.dueDate)}'
                            : 'due on ${Utils.processDisplayValue(ticket.dueDate)}'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // rate book button
                        FloatingActionButton.extended(
                          onPressed: disableRateButton ?
                          null
                              : () => _showRateDialog(context, ticket),
                          label: Text('Rate Book'),
                          backgroundColor: disableRateButton ?
                          Colors.grey
                              : greenStatus,
                        ),
                        // view book button
                        FloatingActionButton.extended(
                          label: Text('View Book'),
                          backgroundColor: kBase3,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookView(bookId: ticket.bookId!),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          }
      ),
    );
  }

  void _showRateDialog(BuildContext context, BorrowTicket ticket) {
    int rating = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Utils.displayInfo('Title', ticket.bookTitle),
              Utils.displayInfo('Author', ticket.bookAuthor),
              Utils.displayInfo('Edition', ticket.bookEdition),
              Text('Rate this book:'),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                maxRating: 5,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value.toInt();
                },
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final message = await ApiService.rateBook(ticket.bookId!, userId, rating);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: greenStatus,
                      ),
                    );
                    Navigator.pop(context);
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
              child: Text('Submit'),
            )
          ],
        );
      }
    );
  }
}