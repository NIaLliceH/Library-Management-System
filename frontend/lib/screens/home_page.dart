import 'package:frontend/book.dart';
import 'package:frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
        padding: EdgeInsets.all(25),
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
                  'Discover Latest Books',
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
              // color: Colors.green,
              margin: EdgeInsets.only(top: 30),
              height: 30,
              child: DefaultTabController(
                length: 3,
                child: TabBar(
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
                        child: Text('Trending'),
                      ),
                      Tab(
                        child: Text('Best Seller'),
                      )
                    ]),
              ),
            ),
            // Tab list view
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              // color: Colors.green,
              height: 230,
              child: ListView.builder(
                itemCount: newBooks.length,
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
                            image: AssetImage(newBooks[index].image)),
                      ));
                },
              ),
            ),
            // Popular view
            Text(
              'Popular',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.only(top: 20),
              physics: BouncingScrollPhysics(),
              // scrollDirection: Axis.vertical,
              shrinkWrap: true, // because no wrapping Container to set height
              itemCount: popularBooks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print('ListView tapped');
                  },
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        // book cover
                        Expanded(
                          flex: 1,
                          child: Container(
                              margin: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          popularBooks[index].image)
                                  )
                              )
                          ),
                        ),
                        // book info
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                popularBooks[index].title,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: kBase4Color
                                ),
                              ),
                              Text(popularBooks[index].author,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300)
                              ),
                              Text(
                                '\$${popularBooks[index].price}',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: kBase3Color,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        )
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
