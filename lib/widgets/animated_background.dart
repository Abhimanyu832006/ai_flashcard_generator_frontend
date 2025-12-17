import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  final Random _random = Random();
  late Timer _timer;

  // Initial positions (will be updated by timer)
  double _top1 = 0;
  double _left1 = 0;
  
  double _top2 = 0;
  double _left2 = 0;

  double _top3 = 0;
  double _left3 = 0;

  @override
  void initState() {
    super.initState();
    // Start animation after first frame to get screen size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _randomizePositions();
      _startTimer();
    });
  }

  void _startTimer() {
    // Change positions every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _randomizePositions();
    });
  }

  void _randomizePositions() {
    if (!mounted) return;
    
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    setState(() {
      // Circle 1: Moves mostly in top-left area
      _top1 = _random.nextDouble() * (h / 2) - 50;
      _left1 = _random.nextDouble() * (w / 2) - 50;

      // Circle 2: Moves mostly in bottom-right area
      _top2 = (h / 2) + _random.nextDouble() * (h / 2) - 100;
      _left2 = (w / 2) + _random.nextDouble() * (w / 2) - 100;

      // Circle 3: Wanders freely in the middle
      _top3 = _random.nextDouble() * h * 0.8;
      _left3 = _random.nextDouble() * w * 0.8;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Color - Updated for dynamic theming
        Container(color: Theme.of(context).colorScheme.background),

        // Circle 1 (Blue/Purple)
        AnimatedPositioned(
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
          top: _top1,
          left: _left1,
          child: _circle(
            size: 200,
            colors: [Colors.purpleAccent.withOpacity(0.4), Colors.blueAccent.withOpacity(0.4)],
          ),
        ),

        // Circle 2 (Orange/Pink)
        AnimatedPositioned(
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
          top: _top2,
          left: _left2,
          child: _circle(
            size: 250,
            colors: [Colors.orange.withOpacity(0.4), Colors.pink.withOpacity(0.4)],
          ),
        ),

        // Circle 3 (Teal/Green)
        AnimatedPositioned(
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
          top: _top3,
          left: _left3,
          child: _circle(
            size: 180,
            colors: [Colors.teal.withOpacity(0.4), Colors.greenAccent.withOpacity(0.4)],
          ),
        ),
      ],
    );
  }

  Widget _circle({required double size, required List<Color> colors}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}