import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/login_page.dart';
import 'package:frontend/screens/issue_form.dart';
import 'package:frontend/screens/tickets_page.dart';
// import 'auth.dart';
// import 'ticket.dart';
// import 'ticketList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Open Sans',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = TicketPage();
      case 1:
        page = TicketPage();
      case 2:
        page = TListPage();
      case 3:
        page = AuthPageNewVersion();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 1000,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.lock),
                    label: Text('Auth'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.tab),
                    label: Text('Ticket'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.list),
                    label: Text('Ticket list'),
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.lock),
                      label: Text('Auth New')),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
