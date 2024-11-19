// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
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

