import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/hold_ticket.dart';
import '../api_service.dart';
import 'package:frontend/auth_service.dart';
import '../utils.dart';
import 'hold_ticket_view.dart';

class TicketsPage extends StatefulWidget {
  final String userId = thisUser!.id;
  TicketsPage({super.key});

  @override
  State<StatefulWidget> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  late Future<List<HoldTicket>> ticketsFuture;
  
  @override
  void initState() {
    super.initState();
    ticketsFuture = ApiService.getHoldTicketsOfUser(widget.userId);
  }

  void _refreshTickets() {
    setState(() {
      ticketsFuture = ApiService.getHoldTicketsOfUser(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        backgroundColor: kBase2,
        title: Text(
          'Ticket List',
          style: TextStyle(
            fontSize: 20,
            color: kBase4,
          ),
        ),
      ),
      body: FutureBuilder(
        future: ticketsFuture,
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
            tickets = Utils.sortHoldTicketsByPriority(tickets);
            return Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: [
                  // notice message for holding books (not canceled and not expired)
                  Text(
                    'You are holding ${tickets.where((ticket) => !ticket.canceled && ticket.dueDate.isAfter(DateTime.now())).length} / $maxHoldTicketAmt books',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: purpleStatus,
                    ),
                  ),
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true, // because no wrapping Container to set height
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HoldTicketView(ticket: tickets[index], userId: widget.userId),
                            ),
                          );

                          // need to refresh the list if the ticket is canceled
                          if (result == true) {
                            _refreshTickets(); // refresh the list on return
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          height: 100,
                          decoration: BoxDecoration(
                            color: tickets[index].canceled ? kBase0 : kBase1,
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
                                    // category
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
                                          tickets[index].canceled ?
                                          'canceled'
                                              : tickets[index].dueDate.isBefore(DateTime.now()) ?
                                          'expired'
                                              : '${tickets[index].dueDate.difference(DateTime.now()).inDays} day(s) left',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: tickets[index].canceled ?
                                              redStatus
                                                  : tickets[index].dueDate.isBefore(DateTime.now()) ?
                                              purpleStatus
                                                  : greenStatus,
                                              fontStyle: FontStyle.italic),
                                        )
                                      ],
                                    ),
                                
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