import 'package:flutter/material.dart';
import 'package:shoesly_app/helpers/custom_widgets/outlined_icon.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final bool isEnabled;
  final void Function()? onTap;
  const CircularIconButton({
    super.key,
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: OutlinedIcon(
          icon: icon,
          isEnable: isEnabled,
          iconSize: 15,
          iconStroke: 1.5,
        ),
      ),
    );
  }
}
