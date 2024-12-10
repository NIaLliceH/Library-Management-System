import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/borrow_ticket_view.dart';
import '../api_service.dart';
import 'package:frontend/auth_service.dart';
import '../utils.dart';
import 'login_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        future: ApiService.getBorrowTicketsOfUser(thisUser!.id),
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
            var tickets = snapshot.data!;
            tickets = Utils.sortBorrowTicketsByPriority(tickets);
            return Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: [
                  // notice message
                  Text(
                    'You are borrowing ${tickets.where((ticket) => !ticket.returned).length} / $maxBorrowTicketAmt books',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: purpleStatus,
                    ),
                  ),
                  ListView.builder(
                    // padding: EdgeInsets.only(top: 10),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true, // because no wrapping Container to set height
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BorrowTicketView(ticket: tickets[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          height: 100,
                          decoration: BoxDecoration(
                            color: tickets[index].returned ? kBase0 : kBase1,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    // author
                                    Text(
                                        Utils.processDisplayValue(tickets[index].bookAuthor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300)
                                    ),
                                    // category and status
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            Utils.processDisplayValue(tickets[index].bookCategory),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w300,
                                                color: kBase3
                                            )
                                        ),
                                        Text(
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