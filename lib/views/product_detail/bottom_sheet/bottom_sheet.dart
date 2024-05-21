import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/constants/routes.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/black_button.dart';
import 'package:shoesly_app/helpers/custom_widgets/grey_outlined_button.dart';
import 'package:shoesly_app/helpers/custom_widgets/label_amount_widget.dart';
import 'package:shoesly_app/helpers/custom_widgets/outlined_icon.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_bloc.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_event.dart';
import 'package:shoesly_app/services/firebase_firestore_service/bloc/firebase_state.dart';
import 'dart:developer' as devtools show log;

import 'package:shoesly_app/services/firebase_firestore_service/models/shoe.dart';

class BottomSheetView extends StatefulWidget {
  final Shoe shoe;
  final String selectedColor;
  final int selectedSize;

  const BottomSheetView({
    super.key,
    required this.shoe,
    required this.selectedColor,
    required this.selectedSize,
  });

  @override
  State<BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {
  final TextEditingController _controller = TextEditingController(text: '1');
  final int _minValue = 1;
  final int _maxValue = 5;
  int _currentValue = 1;
  bool isAddedToCart = false;

  void setCurrentValue() {
    setState(() {
      _currentValue =
          _controller.text.isEmpty ? 1 : int.parse(_controller.text);
    });
  }

  void _increment() {
    int currentValue = int.tryParse(_controller.text) ?? _minValue;
    if (currentValue < _maxValue) {
      currentValue++;
      _controller.text = currentValue.toString();
    }
    setCurrentValue();
  }

  void _decrement() {
    int currentValue = int.tryParse(_controller.text) ?? _minValue;
    if (currentValue > _minValue) {
      currentValue--;
      _controller.text = currentValue.toString();
    }
    setCurrentValue();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: bodyHorizontalPadding * context.mqSize.width,
                ),
                height: 0.351 * context.mqSize.height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: !isAddedToCart
                    ? addToCart(context)
                    : cartAddSuccessMessage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column cartAddSuccessMessage(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 0.0342 * context.mqSize.height,
        ),
        Container(
          margin: EdgeInsets.all(0.0102 * context.mqSize.height),
          padding: EdgeInsets.all(0.0273 * context.mqSize.height),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xff101010),
              width: 3,
            ),
          ),
          child: SvgPicture.asset('assets/logos/checkmark.svg'),
        ),
        SizedBox(
          height: 0.0228 * context.mqSize.height,
        ),
        Text(
          'Added to cart',
          style: TextStyle(
            fontSize: 0.0342 * context.mqSize.height,
            fontWeight: FontWeight.w700,
            color: const Color(0xff101010),
          ),
        ),
        SizedBox(height: 0.0057 * context.mqSize.height),
        BlocBuilder<FirebaseBloc, FirebaseState>(
          builder: (context, state) {
            return Text(
              '${state.cart.length == 1 ? '1 Item' : '${state.cart.length} Items'} Total',
              style: TextStyle(
                fontSize: 0.0205 * context.mqSize.height,
                fontWeight: FontWeight.w500,
                color: const Color(0xff6F6F6F),
              ),
            );
          },
        ),
        SizedBox(
          height: 0.0228 * context.mqSize.height,
        ),
        Row(
          children: [
            Expanded(
              child: GreyOutlinedButton(
                onPressed: () {
                  context
                      .read<FirebaseBloc>()
                      .add(const FirebaseEventResetState());
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    homeRoute,
                    (route) => false,
                  );
                },
                buttonText: 'BACK EXPLORE',
              ),
            ),
            SizedBox(
              width: 0.0364 * context.mqSize.width,
            ),
            Expanded(
              child: BlackButton(
                buttonText: 'TO CART',
                onPressed: () {
                  Navigator.of(context).pushNamed(cartRoute);
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Column addToCart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            height: 0.0045 * context.mqSize.height,
            width: 0.107 * context.mqSize.width,
            margin: EdgeInsets.symmetric(
              vertical: 0.0114 * context.mqSize.height,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffE7E7E7),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        SizedBox(
          height: 0.0228 * context.mqSize.height,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Add to cart',
              style: TextStyle(
                fontSize: 0.0285 * context.mqSize.height,
                fontWeight: FontWeight.w700,
                color: const Color(0xff101010),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                size: 0.0262 * context.mqSize.height,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.0342 * context.mqSize.height),
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 0.0228 * context.mqSize.height,
            fontWeight: FontWeight.w700,
            color: const Color(0xff101010),
          ),
        ),
        TextField(
          controller: _controller,
          style: TextStyle(
            fontSize: 0.0205 * context.mqSize.height,
            fontWeight: FontWeight.w400,
            color: const Color(0xff101010),
          ),
          autocorrect: false,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.allow(RegExp(r'^[1-5]$')),
          ],
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setCurrentValue();
            devtools.log('$_currentValue');
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 0.0114 * context.mqSize.height,
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: OutlinedIcon(
                    isEnable: _currentValue > _minValue,
                    icon: Icons.remove,
                  ),
                  onPressed: _currentValue > _minValue ? _decrement : null,
                ),
                SizedBox(
                  width: 0.0243 * context.mqSize.width,
                ),
                IconButton(
                  icon: OutlinedIcon(
                    icon: Icons.add,
                    isEnable: _currentValue < _maxValue,
                  ),
                  onPressed: _currentValue < _maxValue ? _increment : null,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 0.0342 * context.mqSize.height,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelAmountWidget(
              amount: (_currentValue * widget.shoe.price).toStringAsFixed(2),
              labelText: 'Total Price',
            ),
            BlackButton(
              buttonText: 'ADD TO CART',
              onPressed: () {
                context
                    .read<FirebaseBloc>()
                    .add(const FirebaseEventResetReviews());
                context.read<FirebaseBloc>().add(FirebaseEventAddToCart(
                      colorSelected: MapEntry(widget.selectedColor,
                          widget.shoe.colorsMap[widget.selectedColor]),
                      quantity: _currentValue,
                      shoe: widget.shoe,
                      sizeSelected: widget.selectedSize,
                    ));
                setState(() {
                  isAddedToCart = true;
                });
              },
            ),
          ],
        )
      ],
    );
  }
}
