import 'package:flutter/material.dart';
import 'package:frontend/models/borrow_ticket.dart';
import 'package:frontend/screens/book_view.dart';
import 'package:frontend/screens/rate_form.dart';
import '../api_service.dart';
import '../constants.dart';
import '../utils.dart';

class BorrowTicketView extends StatelessWidget {
  final BorrowTicket ticket;
  final String userId;
  const BorrowTicketView({super.key, required this.ticket, required this.userId});

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
                              : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RateForm(userId: userId, bookId: ticket.bookId!),
                              ),
                            );
                          },
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
}