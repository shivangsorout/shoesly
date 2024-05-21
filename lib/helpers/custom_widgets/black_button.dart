import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class BlackButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;

  const BlackButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(
        horizontal: 0.0766 * context.mqSize.width,
        vertical: 0.0188 * context.mqSize.height,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      color: Colors.black,
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 0.0205 * context.mqSize.height,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}
