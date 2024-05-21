import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class LabelAmountWidget extends StatelessWidget {
  final String labelText;
  final String amount;

  const LabelAmountWidget({
    super.key,
    required this.labelText,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 0.0194 * context.mqSize.height,
            fontWeight: FontWeight.w500,
            color: const Color(0xffB7B7B7),
          ),
        ),
        SizedBox(
          height: 0.0057 * context.mqSize.height,
        ),
        Text(
          '\$$amount',
          style: TextStyle(
            fontSize: 0.0285 * context.mqSize.height,
            fontWeight: FontWeight.w800,
            color: const Color(0xff101010),
          ),
        ),
      ],
    );
  }
}
