import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/book.dart';

// Thai Hoa, do it :)
// after clicked on 'Confirm' button, navigate to TicketsPage screen
class HoldForm extends StatelessWidget {
  final Book book;

  const HoldForm({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: kBase2,
        title: Text(
          'Hold Ticket',
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
      body: Text('TO DO'),
    );
  }
}