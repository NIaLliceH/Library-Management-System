import 'package:flutter/material.dart';
import 'package:frontend/screens/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Open Sans'),
      home: SafeArea(child: ProfileScreen()),
    );
  }
}
