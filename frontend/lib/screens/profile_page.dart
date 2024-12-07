import 'package:flutter/material.dart';
import 'package:frontend/auth_service.dart';
import '../constants.dart';
import '../models/student.dart';
import '../utils.dart';

class ProfilePage extends StatelessWidget {
  final Student student = thisUser as Student;
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(student.avatarUrl),
                ),
              ),
              SizedBox(height: 16),
              // Name
              Text(
                student.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              // Email
              Text(
                student.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),
              // Profile Information
              Utils.displayInfo('User ID', student.id),
              Divider(),
              Utils.displayInfo('MSSV', student.mssv),
              Divider(),
              Utils.displayInfo('Date of Birth', student.dob),
              Divider(),
              Utils.displayInfo('Gender', student.gender),
              Divider(),
              Utils.displayInfo('Address', student.address),
              Divider(),
              Utils.displayInfo('Join date', student.joinDate),
              Divider(),
              Utils.displayInfo('Faculty', student.faculty),
              Divider(),
              Utils.displayInfo('Number of Warning', student.numOfWarning),
              SizedBox(height: 32),
              // Logout Button
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    // Add logout functionality later?
                    // thisUser = null;
                    await AuthService.clearLoginState();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login'); // cant go back
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
