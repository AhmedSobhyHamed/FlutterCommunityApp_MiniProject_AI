import 'package:flutter/material.dart';

/// Horizontal page inset from the current window width.
double horizontalPadding(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width >= 900) {
    return width * 0.28;
  }
  if (width >= 600) {
    return 48;
  }
  return 24;
}
