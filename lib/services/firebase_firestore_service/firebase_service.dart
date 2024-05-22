import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoesly_app/constants/key_constants.dart';
import 'dart:developer' as devtools show log;

import 'package:shoesly_app/services/firebase_firestore_service/models/brand.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/review.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe.dart';

class FirebaseService {
  final brands = FirebaseFirestore.instance.collection('brands');
  final colors = FirebaseFirestore.instance.collection('colors');
  final shoes = FirebaseFirestore.instance.collection('shoes');
  final orders = FirebaseFirestore.instance.collection('orders');

  /// Singleton instance
  factory FirebaseService() => _shared;
  static final FirebaseService _shared = FirebaseService._sharedInstance();
  FirebaseService._sharedInstance();

  Future<void> signInAnonymously() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  // For getting all brands list
  Future<List<Brand>> getBrandsList() async {
    try {
      final List<Brand> brandsList = [];
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await brands.get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        brandsList.add(Brand.fromSnapshot(doc));
      }
      return brandsList;
    } catch (e) {
      devtools.log("Error fetching brands: $e");
      rethrow;
    }
  }

  // For getting all colors map
  Future<Map<String, dynamic>> getAllColors() async {
    try {
      final Map<String, dynamic> colorsMap = {};
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await colors.get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        colorsMap.addAll(doc.data());
      }
      return colorsMap;
    } catch (e) {
      devtools.log("Error fetching colors: $e");
      rethrow;
    }
  }

  // For getting all shoe list
  Future<List<Shoe>> getAllShoesList({String? lastDocumentId}) async {
    try {
      final List<Shoe> shoesList = [];
      const int pageSize = 8;

      Query<Map<String, dynamic>> query = shoes.orderBy('name').limit(pageSize);

      if (lastDocumentId != null) {
        DocumentSnapshot lastDocument = await shoes.doc(lastDocumentId).get();
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        shoesList.addAll(
          querySnapshot.docs.map((doc) => Shoe.fromSnapshot(doc)).toList(),
        );
      } else {
        // If no documents found after the provided last document, fetch the initial page.
        querySnapshot = await shoes.orderBy('name').limit(pageSize).get();
        shoesList.addAll(
          querySnapshot.docs.map((doc) => Shoe.fromSnapshot(doc)).toList(),
        );
      }
      return shoesList;
    } catch (e) {
      devtools.log('Error fetching shoes: $e');
      rethrow;
    }
  }

  // For getting brand specific shoe list
  Future<List<Shoe>> getShoesListByBrand({
    String? lastDocumentId,
    required String brandName,
  }) async {
    try {
      final List<Shoe> shoesList = [];
      const int pageSize = 8;

      Query<Map<String, dynamic>> query = shoes
          .where(keyShoeBrandName, isEqualTo: brandName)
          .orderBy('name')
          .limit(pageSize);

      if (lastDocumentId != null) {
        DocumentSnapshot lastDocument = await shoes.doc(lastDocumentId).get();
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        shoesList.addAll(
          querySnapshot.docs.map((doc) => Shoe.fromSnapshot(doc)).toList(),
        );
      } else {
        // If no documents found after the provided last document, fetch the initial page.
        querySnapshot = await shoes
            .where(keyShoeBrandName, isEqualTo: brandName)
            .orderBy('name')
            .limit(pageSize)
            .get();
        shoesList.addAll(
          querySnapshot.docs.map((doc) => Shoe.fromSnapshot(doc)).toList(),
        );
      }
      return shoesList;
    } catch (e) {
      devtools.log('Error fetching specific brands shoes: $e');
      // Handle error gracefully, you may log the error, show a snackbar, or retry the operation.
      rethrow;
    }
  }

  // For getting filtered shoe list
  Future<List<Shoe>> getShoesListByFilters({
    double? startPriceRange,
    double? endPriceRange,
    String? brandName,
    MapEntry<String, dynamic>? color,
    String? sortBy,
    String? gender,
  }) async {
    try {
      final List<Shoe> shoesList = [];

      Query<Map<String, dynamic>> query = shoes;

      if (brandName != null) {
        query = query.where(keyBrandName, isEqualTo: brandName);
      }

      // Apply filters based on provided parameters
      if (sortBy != 'Lowest price' &&
          (startPriceRange != null && endPriceRange != null) &&
          (startPriceRange != 0 || endPriceRange != 1750)) {
        query = query.where(
          keyShoePrice,
          isGreaterThan: startPriceRange,
          isLessThan: endPriceRange,
        );
      }

      if (sortBy != null) {
        switch (sortBy) {
          case 'Most recent':
            query = query.orderBy(keyShoeDateAdded, descending: true);
            break;
          case 'Lowest price':
            query = query.orderBy(keyShoePrice);
            break;
          case 'Highest reviews':
            query = query.orderBy(keyAverageRating, descending: true);
            break;
          default:
            break;
        }
      }

      if (gender != null) {
        query = query.where(keyGender, isEqualTo: gender);
      }

      if (color != null) {
        query = query.where(keyShoeColors, arrayContains: color.key);
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        shoesList.addAll(
          querySnapshot.docs.map((doc) => Shoe.fromSnapshot(doc)).toList(),
        );
      }

      return shoesList;
    } catch (e) {
      devtools.log('Error fetching filtered shoes: $e');
      rethrow;
    }
  }

  // For getting all reviews
  Future<List<Review>> fetchAllReviews({
    required String documentID,
    int pageSize = 10,
    String? lastDocumentID,
  }) async {
    List<Review> reviews = [];
    try {
      CollectionReference<Map<String, dynamic>> reviewsCollection =
          shoes.doc(documentID).collection('reviews');

      Query<Map<String, dynamic>> query = reviewsCollection
          .orderBy(keyRating, descending: true) // Order by the 'rating' field
          .limit(pageSize); // Limit the number of documents to fetch

      if (lastDocumentID != null) {
        DocumentSnapshot<Map<String, dynamic>> lastDocument =
            await reviewsCollection.doc(lastDocumentID).get();
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        reviews =
            querySnapshot.docs.map((doc) => Review.fromSnapshot(doc)).toList();
      }
      return reviews;
    } catch (e) {
      // Handle any errors gracefully
      devtools.log('Error fetching reviews: $e');
      rethrow;
    }
  }

  // For getting all rating specific reviews
  Future<List<Review>> fetchReviewsByRating({
    required String documentID,
    required double rating,
    int pageSize = 10,
    String? lastDocumentID,
  }) async {
    List<Review> reviews = [];
    try {
      CollectionReference<Map<String, dynamic>> reviewsCollection =
          FirebaseFirestore.instance
              .collection('shoes') // Assuming 'shoes' is the parent collection
              .doc(documentID)
              .collection('reviews');

      Query<Map<String, dynamic>> query = reviewsCollection
          .where(keyRating, isEqualTo: rating)
          .orderBy(keyUsername)
          .limit(pageSize); // Limit the number of documents to fetch

      if (lastDocumentID != null) {
        DocumentSnapshot<Map<String, dynamic>> lastDocument =
            await reviewsCollection.doc(lastDocumentID).get();
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
      if (querySnapshot.docs.isNotEmpty) {
        reviews =
            querySnapshot.docs.map((doc) => Review.fromSnapshot(doc)).toList();
      }
      return reviews;
    } catch (e) {
      // Handle any errors gracefully
      devtools.log('Error fetching reviews: $e');
      rethrow;
    }
  }

  // For placing order
  Future<void> placeOrder({required Map<String, dynamic> orderData}) async {
    try {
      await orders.add(orderData);
      devtools.log('Order added successfully');
    } catch (e) {
      devtools.log('Error placing order: $e');
      rethrow;
    }
  }
}
