import 'package:flutter/material.dart';

// base color of the app
const Color kBase0 = Color(0x88CBDCEB);
const Color kBase1 = Color(0xFFD7EAF8);
const Color kBase2 = Color(0xF5608BC1);
const Color kBase3 = Color(0xFF365486);
const Color kBase4 = Color(0xFF0F1035);

// status of ticket
const Color greenStatus = Color(0xFF508D4E);
const Color redStatus = Color(0xFFFA7070);
const Color purpleStatus = Color(0xFF674188);

// button color
const Color holdButton = Color(0xFF365486);
const Color confirmButton = Color(0xFF0D9276); // for hold ticket, YES and submit rating
const Color cancelButton = Color(0xFFFA7070); // for cancel ticket and NO
const Color rateButton = Color(0xFFCA7373);
const Color viewButton = Color(0xFF365486);
const Color loginButton = Color.fromARGB(255, 85, 139, 255);
const Color logoutButton = Color(0xFFFA7070);

// text color
const Color placeholderText = Color.fromARGB(255, 167, 167, 167);
const Color popUp = Color(0xFFEBF4F6);

// card color
const Color activeTicket = Color(0xFFD7EAF8);
const Color inactiveTicket = Color(0xFF89A8B2);


const apiUrl = 'http://192.168.222.170:3001/api';

// enum type for book category
enum BookFilter {
  newRelease,
  topRated,
  mostBorrowed,
}

const maxBorrowTicketAmt = 5;
const maxHoldTicketAmt = 5;
const maxHoldTicketDays = 7;
const maxBorrowTicketDays = 14;