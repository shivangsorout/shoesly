import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/constants/key_constants.dart';
import 'package:shoesly_app/constants/routes.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/black_button.dart';
import 'package:shoesly_app/helpers/custom_widgets/bottom_bar.dart';
import 'package:shoesly_app/helpers/custom_widgets/cart_item_tile.dart';
import 'dart:developer' as devtools show log;

import 'package:shoesly_app/helpers/custom_widgets/label_amount_widget.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_bloc.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_event.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_state.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe_cart.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  String? grandTotal;
  List<ShoeCart> cart = [];

  @override
  void didChangeDependencies() {
    final state = context.read<FirebaseBloc>().state;
    grandTotal = (state.cart.fold(
            0.0, (sum, cartItem) => sum + (cartItem.price * cartItem.quantity)))
        .toStringAsFixed(2);
    setState(() {
      cart.addAll(List.from(state.cart));
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseBloc, FirebaseState>(
      builder: (context, state) {
        grandTotal = (state.cart.fold(0.0,
                (sum, cartItem) => sum + (cartItem.price * cartItem.quantity)))
            .toStringAsFixed(2);
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
                title: const Text('Cart'),
                centerTitle: true,
                notificationPredicate: (notification) => false,
              ),
            ),
          ),
          body: Stack(
            children: [
              Visibility(
                visible: state.cart.isNotEmpty,
                replacement: const Center(
                  child: Text(
                    'Your cart is empty!',
                  ),
                ),
                child: ListView.builder(
                  key: UniqueKey(),
                  padding: EdgeInsets.only(
                    top: 0.0342 * context.mqSize.height,
                    bottom: 0.146 * context.mqSize.height,
                  ),
                  itemCount: state.cart.length,
                  itemBuilder: (context, index) {
                    if (state.cart[index].price == 0) {}
                    devtools.log(state.cart[index].shoeName);
                    return CartItemTile(
                      onQuantityChange: (quantity) {
                        setState(() {
                          state.cart[index].quantity = quantity;
                        });
                      },
                      cartItem: state.cart[index],
                      index: index,
                      confirmDismiss: () {
                        return showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  'Are you sure you want to delete it?'),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Yes'),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('No'),
                                ),
                              ],
                            );
                          },
                        ).then((value) => value ?? false);
                      },
                      onPressed: () {
                        devtools.log('Slided');
                        context.read<FirebaseBloc>().add(
                            FirebaseEventDeleteFromCart(
                                cartItem: state.cart[index]));
                      },
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomBar(
                  children: [
                    LabelAmountWidget(
                      labelText: 'Grand Total',
                      amount: grandTotal!,
                    ),
                    BlackButton(
                      buttonText: 'CHECK OUT',
                      onPressed: state.cart.isEmpty
                          ? null
                          : () {
                              Navigator.of(context).pushNamed(
                                orderSummaryRoute,
                                arguments: {
                                  argKeyGrandTotal: double.parse(grandTotal!)
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
      },
    );
  }
}
