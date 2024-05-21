import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';
import 'package:shoesly_app/helpers/custom_widgets/colors_selection_list.dart';
import 'package:shoesly_app/helpers/custom_widgets/network_image_viewer.dart';

class ImageSlider extends StatefulWidget {
  final List<String> colorsList;
  final List<String> imgList;
  final void Function(String) onSelect;

  const ImageSlider({
    super.key,
    required this.colorsList,
    required this.imgList,
    required this.onSelect,
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;
  late final PageController _imgController;

  @override
  void initState() {
    _imgController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _imgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _imgController,
            itemCount: widget.imgList.length,
            onPageChanged: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: NetworkImageViewer(
                      imgUrl: widget.imgList[index],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 0.0486 * context.mqSize.width,
              vertical: 0.0296 * context.mqSize.height,
            ),
            child: Row(
              children: widget.imgList.asMap().entries.map((entry) {
                return Container(
                  width: 0.017 * context.mqSize.width,
                  height: 0.0079 * context.mqSize.height,
                  margin: EdgeInsets.symmetric(
                    horizontal: 0.0121 * context.mqSize.width,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? const Color(0xff101010)
                        : const Color(0xffB7B7B7),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ColorSelectionList(
            colorsList: widget.colorsList,
            onSelect: widget.onSelect,
          ),
        ),
      ],
    );
  }
}
