import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class HorizontalScrollableList extends StatefulWidget {
  final bool disable;
  final bool isLoading;
  final List<dynamic> listItems;
  final void Function(dynamic) onSelect;
  const HorizontalScrollableList({
    super.key,
    required this.listItems,
    required this.onSelect,
    this.disable = false,
    this.isLoading = false,
  });

  @override
  State<HorizontalScrollableList> createState() =>
      _HorizontalScrollableListState();
}

class _HorizontalScrollableListState extends State<HorizontalScrollableList> {
  late dynamic selectedItem;
  bool isStringList = false;

  @override
  void initState() {
    selectedItem = widget.listItems[0];
    isStringList = widget.listItems is List<String>;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 0.04 * context.mqSize.height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.listItems.length,
            padding: EdgeInsets.symmetric(
              horizontal: 0.073 * context.mqSize.width,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 0.0486 * context.mqSize.width),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget.disable
                      ? null
                      : widget.isLoading
                          ? null
                          : () {
                              setState(() {
                                selectedItem = widget.listItems[index];
                              });
                              widget.onSelect(selectedItem);
                            },
                  child: Text(
                    isStringList
                        ? widget.listItems[index]
                        : widget.listItems[index].brandName,
                    style: TextStyle(
                      fontSize: 0.028 * context.mqSize.height,
                      fontWeight: FontWeight.w700,
                      color: widget.disable
                          ? const Color(0xffB7B7B7)
                          : selectedItem == widget.listItems[index]
                              ? const Color(0xff101010)
                              : const Color(0xffB7B7B7),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
