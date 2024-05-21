import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/filter_tag_widget.dart';
import 'package:shoesly_app/helpers/custom_widgets/horizontal_filter_list.dart';

class FilterTagsScrollView extends StatelessWidget {
  final List<String> tagsList;
  final String? selectedtag;
  final void Function(dynamic) onSelect;
  const FilterTagsScrollView({
    super.key,
    required this.tagsList,
    required this.selectedtag,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return HorizontalFilterList(
      itemsList: tagsList,
      selectedItem: selectedtag,
      onSelect: onSelect,
      listViewHeight: 0.0513 * context.mqSize.height,
      paddingRight: 0.0243 * context.mqSize.width,
      childWidget: (index) {
        return FilterTagWidget(
          tagText: tagsList[index],
          isSeleted: tagsList[index] == selectedtag,
        );
      },
    );
  }
}
