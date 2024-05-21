import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly_app/constants/key_constants.dart';

class Review {
  final String documentId;
  final String userImgUrl;
  final String userName;
  final String reviewDescription;
  final int rating;
  final int dateCreated;

  Review({
    required this.documentId,
    required this.userImgUrl,
    required this.userName,
    required this.reviewDescription,
    required this.rating,
    required this.dateCreated,
  });
  Review.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        userImgUrl = snapshot.data()[keyUserImageURL] as String,
        userName = snapshot.data()[keyUsername] as String,
        reviewDescription = snapshot.data()[keyReviewDescription] as String,
        rating = snapshot.data()[keyRating] as int,
        dateCreated = snapshot.data()[keyDateCreated] as int;

  toJson() => {
        keyDocumentId: documentId,
        keyUserImageURL: userImgUrl,
        keyUsername: userName,
        keyReviewDescription: reviewDescription,
        keyRating: rating,
        keyDateCreated: dateCreated,
      };
}
