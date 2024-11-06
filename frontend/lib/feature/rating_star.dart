import 'package:flutter/material.dart';

//Rating stars
typedef RatingChangeCallback = void Function(double rating);

class RatingBar extends StatelessWidget {
  final int numberOfstart;
  final double rating;
  final RatingChangeCallback? ratingFunc;
  final color = Colors.orangeAccent;
  final double width;
  final bool canChanged;
  const RatingBar({
    super.key,
    this.numberOfstart = 5,
    this.rating = .0,
    this.ratingFunc,
    required this.width,
    this.canChanged = false,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: color,
        size: width / 5,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
        size: width / 5,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
        size: width / 5,
      );
    }
    return canChanged
        ? GestureDetector(
            onTap: () => ratingFunc!(index + 1),
            child: icon,
          )
        : icon;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children:
            List.generate(numberOfstart, (index) => buildStar(context, index)),
      ),
    );
  }
}
