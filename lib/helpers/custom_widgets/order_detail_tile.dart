import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class OrderDetailTile extends StatelessWidget {
  final String shoeName;
  final String shoeDetail;
  final String shoePrice;
  const OrderDetailTile({
    super.key,
    required this.shoeName,
    required this.shoeDetail,
    required this.shoePrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0114 * context.mqSize.height),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shoeName,
            maxLines: 1,
            style: TextStyle(
              fontSize: 0.0228 * context.mqSize.height,
              fontWeight: FontWeight.w600,
              color: const Color(0xff101010),
            ),
          ),
          SizedBox(
            height: 0.0114 * context.mqSize.height,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shoeDetail,
                style: TextStyle(
                  fontSize: 0.0205 * context.mqSize.height,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff666666),
                ),
              ),
              Text(
                '\$$shoePrice',
                style: TextStyle(
                  fontSize: 0.0205 * context.mqSize.height,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff101010),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
