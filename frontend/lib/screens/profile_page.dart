import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/user.dart';

// Ngoc Hoa, do it :)
// add Logout button, go back to Login screen after clicked on 'Logout' button
class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: kBase2,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            color: kBase4,
          ),
        ),
      ),
      body: Text('TO DO'),
    );
  }
}