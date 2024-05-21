import 'package:flutter/material.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class BottomBar extends StatelessWidget {
  final List<Widget> children;
  const BottomBar({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: bodyHorizontalPadding * context.mqSize.width,
            vertical: 0.0205 * context.mqSize.height,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xffD7D7D7).withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 30,
                offset: const Offset(
                    0, -20), // Vertical offset to cast shadow upwards
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}
