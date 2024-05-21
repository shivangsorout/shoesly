import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class ColorSelectionList extends StatefulWidget {
  final List<String> colorsList;
  final void Function(String) onSelect;

  const ColorSelectionList({
    super.key,
    required this.colorsList,
    required this.onSelect,
  });

  @override
  State<ColorSelectionList> createState() => _ColorSelectionListState();
}

class _ColorSelectionListState extends State<ColorSelectionList> {
  String? selectedColor;

  @override
  void initState() {
    selectedColor = widget.colorsList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 0.0145 * context.mqSize.width,
            vertical: 0.0114 * context.mqSize.height,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.colorsList.map((color) {
              final colorInt = int.parse('0xff$color');
              const greyColor = Color(0xffE7E7E7);
              const size = 20.0;
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                  widget.onSelect(color);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    border: color.toLowerCase() == 'ffffff'
                        ? Border.all(
                            color: greyColor,
                            width: 1,
                          )
                        : null,
                    color: Color(colorInt),
                    shape: BoxShape.circle,
                  ),
                  child: Visibility(
                    visible: selectedColor == color,
                    child: Icon(
                      Icons.check,
                      size: 13,
                      color: color.toLowerCase() != 'ffffff'
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
