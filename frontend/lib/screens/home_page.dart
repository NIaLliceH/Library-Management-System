import 'package:frontend/models/book.dart';
import 'package:frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'category_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 25),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            // Greeting user
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, Alice',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey),
                ),
                Text(
                  'Welcome back!',
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
                        color: kBase1Color,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(width: 1, color: Color(0x77365486))),
                    child: TextField(
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0x99365486),
                          ),
                          child: SvgPicture.asset('assets/svg/search.svg',
                              width: 25))),
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
                        labelColor: kBase3Color,
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
                          BookListView(bookList: newBooks),
                          BookListView(bookList: topRatedBooks),
                          BookListView(bookList: mostBorrowedBooks),
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
            ListView.builder(
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
                      backgroundColor: kBase2Color,
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
                            color: kBase3Color,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: kBase1Color,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

// Book list view (new, top rated, most borrowed)
class BookListView extends StatelessWidget {
  final List<Book> bookList;

  const BookListView({super.key, required this.bookList});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      height: 230,
      child: ListView.builder(
        itemCount: bookList.length,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
              width: 160,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(bookList[index].imageUrl)),
              ));
        },
      ),
    );
  }
}