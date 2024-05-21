import 'package:flutter/material.dart';
import 'package:shoesly_app/extensions/context_extension.dart';

class GreyOutlinedButton extends StatelessWidget {
  final void Function() onPressed;
  final String buttonText;
  const GreyOutlinedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            vertical: 0.0188 * context.mqSize.height,
          ),
        ),
        side: const WidgetStatePropertyAll(
          BorderSide(
            color: Color(0xffDADADA),
            width: 1,
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 0.0216 * context.mqSize.height,
          fontWeight: FontWeight.w800,
          color: const Color(0xff101010),
        ),
      ),
    );
  }
}
