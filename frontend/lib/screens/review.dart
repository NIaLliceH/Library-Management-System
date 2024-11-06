import 'package:flutter/material.dart';
import 'package:frontend/book.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/feature/rating_star.dart';

//Rated screen
class RatedScreen extends StatelessWidget {
  const RatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: kBase2Color,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReviewScreen()));
            },
            icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text(
          'Review',
          style: TextStyle(
            fontSize: bigFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Icon(
              size: 70,
              Icons.check_circle_rounded,
              color: kBase3Color,
            ),
            SizedBox(height: 30),
            Text(
              "Thanks for your review!",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}

//Screen
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<StatefulWidget> createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  double dataRating = 0;
  int numberOfRating = 12;
  @override
  Widget build(BuildContext context) {
    final double screenSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: kBase2Color,
        leading: IconButton(
            onPressed: () => {print("Hello")}, icon: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text(
          'Review',
          style: TextStyle(
            fontSize: bigFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        width: screenSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Img
            Container(
              height: 250,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              clipBehavior: Clip.hardEdge,
              child: ClipRRect(
                child: Image.asset(
                  newBooks[0].image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${newBooks[0].title} #${newBooks[0].id}',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    newBooks[0].author,
                    style: TextStyle(fontSize: bigFontSize),
                  ),
                  SizedBox(height: 10),
                  RatingBar(
                    width: 150,
                    rating: dataRating,
                    canChanged: true,
                    ratingFunc: (rating) {
                      setState(() {
                        dataRating = rating;
                      });
                      // print(dataRating);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RatedScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Rate this book',
                    style: TextStyle(
                      color: kBase6Color,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
