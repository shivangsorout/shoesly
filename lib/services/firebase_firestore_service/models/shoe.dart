import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoesly_app/constants/key_constants.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/review.dart';

class Shoe {
  final String documentId;
  final String name;
  final List<String> imageUrlList;
  final List<int> sizeList;
  final Map<String, dynamic> colorsMap;
  final List<String> colors;
  final String description;
  final List<Review> reviewList;
  final String brandName;
  final double price;
  final int totalReviews;
  final double avgRating;
  final int dateAdded;
  final String gender;

  Shoe({
    required this.colors,
    required this.documentId,
    required this.name,
    required this.imageUrlList,
    required this.sizeList,
    required this.colorsMap,
    required this.description,
    required this.reviewList,
    required this.brandName,
    required this.price,
    required this.totalReviews,
    required this.avgRating,
    required this.dateAdded,
    required this.gender,
  });

  Shoe.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        name = snapshot.data()[keyShoeName] as String,
        imageUrlList = List<String>.from(snapshot.data()[keyShoeImgURLs]),
        sizeList = List<int>.from(snapshot.data()[keySizesList]),
        colorsMap = snapshot.data()[keyColorsMap] as Map<String, dynamic>,
        colors = List<String>.from(snapshot.data()[keyShoeColors]),
        description = snapshot.data()[keyShoeDescription] as String,
        reviewList = [],
        brandName = snapshot.data()[keyShoeBrandName] as String,
        price = snapshot.data()[keyShoePrice] as double,
        totalReviews = snapshot.data()[keyTotalReviews] as int,
        avgRating = double.parse(
            ((snapshot.data()[keyAverageRating]) as double).toStringAsFixed(1)),
        dateAdded = snapshot.data()[keyShoeDateAdded] as int,
        gender = snapshot.data()[keyGender] as String;

  toJson() => {
        keyDocumentId: documentId,
        keyShoeName: name,
        keyShoeImgURLs: imageUrlList,
        keySizesList: sizeList,
        keyColorsMap: colorsMap,
        keyShoeColors: colors,
        keyShoeDescription: description,
        keyReviewsList: reviewList,
        keyShoeBrandName: brandName,
        keyShoePrice: price,
        keyTotalReviews: totalReviews,
        keyAverageRating: avgRating,
        keyShoeDateAdded: dateAdded,
        keyGender: gender,
      };
}
