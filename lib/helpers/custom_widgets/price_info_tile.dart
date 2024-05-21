import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class PriceInfoTile extends StatelessWidget {
  final String tagHeading;
  final String amount;
  final double amountFontSize;
  final FontWeight fontWeight;

  const PriceInfoTile({
    super.key,
    required this.tagHeading,
    required this.amount,
    this.amountFontSize = 20,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0114 * context.mqSize.height),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tagHeading,
            style: TextStyle(
              fontSize: 0.0205 * context.mqSize.height,
              fontWeight: FontWeight.w400,
              color: const Color(0xff666666),
            ),
          ),
          Text(
            '\$$amount',
            style: TextStyle(
              fontSize: amountFontSize,
              fontWeight: fontWeight,
              color: const Color(0xff160700),
            ),
          ),
        ],
      ),
    );
  }
}
