import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class DevEasterEgg extends StatefulWidget {
  const DevEasterEgg({super.key});

  @override
  State<DevEasterEgg> createState() => _DevEasterEggState();
}

class _DevEasterEggState extends State<DevEasterEgg> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
    _controller.repeat(reverse: true);
    
    // Show confetti after a delay
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _showConfetti = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchProfile() async {
    try {
      await launchUrl(
        Uri.parse('https://github.com/iamthetwodigiter'),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      AppErrorHandler.handleError(
        context,
        'Connection Error',
        'Unable to open the developer profile. Please check your internet connection and try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Secret Found!',
      secondaryImage: 'assets/images/background/home.jpg',
      customLottie: true,
      child: Stack(
        children: [
          if (_showConfetti) _buildConfetti(),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '🎉 Congratulations! 🎉',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You\'ve discovered the hidden Easter egg!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: GestureDetector(
                      onTap: _launchProfile,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/dev.png',
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Meet the creative mind behind this app',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _launchProfile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber.shade700, Colors.amber.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Crafted with ❤️ by ',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'DaggerSquare',
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: 'iamthetwodigiter',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tap on the image or button to visit my GitHub profile',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfetti() {
    return IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
          painter: ConfettiPainter(),
        ),
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.amber,
  ];
  
  final List<Confetti> confetti = List.generate(
    50,
    (index) => Confetti.random(),
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (var piece in confetti) {
      final paint = Paint()..color = colors[piece.colorIndex % colors.length];
      canvas.drawRect(
        Rect.fromLTWH(
          piece.x * size.width,
          piece.y * size.height,
          piece.size,
          piece.size,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Confetti {
  final double x;
  final double y;
  final double size;
  final int colorIndex;

  Confetti(this.x, this.y, this.size, this.colorIndex);

  factory Confetti.random() {
    return Confetti(
      (DateTime.now().millisecondsSinceEpoch % 100) / 100,
      (DateTime.now().microsecondsSinceEpoch % 100) / 100,
      (DateTime.now().millisecondsSinceEpoch % 5) / 10 + 2,
      DateTime.now().millisecondsSinceEpoch % 9,
    );
  }
}