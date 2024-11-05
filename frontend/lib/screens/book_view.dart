import 'package:frontend/constants.dart';
import 'package:flutter/material.dart';

class BookView extends StatelessWidget {
  const BookView({super.key});
  // final PopularBookModel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: kBase1Color,
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              flexibleSpace: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          backgroundColor: kBase2Color,
                          minimumSize: Size(50, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                          ))),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: kBase3Color,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
