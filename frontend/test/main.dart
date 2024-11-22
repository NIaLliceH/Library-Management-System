import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import 'ticket.dart';
import 'ticketList.dart';
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
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = AuthPage();
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

//  void sendRequest() async {
//     final url = Uri.parse('http://your-node-api-url.com/endpoint'); 
//     try {
//       final response = await http.get(url);
      
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         print('Response: $responseData');
//       } else {
//         print('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }