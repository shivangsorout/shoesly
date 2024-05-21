import 'package:flutter/material.dart';
import 'package:shoesly_app/constants/constants.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class HorizontalFilterList extends StatefulWidget {
  final List<dynamic> itemsList;
  final dynamic selectedItem;
  final void Function(dynamic) onSelect;
  final Widget Function(int) childWidget;
  final double listViewHeight;
  final double paddingRight;

  const HorizontalFilterList({
    super.key,
    required this.itemsList,
    required this.selectedItem,
    required this.onSelect,
    required this.childWidget,
    required this.listViewHeight,
    required this.paddingRight,
  });

  @override
  State<HorizontalFilterList> createState() => _HorizontalFilterListState();
}

class _HorizontalFilterListState extends State<HorizontalFilterList> {
  dynamic filterItemSelected;

  @override
  void initState() {
    filterItemSelected = widget.selectedItem;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.listViewHeight,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: bodyHorizontalPadding * context.mqSize.width,
        ),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: widget.paddingRight),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  filterItemSelected = widget.itemsList[index];
                });
                widget.onSelect(filterItemSelected!);
              },
              child: widget.childWidget(index),
            ),
          );
        },
        itemCount: widget.itemsList.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
