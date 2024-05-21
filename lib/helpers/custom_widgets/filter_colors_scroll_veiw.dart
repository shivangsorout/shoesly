import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/color_filter_tag.dart';
import 'package:shoesly_app/helpers/custom_widgets/horizontal_filter_list.dart';

class FilterColorsScrollView extends StatelessWidget {
  final List<MapEntry<String, dynamic>> colorsList;
  final MapEntry<String, dynamic>? selectedColor;
  final void Function(dynamic) onSelect;

  const FilterColorsScrollView({
    super.key,
    required this.colorsList,
    required this.selectedColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return HorizontalFilterList(
      itemsList: colorsList,
      selectedItem: selectedColor,
      onSelect: onSelect,
      listViewHeight: 0.0513 * context.mqSize.height,
      paddingRight: 0.0243 * context.mqSize.width,
      childWidget: (index) {
        return ColorFilterTag(
          isSelected: selectedColor == null
              ? false
              : selectedColor!.key == colorsList[index].key,
          colorMap: colorsList[index],
        );
      },
    );
  }
}
