import 'package:flutter/foundation.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_state.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/brand.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe_cart.dart';

@immutable
abstract class FirebaseEvent {
  const FirebaseEvent();
}

class FirebaseEventFetchShoes extends FirebaseEvent {
  final String? lastDocumentId;
  const FirebaseEventFetchShoes({
    this.lastDocumentId,
  });
}

class FirebaseEventFetchBrandShoes extends FirebaseEvent {
  final String brandName;
  final String? lastDocumentId;
  const FirebaseEventFetchBrandShoes({
    this.lastDocumentId,
    required this.brandName,
  });
}

class FirebaseEventResetState extends FirebaseEvent {
  const FirebaseEventResetState();
}

class FirebaseEventFilterShoes extends FirebaseEvent {
  final FilterClass filter;
  const FirebaseEventFilterShoes({
    required this.filter,
  });
}

class FirebaseEventFetchTopReviews extends FirebaseEvent {
  final Brand selectedBrand;
  final String shoeId;
  final String? lastDocumentId;

  const FirebaseEventFetchTopReviews({
    required this.selectedBrand,
    required this.shoeId,
    required this.lastDocumentId,
  });
}

class FirebaseEventResetReviews extends FirebaseEvent {
  const FirebaseEventResetReviews();
}

class FirebaseEventFetchRatingWiseReviews extends FirebaseEvent {
  final String? lastDocumentId;
  final double rating;

  const FirebaseEventFetchRatingWiseReviews({
    required this.lastDocumentId,
    required this.rating,
  });
}

class FirebaseEventAddToCart extends FirebaseEvent {
  final Shoe shoe;
  final int quantity;
  final int sizeSelected;
  final MapEntry<String, dynamic> colorSelected;
  const FirebaseEventAddToCart({
    required this.sizeSelected,
    required this.colorSelected,
    required this.shoe,
    required this.quantity,
  });
}

class FirebaseEventDeleteFromCart extends FirebaseEvent {
  final ShoeCart cartItem;

  const FirebaseEventDeleteFromCart({required this.cartItem});
}

class FirebaseEventPlaceOrder extends FirebaseEvent {
  final String paymentMethod;
  final String location;
  final List<ShoeCart> cartShoes;
  final double subTotal;
  final double shippingFee;
  final double grandTotal;

  const FirebaseEventPlaceOrder({
    required this.paymentMethod,
    required this.location,
    required this.cartShoes,
    required this.subTotal,
    required this.shippingFee,
    required this.grandTotal,
  });
}
