import 'package:flutter/material.dart';

// Ngoc Hoa, do it :)
// after clicked on 'Submit' button, go back to the previous screen
class RateForm extends StatelessWidget {
  final String userId;
  final String bookId;
  const RateForm({super.key, required this.userId, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Rate Form'),
    );
  }
}