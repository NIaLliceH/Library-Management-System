import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/borrow_ticket_view.dart';
import '../api_service.dart';
import '../utils.dart';

class HistoryPage extends StatelessWidget {
  final String userId;
  const HistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: kBase2,
        title: Text(
          'Reading History',
          style: TextStyle(
            fontSize: 20,
            color: kBase4,
          ),
        ),
      ),
      body: FutureBuilder(
        future: ApiService.getBorrowTicketsOfUser(userId),
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
            final tickets = snapshot.data!;
            // add you are borrowing no books message
            return Padding(
              padding: EdgeInsets.only(right: 8, left: 8, top: 10),
              child: ListView(
                children: [
                  // notice message
                  Text(
                    'You are borrowing ${tickets.where((ticket) => !ticket.returned).length} / $maxBorrowTicketAmt books',
                    style: TextStyle(
                      fontSize: 15,
                      // fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true, // because no wrapping Container to set height
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BorrowTicketView(userId: userId, ticket: tickets[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 8),
                          height: 100,
                          decoration: BoxDecoration(
                            color: tickets[index].returned ? kBase0 : kBase2,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // title
                                  Text(
                                    Utils.processDisplayValue(tickets[index].bookTitle),
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
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              Utils.processDisplayValue(tickets[index].bookAuthor),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300)
                                          ),
                                          Text(
                                              Utils.processDisplayValue(tickets[index].bookCategory),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w300,
                                                  color: kBase3
                                              )
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          tickets[index].returned ?
                                            'Returned'
                                            : tickets[index].dueDate.isBefore(DateTime.now()) ?
                                              '${DateTime.now().difference(tickets[index].dueDate).inDays} day(s) overdue'
                                              : '${tickets[index].dueDate.difference(DateTime.now()).inDays} day(s) left',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: tickets[index].returned ?
                                              purpleStatus
                                              : tickets[index].dueDate.isBefore(DateTime.now()) ?
                                                redStatus
                                                : greenStatus,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}