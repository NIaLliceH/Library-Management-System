import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/hold_ticket.dart';
import '../api_service.dart';
import '../utils.dart';
import 'hold_ticket_view.dart';

class TicketsPage extends StatefulWidget {
  final String userId;
  const TicketsPage({super.key, required this.userId});

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
        future: ApiService.getHoldTicketsOfUser(widget.userId),
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
                    'You are holding ${tickets.where((ticket) => !ticket.canceled).length} / $maxHoldTicketAmt books',
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
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HoldTicketView(ticket: tickets[index], userId: widget.userId),
                            ),
                          );

                          if (result == true) {
                            _refreshTickets(); // refresh the list on return
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 8),
                          height: 100,
                          decoration: BoxDecoration(
                            color: tickets[index].canceled ? kBase0 : kBase2,
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