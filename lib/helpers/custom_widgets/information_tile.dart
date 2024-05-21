import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class InformationTile extends StatelessWidget {
  final String labelText;
  final String infoText;
  const InformationTile({
    super.key,
    required this.labelText,
    required this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 0.0228 * context.mqSize.height,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                labelText,
                style: TextStyle(
                  fontSize: 0.0205 * context.mqSize.height,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff160700),
                ),
              ),
              SizedBox(height: 0.0079 * context.mqSize.height),
              Text(
                infoText,
                style: TextStyle(
                  fontSize: 0.0194 * context.mqSize.height,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff666666),
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 0.0182 * context.mqSize.height,
            color: const Color(0xffB7B7B7),
          ),
        ],
      ),
    );
  }
}
