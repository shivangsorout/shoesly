import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class ShoeSizeList extends StatefulWidget {
  final List<int> shoeSizeList;
  final void Function(int) onSelect;
  const ShoeSizeList({
    super.key,
    required this.shoeSizeList,
    required this.onSelect,
  });

  @override
  State<ShoeSizeList> createState() => _ShoeSizeListState();
}

class _ShoeSizeListState extends State<ShoeSizeList> {
  late int selectedSize;

  @override
  void initState() {
    selectedSize = widget.shoeSizeList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.shoeSizeList.map((size) {
        final circleSize = 0.0456 * context.mqSize.height;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              selectedSize = size;
            });
            widget.onSelect(size);
          },
          child: Container(
            margin: EdgeInsets.only(
              right: 0.0364 * context.mqSize.width,
              top: 0.0114 * context.mqSize.height,
            ),
            height: circleSize,
            width: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: selectedSize == size
                  ? null
                  : Border.all(
                      color: const Color(0xffE7E7E7),
                      width: 1,
                    ),
              color:
                  selectedSize == size ? const Color(0xff101010) : Colors.white,
            ),
            child: Center(
              child: Text(
                '$size',
                style: TextStyle(
                  color: selectedSize == size
                      ? Colors.white
                      : const Color(0xff6F6F6F),
                  fontSize: 0.0205 * context.mqSize.height,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
