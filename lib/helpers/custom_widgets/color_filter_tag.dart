import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class ColorFilterTag extends StatefulWidget {
  final MapEntry<String, dynamic> colorMap;
  final bool isSelected;
  const ColorFilterTag({
    super.key,
    required this.colorMap,
    required this.isSelected,
  });

  @override
  State<ColorFilterTag> createState() => _ColorFilterTagState();
}

class _ColorFilterTagState extends State<ColorFilterTag> {
  late int color;
  late String colorName;

  @override
  void initState() {
    color = int.parse('0xff${widget.colorMap.key}');
    colorName = widget.colorMap.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 0.0486 * context.mqSize.width,
            vertical: 0.0079 * context.mqSize.height,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xff101010)
                  : const Color(0xffE7E7E7),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 0.0228 * context.mqSize.height,
                width: 0.0486 * context.mqSize.width,
                decoration: BoxDecoration(
                  color: Color(color),
                  shape: BoxShape.circle,
                  border: color == 0xffFFFFFF
                      ? Border.all(
                          color: const Color(0xffdadada),
                          width: 1,
                        )
                      : null,
                ),
              ),
              SizedBox(
                width: 0.0243 * context.mqSize.width,
              ),
              Text(
                colorName,
                style: TextStyle(
                  fontSize: 0.0228 * context.mqSize.height,
                  color: const Color(0xff101010),
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
