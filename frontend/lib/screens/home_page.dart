import 'package:frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/search_result.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/api_service.dart';
import 'package:frontend/auth_service.dart';
import 'book_view.dart';
import 'category_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(left: 25, right: 25, top: 40),
        physics: BouncingScrollPhysics(),
        children: [
          // Greeting user
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${thisUser!.name}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey),
              ),
              Text(
                'Explore the world of books',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ],
          ),
          // Search bar
          Container(
            height: 40,
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 80),
                  decoration: BoxDecoration(
                      color: kBase1,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(width: 1, color: Color(0x77365486))),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _userInput = value;
                      });
                    },
                    onSubmitted: (value) {
                      final query = value.trim();
                      if (query.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResult(query: query),
                          ),
                        );
                      }
                    },
                    style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, bottom: 10),
                        border: InputBorder.none,
                        hintText: 'Search book..',
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: () {
                          final query = _userInput.trim();
                          if (query.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResult(query: query),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0x99365486),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        )
                    )
                ),
              ],
            ),
          ),
          // Tab bar
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 300,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                      labelPadding: EdgeInsets.only(right: 30),
                      indicatorPadding: EdgeInsets.only(right: 20),
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      labelColor: kBase3,
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      unselectedLabelColor: Colors.grey,
                      unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      tabs: [
                        Tab(
                          child: Text('New'),
                        ),
                        Tab(
                          child: Text('Top Rated'),
                        ),
                        Tab(
                          child: Text('Most Borrowed'),
                        )
                      ]),
                  Expanded(
                    child: TabBarView(
                      children: [
                        BookListView(filter: BookFilter.newRelease),
                        BookListView(filter: BookFilter.topRated),
                        BookListView(filter: BookFilter.mostBorrowed),
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
          // Category list
          Text(
            'Category',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          FutureBuilder(
            future: ApiService.getAllCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text('No data available'),
                );
              } else {
                var categories = snapshot.data!;
                categories.add('All'); // display all books
                return ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  // scrollDirection: Axis.vertical,
                  shrinkWrap: true, // because no wrapping Container to set height
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryResult(
                                category: categories[index],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          alignment: Alignment.centerLeft,
                          backgroundColor: kBase2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              categories[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: kBase3,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: kBase1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}

// Book list view (new, top rated, most borrowed)
class BookListView extends StatelessWidget {
  final BookFilter filter;
  const BookListView({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      height: 230,
      child: FutureBuilder(
        future: ApiService.getBooksFiltered(filter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            final books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookView(bookId: books[index].id),
                      ),
                    );
                  },
                  child: Container(
                      width: 160,
                      margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(books[index].imageUrl)),
                      )),
                );
              },
            );
          }
        },
      )
    );
  }
}