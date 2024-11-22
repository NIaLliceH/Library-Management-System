import 'package:flutter/material.dart';
import 'package:frontend/models/borrow_ticket.dart';

import 'models/book.dart';
import 'models/hold_ticket.dart';

class Utils {
  static String processDisplayValue(dynamic value) {
    if (value is List<String>) {
      return value.join(', ');
    } else if (value is DateTime) {
      return value.toIso8601String().substring(0, 10); // format???
    } else {
      return value.toString();
    }
  }

  static Widget displayInfo(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              // fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              Utils.processDisplayValue(value),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

  static List<BorrowTicket> sortBorrowTicketsByPriority(List<BorrowTicket> tickets) {
    final now = DateTime.now();

    final overdue = tickets.where((ticket) => !ticket.returned && ticket.dueDate.isBefore(now)).toList();
    final aboutToDue = tickets.where((ticket) => !ticket.returned && ticket.dueDate.isAfter(now)).toList();
    final returned = tickets.where((ticket) => ticket.returned).toList();

    overdue.sort((a, b) => b.dueDate.compareTo(a.dueDate)); // farthest dueDate first
    aboutToDue.sort((a, b) => a.dueDate.compareTo(b.dueDate)); // closest dueDate first
    returned.sort((a, b) => a.returnedDate!.compareTo(b.returnedDate!)); // closest returnedDate first

    return [...overdue, ...aboutToDue, ...returned];
  }

  static List<HoldTicket> sortHoldTicketsByPriority(List<HoldTicket> tickets) {
    final now = DateTime.now();

    final aboutToDue = tickets.where((ticket) => !ticket.canceled && ticket.dueDate.isAfter(now)).toList();
    final others = tickets.where((ticket) => ticket.canceled || ticket.dueDate.isBefore(now) || ticket.dueDate.isAtSameMomentAs(now)).toList();

    aboutToDue.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    others.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return [...aboutToDue, ...others];
  }

  static List<Book> sortBooksByAvailableCopies(List<Book> books) {
    books.sort((a, b) => b.availableCopies.compareTo(a.availableCopies)); // book with most available copies first
    return books;
  }
}