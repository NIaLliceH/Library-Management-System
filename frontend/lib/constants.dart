import 'package:flutter/material.dart';

// base color of the app
const Color kBase0 = Color(0x88CBDCEB);
const Color kBase1 = Color(0xFFDCF2F1);
const Color kBase2 = Color(0xF5608BC1);
const Color kBase3 = Color(0xFF365486);
const Color kBase4 = Color(0xFF0F1035);

// status of ticket
const Color greenStatus = Color(0xFF508D4E);
const Color redStatus = Color(0xFFFA7070);
const Color purpleStatus = Color(0xFF674188);

// button color
const Color holdButton = Color(0xFF365486);
const Color confirmButton = Color(0xFF508D4E); // for hold ticket, YES and submit rating
const Color cancelButton = Color(0xFFFA7070); // for cancel ticket and NO
const Color rateButton = Color(0xFFCA7373);
const Color viewButton = Color(0xFF365486);
const Color loginButton = Color(0xFF365486);
const Color logoutButton = Color(0xFFFA7070);

const apiUrl = 'http://192.168.22.170:3000/api';

// enum type for book category
enum BookFilter {
  newRelease,
  topRated,
  mostBorrowed,
}

const maxBorrowTicketAmt = 5;
const maxHoldTicketAmt = 5;