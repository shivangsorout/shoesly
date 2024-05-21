import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class BrandFilterTile extends StatelessWidget {
  final String brandName;
  final int items;
  final bool isSelected;
  const BrandFilterTile({
    super.key,
    required this.brandName,
    required this.items,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.017 * context.mqSize.width,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xffF3F3F3),
                radius: 25,
                child: SvgPicture.asset(
                  "assets/logos/${brandName.toLowerCase()}_logo.svg",
                  colorFilter: const ColorFilter.mode(
                    Color(0xff101010),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Visibility(
                visible: isSelected,
                child: Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xff101010),
                    radius: 10,
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 0.0159 * context.mqSize.height,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0.0114 * context.mqSize.height,
          ),
          Text(
            brandName.toUpperCase(),
            style: TextStyle(
              fontSize: 0.0205 * context.mqSize.height,
              fontWeight: FontWeight.w800,
              color: const Color(0xff101010),
            ),
          ),
          Text(
            '$items Items',
            style: TextStyle(
              fontSize: 0.0171 * context.mqSize.height,
              fontWeight: FontWeight.w500,
              color: const Color(0xffB7B7B7),
            ),
          ),
        ],
      ),
    );
  }
}
