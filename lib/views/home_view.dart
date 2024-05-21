import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/constants/key_constants.dart';
import 'package:shoesly_app/constants/routes.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/circular_loader.dart';
import 'package:shoesly_app/helpers/custom_widgets/horizontal_list.dart';
import 'package:shoesly_app/helpers/custom_widgets/shoe_tile.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_bloc.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_event.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_state.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/brand.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ScrollController _scrollController;
  Brand? selectedBrand;
  final allBrand =
      Brand(documentId: '', brandName: 'All', logoUrl: '', totalShoes: 0);

  @override
  void initState() {
    selectedBrand = allBrand;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final state = context.read<FirebaseBloc>().state;
    bool isFilterNull = state.filter != null ? state.filter!.isNull : true;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        isFilterNull) {
      final lastDocumentId = state.shoes.last.documentId;

      if (selectedBrand == null || selectedBrand!.brandName == 'All') {
        context.read<FirebaseBloc>().add(FirebaseEventFetchShoes(
              lastDocumentId: lastDocumentId,
            ));
      } else if (isFilterNull) {
        context.read<FirebaseBloc>().add(FirebaseEventFetchBrandShoes(
              lastDocumentId: lastDocumentId,
              brandName: selectedBrand!.brandName,
            ));
      }
    }
  }

  @override
  void didChangeDependencies() {
    final state = context.read<FirebaseBloc>().state;
    if (state.selectedBrandAtHome != null) {
      setState(() {
        selectedBrand = state.selectedBrandAtHome;
      });
    }
    if ((state.shoes.isEmpty && !state.isLoading)) {
      context.read<FirebaseBloc>().add(const FirebaseEventFetchShoes());
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirebaseBloc, FirebaseState>(
      listener: (context, state) {
        if (state is FirebaseStateEmptyState && !state.isLoading) {
          if (state.successMessage != null) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(state.successMessage!),
                    )).then(
              (value) {
                context
                    .read<FirebaseBloc>()
                    .add(const FirebaseEventFetchShoes());
              },
            );
          }
        }
      },
      builder: (context, state) {
        bool isFilterListNotEmpty =
            state.filter != null && state.filter!.filteredShoes!.isNotEmpty;
        bool isFilterNull = state.filter != null ? state.filter!.isNull : true;
        int listLength = isFilterListNotEmpty
            ? state.filter!.filteredShoes!.length
            : state.shoes.length;
        List<Brand> brandsList = [
          allBrand,
        ];
        brandsList.addAll(state.brands);
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state.isLoading && state.shoes.isEmpty
              ? null
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      color: const Color(0xff101010),
                      onPressed: () {
                        Navigator.of(context).pushNamed(productFilterRoute);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/logos/${isFilterNull ? 'filter_logo' : 'filter_with_dot'}.svg',
                          ),
                          SizedBox(
                            width: 0.03 * context.mqSize.width,
                          ),
                          Text(
                            'FILTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 0.017 * context.mqSize.height,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.099 * context.mqSize.height),
            child: Padding(
              padding: EdgeInsets.only(
                right: appBarRightPadding * context.mqSize.width,
                left: appBarLeftPadding * context.mqSize.width,
              ),
              child: AppBar(
                toolbarHeight: 0.102 * context.mqSize.height,
                notificationPredicate: (notification) => false,
                title: Text(
                  'Discover',
                  style: TextStyle(
                    fontSize: 0.044 * context.mqSize.height,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                actions: [
                  Visibility(
                    visible: state.isLoading,
                    child: TextButton(
                      onPressed: () {
                        context
                            .read<FirebaseBloc>()
                            .add(const FirebaseEventResetState());
                        context
                            .read<FirebaseBloc>()
                            .add(const FirebaseEventFetchShoes());
                      },
                      child: Text(
                        'Reset Page',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 0.0205 * context.mqSize.height,
                        ),
                      ),
                    ),
                  ),
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
          body: state.brands.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Column(
                      children: [
                        HorizontalScrollableList(
                          isLoading: state.isLoading,
                          disable: !isFilterNull,
                          listItems: brandsList,
                          onSelect: (brand) {
                            selectedBrand = brand as Brand;
                            context
                                .read<FirebaseBloc>()
                                .add(const FirebaseEventResetState());
                            if (brand.brandName != 'All') {
                              context.read<FirebaseBloc>().add(
                                  FirebaseEventFetchBrandShoes(
                                      brandName: selectedBrand!.brandName));
                            } else {
                              context
                                  .read<FirebaseBloc>()
                                  .add(const FirebaseEventFetchShoes());
                            }
                          },
                        ),
                        Expanded(
                            child: state.isLoading &&
                                    (state is! FirebaseStateDiscover ||
                                        (state.shoes.isEmpty))
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : listLength == 0
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical:
                                              0.0228 * context.mqSize.height,
                                        ),
                                        child: const Text(
                                          'No shoe found!',
                                        ),
                                      )
                                    : GridView.builder(
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing:
                                              0.0342 * context.mqSize.height,
                                          crossAxisSpacing:
                                              0.039 * context.mqSize.width,
                                          childAspectRatio: 0.67,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical:
                                              0.039 * context.mqSize.height,
                                          horizontal: bodyHorizontalPadding *
                                              context.mqSize.width,
                                        ),
                                        scrollDirection: Axis.vertical,
                                        itemCount: listLength,
                                        itemBuilder: (context, index) {
                                          final listItem = isFilterListNotEmpty
                                              ? state
                                                  .filter!.filteredShoes![index]
                                              : state.shoes[index];
                                          return ShoeTile(
                                            onPressed: () {
                                              context.read<FirebaseBloc>().add(
                                                      FirebaseEventFetchTopReviews(
                                                    selectedBrand:
                                                        selectedBrand!,
                                                    shoeId: listItem.documentId,
                                                    lastDocumentId: null,
                                                  ));
                                              Navigator.of(context).pushNamed(
                                                  productDetailRoute,
                                                  arguments: {
                                                    argKeyShoeModel: listItem,
                                                  });
                                            },
                                            shoe: listItem,
                                          );
                                        },
                                      )
                            // : const Center(
                            //     child: CircularProgressIndicator()),
                            ),
                      ],
                    ),
                    Visibility(
                      visible: state.isLoading &&
                          (state is FirebaseStateDiscover &&
                              state.shoes.isNotEmpty),
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: CircularLoader(),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
