import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/constants/routes.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/black_button.dart';
import 'package:shoesly_app/helpers/custom_widgets/bottom_bar.dart';
import 'package:shoesly_app/helpers/custom_widgets/brands_filter_list.dart';
import 'package:shoesly_app/helpers/custom_widgets/filter_colors_scroll_veiw.dart';
import 'package:shoesly_app/helpers/custom_widgets/filter_tags_scroll_view.dart';
import 'package:shoesly_app/helpers/custom_widgets/grey_outlined_button.dart';
import 'dart:developer' as devtools show log;

import 'package:shoesly_app/helpers/custom_widgets/price_range_slider.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_bloc.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_event.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_state.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/brand.dart';
import 'package:shoesly_app/utility/utility.dart';

class ProductFilterView extends StatefulWidget {
  const ProductFilterView({super.key});

  @override
  State<ProductFilterView> createState() => _ProductFilterViewState();
}

class _ProductFilterViewState extends State<ProductFilterView> {
  List<String> sortTagsList = [
    'Most recent',
    'Lowest price',
    'Highest reviews'
  ];
  List<String> genderTagsList = [
    'Man',
    'Woman',
    'Unisex',
  ];
  Brand? selectedBrand;
  String? selectedSortTag;
  String? selectedGenderTag;
  MapEntry<String, dynamic>? selectedColor;
  double _upperValue = 1750;
  double _lowerValue = 0;

  @override
  void didChangeDependencies() {
    final mainState = context.read<FirebaseBloc>().state;
    final state = mainState;
    bool isFilterNull = state.filter != null ? state.filter!.isNull : true;
    if (!isFilterNull) {
      final filter = state.filter!;
      selectedBrand = filter.brand;
      selectedSortTag = filter.sortBy;
      selectedGenderTag = filter.gender;
      selectedColor = filter.color;
      _upperValue = filter.upperPrice;
      _lowerValue = filter.lowerPrice;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int filterCount = countNonNull([
      selectedBrand,
      selectedColor,
      selectedGenderTag,
      selectedSortTag,
    ]);
    return BlocBuilder<FirebaseBloc, FirebaseState>(
      builder: (context, state) {
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
                title: const Text('Filter'),
                centerTitle: true,
              ),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 0.0114 * context.mqSize.height,
                    ),
                    const FilterHeadingText(text: 'Brands'),
                    SizedBox(
                      height: 0.0228 * context.mqSize.height,
                    ),
                    BrandsFilterList(
                      brandsList: state.brands,
                      selectedBrand: selectedBrand,
                      onSelect: (brand) {
                        setState(() {
                          selectedBrand = brand;
                        });
                        devtools.log(selectedBrand.toString());
                      },
                    ),
                    SizedBox(
                      height: 0.0228 * context.mqSize.height,
                    ),
                    const FilterHeadingText(text: 'Price Range'),
                    SizedBox(height: 0.0228 * context.mqSize.height),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.03 * context.mqSize.width,
                      ),
                      child: PriceRangeSlider(
                        onRangeSelect: (lowerValue, upperValue) {
                          devtools.log(
                              'LowerValue: \$$lowerValue, UpperValue: \$$upperValue');
                          setState(() {
                            _upperValue = upperValue;
                            _lowerValue = lowerValue;
                          });
                        },
                        lowerValue: _lowerValue.round(),
                        upperValue: _upperValue.round(),
                      ),
                    ),
                    SizedBox(
                      height: 0.0342 * context.mqSize.height,
                    ),
                    const FilterHeadingText(text: 'Sort By'),
                    SizedBox(
                      height: 0.0228 * context.mqSize.height,
                    ),
                    FilterTagsScrollView(
                      tagsList: sortTagsList,
                      onSelect: (tag) {
                        setState(() {
                          selectedSortTag = tag;
                        });
                        devtools.log(selectedSortTag!);
                      },
                      selectedtag: selectedSortTag,
                    ),
                    SizedBox(
                      height: 0.0342 * context.mqSize.height,
                    ),
                    const FilterHeadingText(text: 'Gender'),
                    SizedBox(
                      height: 0.0228 * context.mqSize.height,
                    ),
                    FilterTagsScrollView(
                      tagsList: genderTagsList,
                      onSelect: (tag) {
                        setState(() {
                          selectedGenderTag = tag;
                        });
                        devtools.log(selectedGenderTag!);
                      },
                      selectedtag: selectedGenderTag,
                    ),
                    SizedBox(
                      height: 0.0342 * context.mqSize.height,
                    ),
                    const FilterHeadingText(text: 'Color'),
                    SizedBox(
                      height: 0.0228 * context.mqSize.height,
                    ),
                    FilterColorsScrollView(
                      colorsList: state.colors.entries.toList(),
                      selectedColor: selectedColor,
                      onSelect: (color) {
                        setState(() {
                          selectedColor = color;
                        });
                        devtools.log(color.toString());
                      },
                    ),
                    SizedBox(
                      height: 0.146 * context.mqSize.height,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomBar(
                  children: [
                    Expanded(
                      child: GreyOutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedBrand = null;
                            selectedColor = null;
                            selectedGenderTag = null;
                            selectedSortTag = null;
                            _lowerValue = 0;
                            _upperValue = 1750;
                          });
                          context
                              .read<FirebaseBloc>()
                              .add(const FirebaseEventResetState());
                          context
                              .read<FirebaseBloc>()
                              .add(const FirebaseEventFetchShoes());
                        },
                        buttonText:
                            'RESET${filterCount == 0 ? '' : ' ($filterCount)'}',
                      ),
                    ),
                    SizedBox(width: 0.0364 * context.mqSize.width),
                    Expanded(
                      child: BlackButton(
                        buttonText: 'APPLY',
                        onPressed: () {
                          context
                              .read<FirebaseBloc>()
                              .add(const FirebaseEventResetState());
                          if (_lowerValue != 0 || _upperValue != 1750) {
                            context
                                .read<FirebaseBloc>()
                                .add(FirebaseEventFilterShoes(
                                  filter: FilterClass(
                                    brand: selectedBrand,
                                    color: selectedColor,
                                    filteredShoes: [],
                                    gender: selectedGenderTag,
                                    sortBy: selectedSortTag,
                                    lowerPrice: _lowerValue,
                                    upperPrice: _upperValue,
                                  ),
                                ));
                          } else {
                            context
                                .read<FirebaseBloc>()
                                .add(const FirebaseEventFetchShoes());
                          }
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            homeRoute,
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FilterHeadingText extends StatelessWidget {
  final String text;
  const FilterHeadingText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: bodyHorizontalPadding * context.mqSize.width,
      ),
      child: Text(text),
    );
  }
}
