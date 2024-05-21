import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/constants/key_constants.dart';
import 'package:shoesly_app/constants/routes.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/black_button.dart';
import 'package:shoesly_app/helpers/custom_widgets/bottom_bar.dart';
import 'package:shoesly_app/helpers/custom_widgets/information_tile.dart';
import 'package:shoesly_app/helpers/custom_widgets/label_amount_widget.dart';
import 'package:shoesly_app/helpers/custom_widgets/order_detail_tile.dart';
import 'package:shoesly_app/helpers/custom_widgets/price_info_tile.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_bloc.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_event.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_state.dart';

class OrderSummaryView extends StatefulWidget {
  const OrderSummaryView({super.key});

  @override
  State<OrderSummaryView> createState() => _OrderSummaryViewState();
}

class _OrderSummaryViewState extends State<OrderSummaryView> {
  final Widget divider = const Divider(
    color: Color(0xffF3F3F3),
    thickness: 1,
  );

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final grandTotal = args[argKeyGrandTotal] as double;
    return BlocConsumer<FirebaseBloc, FirebaseState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(appBarHeight * context.mqSize.height),
            child: Padding(
              padding: EdgeInsets.only(
                left: appBarLeftPadding * context.mqSize.width,
                right: appBarRightPadding * context.mqSize.width,
              ),
              child: AppBar(
                title: const Text('Order Summary'),
                centerTitle: true,
                notificationPredicate: (notification) => false,
              ),
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: bodyHorizontalPadding * context.mqSize.width,
                  vertical: 0.0342 * context.mqSize.height,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const OrderSummaryHeadingText(text: 'Information'),
                      const InformationTile(
                        labelText: 'Payment Method',
                        infoText: 'Credit Card',
                      ),
                      divider,
                      const InformationTile(
                        labelText: 'Location',
                        infoText: 'Semarang, Indonesia',
                      ),
                      SizedBox(
                        height: 0.0114 * context.mqSize.height,
                      ),
                      const OrderSummaryHeadingText(text: 'Order Detail'),
                      SizedBox(
                        height: 0.0114 * context.mqSize.height,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final cartItem = state.cart[index];
                          return OrderDetailTile(
                            shoeName: cartItem.shoeName,
                            shoeDetail:
                                '${cartItem.brandName} . ${cartItem.colorSelected.value} . ${cartItem.selectedSize} . Qty ${cartItem.quantity}',
                            shoePrice: (cartItem.price * cartItem.quantity)
                                .toStringAsFixed(2),
                          );
                        },
                        itemCount: state.cart.length,
                        shrinkWrap: true,
                      ),
                      SizedBox(
                        height: 0.0114 * context.mqSize.height,
                      ),
                      const OrderSummaryHeadingText(
                        text: 'Payment Detail',
                      ),
                      SizedBox(
                        height: 0.0114 * context.mqSize.height,
                      ),
                      PriceInfoTile(
                        tagHeading: 'Sub Total',
                        amount: '$grandTotal',
                      ),
                      const PriceInfoTile(
                        tagHeading: 'Shipping',
                        amount: '20.00',
                      ),
                      divider,
                      SizedBox(
                        height: 0.0114 * context.mqSize.height,
                      ),
                      PriceInfoTile(
                        tagHeading: 'Total Order',
                        amount: '${grandTotal + 20}',
                        amountFontSize: 0.0251 * context.mqSize.height,
                        fontWeight: FontWeight.w800,
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
                      labelText: 'Grand Total',
                      amount: '${grandTotal + 20}',
                    ),
                    BlackButton(
                      buttonText: 'PAYMENT',
                      onPressed: () {
                        context
                            .read<FirebaseBloc>()
                            .add(FirebaseEventPlaceOrder(
                              paymentMethod: 'Credit Card',
                              location: 'Semarang, Indonesia',
                              cartShoes: state.cart,
                              subTotal: grandTotal,
                              shippingFee: 20,
                              grandTotal: grandTotal + 20,
                            ));
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          homeRoute,
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class OrderSummaryHeadingText extends StatelessWidget {
  final String text;
  const OrderSummaryHeadingText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 0.0262 * context.mqSize.height,
        fontWeight: FontWeight.w800,
        color: const Color(0xff160700),
      ),
    );
  }
}
