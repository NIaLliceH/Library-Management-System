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
            var tickets = snapshot.data!;
            tickets = Utils.sortHoldTicketsByPriority(tickets);
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

class TListPage extends StatelessWidget {
  @override
  Widget build(context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
              color: Color(0xFF365486),
              height: 50,
              width: double.infinity,
              child: Text(
                ' Ticket List',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFF0F1035),
                ),
              )),
        ),
        Expanded(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                Text(
                  'You\'re holding 4/5 books:',
                  style: TextStyle(
                    fontSize: 25,
                    color: const Color.fromARGB(255, 31, 140, 230),
                  ),
                ),
                SizedBox(height: 15),
                TicketItem(
                  name: 'Secret Window, secret garden',
                  id: 'x000000000000',
                  tid: '2211129-ThaiHoa-abc-11/11',
                  expired: 14,
                ),
                SizedBox(height: 10),
                TicketItem(
                    name: 'All You Zombies',
                    id: 'x000000000001',
                    tid: '2211129-ThaiHoa-bcd-12/12',
                    expired: 9),
                SizedBox(height: 10),
                TicketItem(
                    name: ' A Song of Ice and Fire book 1',
                    id: 'x000000000002',
                    tid: '2211129-ThaiHoa-1/1',
                    expired: 8),
                SizedBox(height: 10),
                TicketItem(
                    name: 'The Godfather',
                    id: 'x000000000003',
                    tid: '2211129-ThaiHoa-2/2',
                    expired: 10),
              ],
            ),
          ),
        ))
      ],
    );
  }
}

class TicketItem extends StatelessWidget {
  const TicketItem({
    super.key,
    required this.name,
    required this.id,
    required this.tid,
    required this.expired,
  });
  final name;
  final id;
  final tid;
  final expired;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 238, 238, 238),
          width: 5.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        color: const Color.fromARGB(255, 222, 240, 255),
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$name',
                style: TextStyle(
                  color: Color(0xFF365486),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text('BOOK-ID: $id',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      color: const Color.fromARGB(255, 110, 110, 110))),
              SizedBox(height: 20),
              Text('TICKET-ID: $tid',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              Align(
                  alignment: Alignment.topRight,
                  child: Text('$expired days left',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 17,
                          fontWeight: FontWeight.w300,
                          color: const Color.fromARGB(255, 255, 130, 130))))
            ],
          ),
        ),
      ),
    );
  }
}

