import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension ContextMediaQuery on BuildContext {
  Size get mqSize => MediaQuery.of(this).size;
}
