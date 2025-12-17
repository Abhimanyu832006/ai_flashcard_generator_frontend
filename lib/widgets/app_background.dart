import 'package:flutter/material.dart';
import 'animated_background.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AnimatedBackground(),
        SafeArea(child: child),
      ],
    );
  }
}
