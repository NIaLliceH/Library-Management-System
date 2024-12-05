import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/screens/history_page.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/login_page.dart';
import 'package:frontend/screens/profile_page.dart';
import 'package:frontend/screens/tickets_page.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/user.dart';

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
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => LoginPage(),
      },
      // home: LoginPage(), // always start with login page
    );
  }
}

class MainPage extends StatefulWidget {
  final User user = thisUser!;

  MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomePage(),
      TicketsPage(),
      HistoryPage(),
      ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kBase1,
          unselectedItemColor: kBase2,
          backgroundColor: kBase3,
          onTap: _onItemTapped,

        ),
      ),
    );
  }
}
