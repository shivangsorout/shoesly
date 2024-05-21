import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/circular_icon_button.dart';
import 'package:shoesly_app/services/firebase_firestore_service/models/shoe_cart.dart';

class CartItemTile extends StatefulWidget {
  final int index;
  final void Function() onPressed;
  final Future<bool> Function() confirmDismiss;
  final ShoeCart cartItem;
  final void Function(int) onQuantityChange;

  const CartItemTile({
    super.key,
    required this.index,
    required this.onPressed,
    required this.cartItem,
    required this.onQuantityChange,
    required this.confirmDismiss,
  });

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile>
    with TickerProviderStateMixin {
  late int _counter;
  final int _minValue = 1;
  final int _maxValue = 5;

  late SlidableController _slidableController;
  late ShoeCart cartItem;

  @override
  void initState() {
    cartItem = widget.cartItem;
    _counter = cartItem.quantity;
    _slidableController = SlidableController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      controller: _slidableController,
      endActionPane: ActionPane(
        key: UniqueKey(),
        motion: const StretchMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            widget.onPressed();
          },
          confirmDismiss: widget.confirmDismiss,
        ),
        extentRatio: 0.213,
        children: [
          CustomSlidableAction(
            backgroundColor: const Color(0xffFF4C5E),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            onPressed: (context) {
              widget.onPressed();
            },
            autoClose: true,
            child: SvgPicture.asset(
              'assets/logos/trash.svg',
              height: 0.0273 * context.mqSize.height,
            ),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: bodyHorizontalPadding * context.mqSize.width,
          vertical: 0.0171 * context.mqSize.height,
        ),
        height: 0.11 * context.mqSize.height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  cartItem.imgUrl,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(
              width: 0.0364 * context.mqSize.width,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 0.0079 * context.mqSize.height,
                        ),
                        child: Text(
                          cartItem.shoeName,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 0.0251 * context.mqSize.height,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff101010),
                          ),
                        ),
                      ),
                      Text(
                        '${cartItem.brandName} . ${cartItem.colorSelected.value} . ${cartItem.selectedSize}',
                        style: TextStyle(
                          fontSize: 0.0205 * context.mqSize.height,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${(cartItem.price * _counter).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 0.0228 * context.mqSize.height,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff101010),
                        ),
                      ),
                      Row(
                        children: [
                          CircularIconButton(
                            icon: Icons.remove,
                            isEnabled: _counter > _minValue,
                            onTap: _counter > _minValue
                                ? () {
                                    setState(() {
                                      if (_counter > _minValue) {
                                        _counter--;
                                      }
                                      widget.onQuantityChange(_counter);
                                    });
                                  }
                                : null,
                          ),
                          Container(
                            width: 0.0267 * context.mqSize.width,
                            margin: EdgeInsets.symmetric(
                              horizontal: 0.0243 * context.mqSize.width,
                            ),
                            child: Center(
                              child: Text(
                                '$_counter',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff101010),
                                ),
                              ),
                            ),
                          ),
                          CircularIconButton(
                            icon: Icons.add,
                            isEnabled: _counter < _maxValue,
                            onTap: _counter < _maxValue
                                ? () {
                                    setState(() {
                                      if (_counter < _maxValue) {
                                        _counter++;
                                      }
                                    });
                                    widget.onQuantityChange(_counter);
                                  }
                                : null,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
