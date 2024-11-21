import 'package:flutter/material.dart';
import 'package:frontend/models/hold_ticket.dart';
import '../constants.dart';
import '../api_service.dart';
import '../utils.dart';

class HoldTicketView extends StatelessWidget {
  final HoldTicket ticket;
  final String userId;
  const HoldTicketView({super.key, required this.ticket, required this.userId});

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
            Navigator.pop(context, false);
          },
        ),
      ),
      body: FutureBuilder(
          future: ApiService.getHoldTicketDetails(ticket),
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
              final bool isButtonDisabled = ticket.canceled ||
                  ticket.dueDate.isBefore(DateTime.now());
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
                        Utils.displayInfo('Created on', ticket.createdDate),
                        Utils.displayInfo('Status', ticket.canceled ?
                        'canceled on ${Utils.processDisplayValue(ticket.canceledDate)}'
                            : ticket.dueDate.isBefore(DateTime.now()) ?
                        'expired on ${Utils.processDisplayValue(ticket.dueDate)}'
                            : 'due on ${Utils.processDisplayValue(ticket.dueDate)}'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton.extended(
                      onPressed: isButtonDisabled ?
                      null
                          : () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirm'),
                              content: Text('Are you sure you want to cancel this hold ticket?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          try {
                            ApiService.cancelHoldTicket(userId, ticket.id);
                            if (context.mounted) Navigator.pop(context, true);
                          } catch (error) {
                            if (context.mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Failed to cancel hold ticket: $error'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text('OK'),
                                        )
                                      ],
                                    );
                                  }
                              );
                            }
                          }
                        }
                      },
                      label: Text('Cancel'),
                      backgroundColor: isButtonDisabled ?
                      Colors.grey
                          : redStatus,
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