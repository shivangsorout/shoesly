import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class StarRatings extends StatelessWidget {
  final double rating;
  const StarRatings({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      ignoreGestures: true,
      allowHalfRating: true,
      glowColor: const Color(0xffFCD240),
      unratedColor: const Color(0xffE6E6E6),
      minRating: 1,
      maxRating: 5,
      itemSize: 0.0194 * context.mqSize.height,
      initialRating: rating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: const Color(0xffFCD240),
        size: 0.0194 * context.mqSize.height,
      ),
      onRatingUpdate: (value) {},
    );
  }
}
