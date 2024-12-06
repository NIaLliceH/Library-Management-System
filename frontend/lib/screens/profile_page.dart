import 'package:flutter/material.dart';
import 'package:frontend/auth_service.dart';
import 'package:frontend/globals.dart';
import '../constants.dart';
import '../models/user.dart';

class ProfilePage extends StatelessWidget {
  final User user = thisUser!;
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
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
              ),
              SizedBox(height: 16),
              // Name
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              // Email
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),
              // Profile Information
              _buildInfoRow('Gender', user.gender),
              Divider(),
              _buildInfoRow('Address', user.address),
              Divider(),
              _buildInfoRow('Phone Number', user.phoneNum),
              Divider(),
              _buildInfoRow('User ID', user.id),
              SizedBox(height: 32),
              // Logout Button
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    // Add logout functionality later?
                    thisUser = null;
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
