import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/star_ratings.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/review.dart';
import 'package:timeago/timeago.dart' as timeago show format;

class ReviewTile extends StatefulWidget {
  final Review review;
  const ReviewTile({
    super.key,
    required this.review,
  });

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  late final String timeAgo;

  @override
  void initState() {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(widget.review.dateCreated * 1000);
    timeAgo = timeago.format(dateTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 0.0342 * context.mqSize.height,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.review.userImgUrl),
            radius: 20,
          ),
          SizedBox(
            width: 0.0608 * context.mqSize.width,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 0.3 * context.mqSize.width,
                      child: Text(
                        widget.review.userName,
                        style: TextStyle(
                          fontSize: 0.0205 * context.mqSize.height,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff070C18),
                        ),
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: const Color(0xffB7B7B7),
                        fontSize: 0.0182 * context.mqSize.height,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 0.0057 * context.mqSize.height,
                    bottom: 0.0114 * context.mqSize.height,
                  ),
                  child: StarRatings(
                      rating: double.parse(widget.review.rating.toString())),
                ),
                Text(
                  widget.review.reviewDescription,
                  style: TextStyle(
                    fontSize: 0.0182 * context.mqSize.height,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
