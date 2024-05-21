import 'package:bloc/bloc.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_event.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_state.dart';
import 'package:shoesly_app/services/firebase_firestore_service/firebase_service.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/brand.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/review.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe_cart.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc(FirebaseService service)
      : super(
          const FirebaseStateDiscover(
            brands: [],
            cart: [],
            shoes: [],
            colors: {},
          ),
        ) {
    on<FirebaseEventFetchShoes>((event, emit) async {
      List<Brand> brands = state.brands;
      List<Shoe> shoes = List.from(state.shoes);
      Map<String, dynamic> colors = Map.from(state.colors);
      String? lastDocumentId = event.lastDocumentId;
      emit(FirebaseStateDiscover(
        cart: List<ShoeCart>.from(state.cart),
        brands: List<Brand>.from(state.brands),
        shoes: List<Shoe>.from(shoes),
        colors: colors,
        isLoading: true,
      ));
      if (brands.isEmpty) {
        List<Brand> brandsList = [];
        brandsList = await service.getBrandsList();
        brands = List<Brand>.from(brandsList);
      }
      if (colors.isEmpty) {
        Map<String, dynamic> colorsMap = {};
        colorsMap = await service.getAllColors();
        colors.addAll(colorsMap);
      }
      final List<Shoe> shoesList = await service.getAllShoesList(
        lastDocumentId: lastDocumentId,
      );
      shoes.addAll(List<Shoe>.from(shoesList));
      emit(FirebaseStateDiscover(
        cart: List<ShoeCart>.from(state.cart),
        brands: List<Brand>.from(brands),
        shoes: List<Shoe>.from(shoes),
        colors: colors,
        isLoading: false,
      ));
    });

    on<FirebaseEventResetState>((event, emit) {
      emit(FirebaseStateEmptyState(
        selectedBrandAtHome: state.selectedBrandAtHome,
        cart: List<ShoeCart>.from(state.cart),
        brands: List<Brand>.from(state.brands),
        colors: state.colors,
        shoes: List<Shoe>.from([]),
      ));
    });

    on<FirebaseEventFetchBrandShoes>((event, emit) async {
      List<Brand> brands = state.brands;
      List<ShoeCart> cart = List.from(state.cart);
      Map<String, dynamic> colors = state.colors;
      List<Shoe> shoes = List.from(state.shoes);
      String? lastDocumentId = event.lastDocumentId;
      String brandName = event.brandName;
      emit(FirebaseStateDiscover(
        cart: List<ShoeCart>.from(cart),
        brands: List<Brand>.from(brands),
        shoes: List<Shoe>.from(shoes),
        colors: colors,
        isLoading: true,
        selectedBrandAtHome: state.selectedBrandAtHome,
      ));
      if (brands.isEmpty) {
        List<Brand> brandsList = [];
        brandsList = await service.getBrandsList();
        brands = List<Brand>.from(brandsList);
      }
      if (colors.isEmpty) {
        Map<String, dynamic> colorsMap = {};
        colorsMap = await service.getAllColors();
        colors.addAll(colorsMap);
      }
      final List<Shoe> shoesList = await service.getShoesListByBrand(
        brandName: brandName,
        lastDocumentId: lastDocumentId,
      );
      shoes.addAll(List<Shoe>.from(shoesList));
      emit(FirebaseStateDiscover(
        cart: List<ShoeCart>.from(cart),
        brands: List<Brand>.from(brands),
        shoes: List<Shoe>.from(shoes),
        colors: colors,
        isLoading: false,
      ));
    });

    on<FirebaseEventFilterShoes>(
      (event, emit) async {
        FilterClass filter = event.filter;
        final brands = state.brands;
        final colors = state.colors;
        final cart = state.cart;
        List<Shoe> filteredShoe = [];
        emit(FirebaseStateDiscover(
          cart: List<ShoeCart>.from(cart),
          brands: List<Brand>.from(brands),
          shoes: const [],
          colors: colors,
          isLoading: true,
          selectedBrandAtHome: state.selectedBrandAtHome,
          filter: filter,
        ));
        final localShoeList = await service.getShoesListByFilters(
          brandName: filter.brand?.brandName,
          color: filter.color,
          endPriceRange: filter.upperPrice,
          startPriceRange: filter.lowerPrice,
          gender: filter.gender,
          sortBy: filter.sortBy,
        );
        filteredShoe.addAll(localShoeList);
        filter.filteredShoes?.addAll(filteredShoe);
        emit(FirebaseStateDiscover(
          cart: cart,
          colors: colors,
          brands: brands,
          shoes: const [],
          isLoading: false,
          filter: filter,
        ));
      },
    );

    on<FirebaseEventFetchTopReviews>(
      (event, emit) async {
        final lastDocumentId = event.lastDocumentId;
        final selectedBrand = event.selectedBrand;
        final shoeId = event.shoeId;
        final shoes = List<Shoe>.from(state.shoes);
        final brands = state.brands;
        final cart = state.cart;
        final colors = state.colors;
        final filter = state.filter;
        List<Review> reviews = [];
        bool isCallComplete = false;
        final topThreeReviews = <Review>[];
        if (state is FirebaseStateReviews) {
          final currentState = state as FirebaseStateReviews;
          isCallComplete = currentState.isCallComplete;
          if (currentState.topThreeReviews.isEmpty &&
              currentState.reviews.isNotEmpty) {
            for (int i = 0; i < 3; i++) {
              topThreeReviews.add(currentState.reviews[i]);
            }
          } else if (currentState.topThreeReviews.isNotEmpty) {
            topThreeReviews.addAll(List.from(currentState.topThreeReviews));
          }
        }
        emit(FirebaseStateReviews(
            topThreeReviews: topThreeReviews,
            shoeId: shoeId,
            shoes: shoes,
            cart: cart,
            colors: colors,
            brands: brands,
            filter: filter,
            selectedBrandAtHome: selectedBrand,
            reviews: const [],
            isLoading: true,
            isCallComplete: isCallComplete));
        if (!isCallComplete) {
          final List<Review> localReviews = await service.fetchAllReviews(
            documentID: shoeId,
            lastDocumentID: lastDocumentId,
            pageSize: 10,
          );
          if (localReviews.isNotEmpty) {
            if (topThreeReviews.isEmpty) {
              for (int i = 0; i < 3; i++) {
                topThreeReviews.add(localReviews[i]);
              }
            }
            reviews.addAll(localReviews);
          } else {
            isCallComplete = true;
          }
        }
        emit(FirebaseStateReviews(
          topThreeReviews: topThreeReviews,
          shoeId: shoeId,
          shoes: shoes,
          cart: cart,
          colors: colors,
          brands: brands,
          filter: filter,
          selectedBrandAtHome: selectedBrand,
          reviews: reviews,
          isCallComplete: isCallComplete,
          isLoading: false,
        ));
      },
    );

    on<FirebaseEventResetReviews>(
      (event, emit) {
        final currentState = state as FirebaseStateReviews;
        emit(FirebaseStateReviews(
          shoeId: currentState.shoeId,
          shoes: state.shoes,
          cart: state.cart,
          colors: state.colors,
          brands: state.brands,
          reviews: const [],
          isCallComplete: false,
          isLoading: false,
          filter: state.filter,
          selectedBrandAtHome: state.selectedBrandAtHome,
          topThreeReviews: currentState.topThreeReviews,
        ));
      },
    );

    on<FirebaseEventFetchRatingWiseReviews>(
      (event, emit) async {
        final rating = event.rating;
        final lastDocumentId = event.lastDocumentId;
        late final Brand selectedBrand;
        late final String shoeId;
        final shoes = List<Shoe>.from(state.shoes);
        final brands = state.brands;
        final cart = state.cart;
        final colors = state.colors;
        final filter = state.filter;
        List<Review> reviews = [];
        bool isCallComplete = false;
        final topThreeReviews = <Review>[];
        if (state is FirebaseStateReviews) {
          final currentState = state as FirebaseStateReviews;
          selectedBrand = currentState.selectedBrandAtHome!;
          shoeId = currentState.shoeId;
          isCallComplete = currentState.isCallComplete;
          if (currentState.topThreeReviews.isNotEmpty) {
            topThreeReviews.addAll(List.from(currentState.topThreeReviews));
          }
        }
        emit(FirebaseStateReviews(
            topThreeReviews: topThreeReviews,
            shoeId: shoeId,
            shoes: shoes,
            cart: cart,
            colors: colors,
            brands: brands,
            filter: filter,
            selectedBrandAtHome: selectedBrand,
            reviews: const [],
            isLoading: true,
            isCallComplete: isCallComplete));
        if (!isCallComplete) {
          final List<Review> localReviews = await service.fetchReviewsByRating(
            rating: rating,
            documentID: shoeId,
            lastDocumentID: lastDocumentId,
            pageSize: 10,
          );
          if (localReviews.isNotEmpty) {
            reviews.addAll(localReviews);
          } else {
            isCallComplete = true;
          }
        }
        emit(FirebaseStateReviews(
          topThreeReviews: topThreeReviews,
          shoeId: shoeId,
          shoes: shoes,
          cart: cart,
          colors: colors,
          brands: brands,
          filter: filter,
          selectedBrandAtHome: selectedBrand,
          reviews: reviews,
          isCallComplete: isCallComplete,
          isLoading: false,
        ));
      },
    );

    on<FirebaseEventAddToCart>(
      (event, emit) {
        final quantity = event.quantity;
        final shoe = event.shoe;
        final colorSelected = event.colorSelected;
        final sizeSelected = event.sizeSelected;
        final currentState = state as FirebaseStateReviews;
        List<ShoeCart> cart = List.from(state.cart);
        emit(FirebaseStateReviews(
          shoeId: currentState.shoeId,
          shoes: state.shoes,
          cart: cart,
          colors: state.colors,
          brands: state.brands,
          reviews: const [],
          isCallComplete: false,
          filter: state.filter,
          selectedBrandAtHome: state.selectedBrandAtHome,
          topThreeReviews: currentState.topThreeReviews,
          isLoading: true,
        ));
        final cartItem = ShoeCart(
          documentId: shoe.documentId,
          shoeName: shoe.name,
          brandName: shoe.brandName,
          imgUrl: shoe.imageUrlList[0],
          colorSelected: colorSelected,
          selectedSize: sizeSelected,
          quantity: quantity,
          price: shoe.price,
        );
        if (cart.isNotEmpty && cart.contains(cartItem)) {
          int index = cart.indexOf(cartItem);
          cart[index] = cartItem;
        } else {
          cart.add(cartItem);
        }
        emit(FirebaseStateReviews(
          shoeId: currentState.shoeId,
          shoes: state.shoes,
          cart: cart,
          colors: state.colors,
          brands: state.brands,
          reviews: const [],
          isCallComplete: false,
          filter: state.filter,
          selectedBrandAtHome: state.selectedBrandAtHome,
          topThreeReviews: currentState.topThreeReviews,
          isLoading: false,
        ));
      },
    );

    on<FirebaseEventDeleteFromCart>(
      (event, emit) {
        final cartItem = event.cartItem;
        FirebaseStateReviews? currentState;
        if (state is FirebaseStateReviews) {
          currentState = state as FirebaseStateReviews;
        }
        List<ShoeCart> cart = List.from(state.cart);
        emit(FirebaseStateReviews(
          shoeId: cartItem.documentId,
          shoes: state.shoes,
          cart: cart,
          colors: state.colors,
          brands: state.brands,
          reviews: const [],
          isCallComplete: false,
          filter: state.filter,
          selectedBrandAtHome: state.selectedBrandAtHome,
          topThreeReviews: currentState?.topThreeReviews ?? [],
          isLoading: true,
        ));
        if (cart.isEmpty || !cart.contains(cartItem)) {
          throw Exception("Shoe doesn't exist in the cart");
        } else {
          cart.removeWhere(
            (element) => element.documentId == cartItem.documentId,
          );
        }
        emit(FirebaseStateReviews(
          shoeId: cartItem.documentId,
          shoes: state.shoes,
          cart: cart,
          colors: state.colors,
          brands: state.brands,
          reviews: const [],
          isCallComplete: false,
          filter: state.filter,
          selectedBrandAtHome: state.selectedBrandAtHome,
          topThreeReviews: currentState?.topThreeReviews ?? [],
          isLoading: false,
        ));
      },
    );

    on<FirebaseEventPlaceOrder>((event, emit) async {
      final String paymentMethod = event.paymentMethod;
      final String location = event.location;
      final List<ShoeCart> cartShoes = event.cartShoes;
      final double subTotal = event.subTotal;
      final double shippingFee = event.shippingFee;
      final double grandTotal = event.grandTotal;

      emit(FirebaseStateEmptyState(
        selectedBrandAtHome: state.selectedBrandAtHome,
        cart: List<ShoeCart>.from([]),
        brands: List<Brand>.from(state.brands),
        colors: state.colors,
        shoes: List<Shoe>.from([]),
        isLoading: true,
      ));

      await service.placeOrder(
        orderData: {
          'paymentMethod': paymentMethod,
          'location': location,
          'shoes': cartShoes.map((shoe) => shoe.toJson()).toList(),
          'subTotal': subTotal,
          'shippingFee': shippingFee,
          'grandTotal': grandTotal,
        },
      );

      emit(
        FirebaseStateEmptyState(
            selectedBrandAtHome: state.selectedBrandAtHome,
            cart: List<ShoeCart>.from([]),
            brands: List<Brand>.from(state.brands),
            colors: state.colors,
            shoes: List<Shoe>.from([]),
            isLoading: false,
            successMessage: 'The order has been placed successfully'),
      );
    });
  }
}
