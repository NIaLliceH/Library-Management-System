import 'package:flutter/material.dart';

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
}