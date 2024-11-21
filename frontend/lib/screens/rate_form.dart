import 'package:flutter/material.dart';
import 'package:frontend/models/borrow_ticket.dart';
import '../constants.dart';
import '../models/book.dart';

// Ngoc Hoa, do it :)
// Note: after clicked on 'Submit' button, go back to the previous screen
class RateForm extends StatelessWidget {
  final String userId;
  final BorrowTicket ticket;
  // cac thong tin can thiet cua book deu nam trong ticket (vd: bookID, bookTitle, bookAuthor, bookImageUrl, bookEdition)

  const RateForm({super.key, required this.userId, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: kBase2,
        title: Text(
          'Rate Book',
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