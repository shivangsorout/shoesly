import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class CircularLoader extends StatelessWidget {
  const CircularLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 0.0114 * context.mqSize.height),
      child: SizedBox(
        height: 0.0342 * context.mqSize.height,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
