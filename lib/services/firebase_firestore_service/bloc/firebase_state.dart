import 'package:flutter/foundation.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/brand.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/review.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe_cart.dart';
import 'package:shoesly_app/utility/utility.dart';

@immutable
abstract class FirebaseState {
  final List<ShoeCart> cart;
  final bool isLoading;
  final String loadingText;
  final Exception? exception;
  final List<Brand> brands;
  final Map<String, dynamic> colors;
  final List<Shoe> shoes;
  final Brand? selectedBrandAtHome;
  final FilterClass? filter;

  const FirebaseState({
    required this.shoes,
    required this.cart,
    required this.colors,
    required this.selectedBrandAtHome,
    this.isLoading = false,
    this.loadingText = 'Please wait while data is loading!',
    this.exception,
    required this.brands,
    this.filter,
  });
}

class FirebaseStateDiscover extends FirebaseState {
  const FirebaseStateDiscover({
    required super.cart,
    required super.colors,
    super.isLoading,
    super.loadingText,
    super.exception,
    required super.brands,
    required super.shoes,
    super.selectedBrandAtHome,
    super.filter,
  });
}

class FirebaseStateEmptyState extends FirebaseState {
  final String? successMessage;
  const FirebaseStateEmptyState({
    required super.shoes,
    required super.cart,
    required super.brands,
    required super.colors,
    required super.selectedBrandAtHome,
    this.successMessage,
    super.filter,
    super.isLoading,
    super.exception,
    super.loadingText,
  });
}

class FirebaseStateReviews extends FirebaseState {
  final List<Review> reviews;
  final String shoeId;
  final bool isCallComplete;
  final List<Review> topThreeReviews;

  const FirebaseStateReviews({
    required this.shoeId,
    required super.shoes,
    required super.cart,
    required super.colors,
    super.selectedBrandAtHome,
    super.isLoading,
    super.loadingText,
    super.exception,
    required super.brands,
    super.filter,
    required this.reviews,
    required this.isCallComplete,
    this.topThreeReviews = const [],
  });
}

class FilterClass {
  final Brand? brand;
  final double lowerPrice;
  final double upperPrice;
  final List<Shoe>? filteredShoes;
  final String? sortBy;
  final String? gender;
  final MapEntry<String, dynamic>? color;

  FilterClass({
    required this.brand,
    required this.lowerPrice,
    required this.upperPrice,
    required this.filteredShoes,
    required this.sortBy,
    required this.gender,
    required this.color,
  });

  bool get isNull =>
      countNonNull([brand, sortBy, gender, color]) == 0 &&
      (lowerPrice == 0 && upperPrice == 1750);
}
