import 'package:flutter/material.dart';

class WidgetWrapper extends StatelessWidget {
  final Widget child;

  const WidgetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
