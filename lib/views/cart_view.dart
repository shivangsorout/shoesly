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
    return BlocListener<FirebaseBloc, FirebaseState>(
      listener: (context, state) {
        setState(() {
          cart = state.cart;
          grandTotal = (state.cart.fold(
                  0.0,
                  (sum, cartItem) =>
                      sum + (cartItem.price * cartItem.quantity)))
              .toStringAsFixed(2);
        });
      },
      child: Scaffold(
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
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.only(
                top: 0.0342 * context.mqSize.height,
                bottom: 0.146 * context.mqSize.height,
              ),
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return CartItemTile(
                  onQuantityChange: (quantity) {
                    setState(() {
                      cart[index].quantity = quantity;
                    });
                  },
                  cartItem: cart[index],
                  index: index,
                  confirmDismiss: () {
                    return showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title:
                              const Text('Are you sure you want to delete it?'),
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
                    cart.removeAt(index);
                    context.read<FirebaseBloc>().add(
                        FirebaseEventDeleteFromCart(cartItem: cart[index]));
                  },
                );
              },
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
                    onPressed: cart.isEmpty
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
      ),
    );
  }
}
