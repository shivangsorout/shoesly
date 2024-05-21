import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class FilterTagWidget extends StatelessWidget {
  final String tagText;
  final bool isSeleted;
  const FilterTagWidget({
    super.key,
    required this.tagText,
    required this.isSeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 0.0486 * context.mqSize.width,
        vertical: 0.0079 * context.mqSize.height,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: isSeleted
            ? null
            : Border.all(
                color: const Color(0xffE7E7E7),
                width: 1,
              ),
        color: isSeleted ? const Color(0xff101010) : Colors.white,
      ),
      child: Center(
        child: Text(
          tagText,
          style: TextStyle(
            fontSize: 0.0228 * context.mqSize.height,
            fontWeight: FontWeight.w700,
            color: isSeleted ? Colors.white : const Color(0xff101010),
          ),
        ),
      ),
    );
  }
}
