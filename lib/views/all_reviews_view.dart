import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/constants/key_constants.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/circular_loader.dart';
import 'package:shoesly_app/helpers/custom_widgets/horizontal_list.dart';
import 'package:shoesly_app/helpers/custom_widgets/review_tile.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_bloc.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_event.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_state.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/brand.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/review.dart';

class AllReviewsView extends StatefulWidget {
  const AllReviewsView({super.key});

  @override
  State<AllReviewsView> createState() => _AllReviewsViewState();
}

class _AllReviewsViewState extends State<AllReviewsView> {
  List<String> starFilterLists = [
    'All',
    '5 Stars',
    '4 Stars',
    '3 Stars',
    '2 Stars',
    '1 Star',
  ];
  late String selectedFilter;
  late ScrollController _scrollController;
  List<Review> reviews = [];
  bool isLoading = false;
  bool isCallComplete = false;
  late int totalReviews;
  late double avgRating;

  @override
  void initState() {
    _scrollController = ScrollController();
    selectedFilter = starFilterLists[0];
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    final state = context.read<FirebaseBloc>().state as FirebaseStateReviews;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !state.isCallComplete) {
      final lastDocumentId =
          state.reviews.isNotEmpty ? state.reviews.last.documentId : null;
      if (selectedFilter == 'All') {
        context.read<FirebaseBloc>().add(FirebaseEventFetchTopReviews(
              lastDocumentId: lastDocumentId,
              selectedBrand: state.selectedBrandAtHome ??
                  Brand(
                    documentId: '',
                    brandName: 'All',
                    logoUrl: '',
                    totalShoes: 0,
                  ),
              shoeId: state.shoeId,
            ));
      } else {
        context.read<FirebaseBloc>().add(FirebaseEventFetchRatingWiseReviews(
              lastDocumentId: lastDocumentId,
              rating: double.parse(selectedFilter[0]),
            ));
      }
    }
  }

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    totalReviews = args[argKeyTotalReview];
    avgRating = args[argKeyAvgRating];
    setState(() {
      final state = context.read<FirebaseBloc>().state as FirebaseStateReviews;
      reviews.addAll(state.reviews);
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<FirebaseBloc>().state as FirebaseStateReviews;
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              appBarHeight * context.mqSize.height,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: appBarLeftPadding * context.mqSize.width,
                right: appBarRightPadding * context.mqSize.width,
              ),
              child: AppBar(
                title: Text('Review ($totalReviews)'),
                centerTitle: true,
                notificationPredicate: (notification) => false,
                actions: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xffFCD240),
                        size: 0.0285 * context.mqSize.height,
                      ),
                      SizedBox(
                        width: 0.0121 * context.mqSize.width,
                      ),
                      Text(
                        '$avgRating',
                        style: TextStyle(
                          fontSize: 0.0216 * context.mqSize.height,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff12121D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 0.0228 * context.mqSize.height,
              ),
              HorizontalScrollableList(
                isLoading: isLoading,
                listItems: starFilterLists,
                onSelect: (item) {
                  if (selectedFilter != item) {
                    setState(() {
                      selectedFilter = item;
                      reviews.clear();
                    });
                    context
                        .read<FirebaseBloc>()
                        .add(const FirebaseEventResetReviews());
                    final lastDocumentId =
                        reviews.isNotEmpty ? reviews.last.documentId : null;
                    if (selectedFilter == 'All') {
                      context
                          .read<FirebaseBloc>()
                          .add(FirebaseEventFetchTopReviews(
                            lastDocumentId: lastDocumentId,
                            selectedBrand: state.selectedBrandAtHome ??
                                Brand(
                                  documentId: '',
                                  brandName: 'All',
                                  logoUrl: '',
                                  totalShoes: 0,
                                ),
                            shoeId: state.shoeId,
                          ));
                    } else {
                      context
                          .read<FirebaseBloc>()
                          .add(FirebaseEventFetchRatingWiseReviews(
                            lastDocumentId: lastDocumentId,
                            rating: double.parse(selectedFilter[0]),
                          ));
                    }
                  }
                },
              ),
              Expanded(
                child: BlocListener<FirebaseBloc, FirebaseState>(
                  listener: (context, state) {
                    final currentState = state as FirebaseStateReviews;
                    setState(() {
                      if (!currentState.isCallComplete) {
                        reviews.addAll(currentState.reviews);
                      }
                      isLoading = currentState.isLoading;
                      isCallComplete = currentState.isCallComplete;
                    });
                  },
                  child: state.isLoading && reviews.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                bodyHorizontalPadding * context.mqSize.width,
                            vertical: 0.0342 * context.mqSize.height,
                          ),
                          shrinkWrap: true,
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            return ReviewTile(review: reviews[index]);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: (isLoading && !isCallComplete) && reviews.isNotEmpty,
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: CircularLoader(),
          ),
        )
      ],
    );
  }
}
