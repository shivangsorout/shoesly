import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/constants/key_constants.dart';
import 'package:shoesly_app/constants/routes.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/black_button.dart';
import 'package:shoesly_app/helpers/custom_widgets/bottom_bar.dart';
import 'package:shoesly_app/helpers/custom_widgets/grey_outlined_button.dart';
import 'package:shoesly_app/helpers/custom_widgets/image_slider.dart';
import 'package:shoesly_app/helpers/custom_widgets/label_amount_widget.dart';
import 'package:shoesly_app/helpers/custom_widgets/review_tile.dart';
import 'dart:developer' as devtools show log;

import 'package:shoesly_app/helpers/custom_widgets/shoe_size_list.dart';
import 'package:shoesly_app/helpers/custom_widgets/star_ratings.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_bloc.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_event.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_state.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/brand.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/review.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe.dart';
import 'package:shoesly_app/views/product_detail/bottom_sheet/bottom_sheet.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  Shoe? shoe;
  int? selectedSize;
  String? selectedColor;

  @override
  void didChangeDependencies() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    shoe = args[argKeyShoeModel];
    selectedColor = shoe!.colors[0];
    selectedSize = shoe!.sizeList[0];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<FirebaseBloc>().state;
    return Scaffold(
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
            notificationPredicate: (notification) => false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(cartRoute);
                },
                icon: SvgPicture.asset(
                  'assets/logos/${state.cart.isNotEmpty ? 'cart_with_dot' : 'cart_logo'}.svg',
                  height: 0.03 * context.mqSize.height,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: bodyHorizontalPadding * context.mqSize.width,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Slider
                  SizedBox(
                    height: 0.4018 * context.mqSize.height,
                    child: ImageSlider(
                      colorsList: shoe!.colors,
                      imgList: shoe!.imageUrlList,
                      onSelect: (color) {
                        devtools.log(color);
                        setState(() {
                          selectedColor = color;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 0.0342 * context.mqSize.height,
                  ),
                  Text(
                    shoe!.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 0.0308 * context.mqSize.height,
                    ),
                  ),
                  SizedBox(
                    height: 0.0114 * context.mqSize.height,
                  ),
                  Row(
                    children: [
                      StarRatings(
                        rating: shoe!.avgRating,
                      ),
                      SizedBox(
                        width: 0.0121 * context.mqSize.width,
                      ),
                      Text(
                        shoe!.avgRating.toString(),
                        style: TextStyle(
                          fontSize: 0.0182 * context.mqSize.height,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff12121D),
                        ),
                      ),
                      SizedBox(
                        width: 0.0121 * context.mqSize.width,
                      ),
                      Text(
                        '(${shoe!.totalReviews} Reviews)',
                        style: TextStyle(
                          fontSize: 0.0182 * context.mqSize.height,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffB7B7B7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.0342 * context.mqSize.height,
                  ),
                  const Text('Size'),
                  ShoeSizeList(
                    shoeSizeList: shoe!.sizeList,
                    onSelect: (size) {
                      devtools.log(size.toString());
                      setState(() {
                        selectedSize = size;
                      });
                    },
                  ),
                  SizedBox(
                    height: 0.0342 * context.mqSize.height,
                  ),
                  const Text('Description'),
                  SizedBox(
                    height: 0.0114 * context.mqSize.height,
                  ),
                  Text(
                    shoe!.description,
                    style: TextStyle(
                      color: const Color(0xff6F6F6F),
                      fontSize: 0.0205 * context.mqSize.height,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 0.0342 * context.mqSize.height,
                  ),
                  Text('Reviews (${shoe!.totalReviews})'),
                  SizedBox(
                    height: 0.0171 * context.mqSize.height,
                  ),
                  BlocBuilder<FirebaseBloc, FirebaseState>(
                    builder: (context, state) {
                      return Visibility(
                        visible: !state.isLoading,
                        replacement: Padding(
                          padding: EdgeInsets.only(
                            top: 0.0228 * context.mqSize.height,
                            bottom: 0.0456 * context.mqSize.height,
                          ),
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state is FirebaseStateReviews ? 3 : 0,
                          itemBuilder: (context, index) => ReviewTile(
                            review: state is FirebaseStateReviews
                                ? state.topThreeReviews[index]
                                : Review(
                                    documentId: '',
                                    userImgUrl: '',
                                    userName: '',
                                    reviewDescription: '',
                                    rating: 0,
                                    dateCreated: 0,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: GreyOutlinedButton(
                          buttonText: 'SEE ALL REVIEW',
                          onPressed: () {
                            context
                                .read<FirebaseBloc>()
                                .add(const FirebaseEventResetReviews());

                            final state = context.read<FirebaseBloc>().state
                                as FirebaseStateReviews;

                            context
                                .read<FirebaseBloc>()
                                .add(FirebaseEventFetchTopReviews(
                                  lastDocumentId: null,
                                  selectedBrand: state.selectedBrandAtHome ??
                                      Brand(
                                        documentId: '',
                                        brandName: 'All',
                                        logoUrl: '',
                                        totalShoes: 0,
                                      ),
                                  shoeId: state.shoeId,
                                ));
                            Navigator.of(context)
                                .pushNamed(allReviewsRoute, arguments: {
                              argKeyAvgRating: shoe!.avgRating,
                              argKeyTotalReview: shoe!.totalReviews,
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.146 * context.mqSize.height,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomBar(
              children: [
                LabelAmountWidget(
                  labelText: 'Price',
                  amount: '${shoe!.price}',
                ),
                BlackButton(
                  buttonText: 'ADD TO CART',
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return BottomSheetView(
                          shoe: shoe!,
                          selectedColor: selectedColor!,
                          selectedSize: selectedSize!,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
