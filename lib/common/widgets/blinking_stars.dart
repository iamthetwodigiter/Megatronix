
import 'dart:math';

import 'package:flutter/material.dart';
class StarryBackground extends StatefulWidget {
  final Color backgroundColor;
  final int numberOfFixedStars;
  final int numberOfBlinkingStars;
  final Widget? child;

  const StarryBackground({
    Key? key,
    this.backgroundColor = const Color(0xFF0A0E21),
    this.numberOfFixedStars = 100,
    this.numberOfBlinkingStars = 40,
    this.child,
  }) : super(key: key);

  @override
  _StarryBackgroundState createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground> {
  late List<Widget> _fixedStars;
  late List<Widget> _blinkingStars;

  @override
  void initState() {
    super.initState();
    _generateStars();
  }

  void _generateStars() {
    final screenSize = WidgetsBinding.instance.window.physicalSize /
        WidgetsBinding.instance.window.devicePixelRatio;

    _fixedStars = List.generate(widget.numberOfFixedStars, (_) {
      return FixedStar(
        top: Random().nextDouble() * screenSize.height,
        left: Random().nextDouble() * screenSize.width,
        size: Random().nextDouble() * 2 + 1,
      );
    });

    _blinkingStars = List.generate(widget.numberOfBlinkingStars, (_) {
      return BlinkingStar(
        top: Random().nextDouble() * screenSize.height,
        left: Random().nextDouble() * screenSize.width,
        size: Random().nextDouble() * 3 + 2,
        blinkDuration: Duration(milliseconds: Random().nextInt(1500) + 500),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: widget.backgroundColor),
        ..._fixedStars,
        ..._blinkingStars,
        if (widget.child != null) widget.child!,
      ],
    );
  }
}


class FixedStar extends StatelessWidget {
  final double top;
  final double left;
  final double size;

  const FixedStar({
    Key? key,
    required this.top,
    required this.left,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class BlinkingStar extends StatefulWidget {
  final double top;
  final double left;
  final double size;
  final Duration blinkDuration;

  const BlinkingStar({
    Key? key,
    required this.top,
    required this.left,
    required this.size,
    required this.blinkDuration,
  }) : super(key: key);

  @override
  State<BlinkingStar> createState() => _BlinkingStarState();
}

class _BlinkingStarState extends State<BlinkingStar> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Higher vsync rate for smoother animation
    _controller = AnimationController(
      vsync: this,
      duration: widget.blinkDuration,
    )..addListener(() {
      setState(() {}); // Force rebuild at 60 FPS
    });

    _animation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Add a delay before starting animation for random effect
    Future.delayed(Duration(milliseconds: Random().nextInt(2000)), () {
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      child: Opacity(
        opacity: _animation.value,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Star glow
            Container(
              width: widget.size * 2,
              height: widget.size * 2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: widget.size,
                    spreadRadius: widget.size * 0.5,
                  ),
                ],
              ),
            ),
            // Star center
            Container(
              width: widget.size,
              height: widget.size,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
