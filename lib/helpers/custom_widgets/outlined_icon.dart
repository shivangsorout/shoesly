import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class OutlinedIcon extends StatelessWidget {
  const OutlinedIcon({
    super.key,
    required this.icon,
    required this.isEnable,
    this.iconSize = 20,
    this.iconStroke = 1,
  });

  final bool isEnable;
  final IconData icon;
  final double iconSize;
  final double iconStroke;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.00342 * context.mqSize.height),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isEnable ? const Color(0xff101010) : const Color(0xffB7B7B7),
          width: iconStroke,
        ),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: isEnable ? const Color(0xff101010) : const Color(0xffB7B7B7),
      ),
    );
  }
}
