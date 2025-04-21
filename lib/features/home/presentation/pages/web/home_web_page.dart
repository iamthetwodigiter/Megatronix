import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/theme/app_theme.dart';

class HomeWebPage extends ConsumerStatefulWidget {
  final bool isMainPage;
  const HomeWebPage({
    super.key,
    this.isMainPage = true,
  });

  @override
  ConsumerState<HomeWebPage> createState() => _HomeWebPageState();
}

class _HomeWebPageState extends ConsumerState<HomeWebPage> {
  late Timer _timer;
  Duration _remainingTime = Duration();
  bool _isParidhiLive = false;

  final List<Color> _nameColors = [
    AppTheme.whiteBackground,
    AppTheme.darkBackground,
    AppTheme.primaryBlueAccentColor,
  ];

  final List<Color> _bannerColors = [
    AppTheme.whiteBackground,
    AppTheme.errorColor,
    AppTheme.darkBackground,
  ];

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitDays = twoDigits(duration.inDays.remainder(30));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitDays:$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }

  void _startTimer() {
    DateTime targetDate = DateTime(2025, 4, 30);
    _remainingTime = targetDate.difference(DateTime.now());

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = targetDate.difference(DateTime.now());
        if (_remainingTime.isNegative) {
          _remainingTime = Duration.zero;
          _isParidhiLive = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isWideScreen = size.width > 1100;
    String timerText = _formatDuration(_remainingTime);

    return CustomWebScaffold(
      title: 'Welcome to',
      customLottie: 'assets/animations/stars.json',
      isMainPage: widget.isMainPage,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1400),
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 80 : 24,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top Section
                  AnimatedTextKit(
                    repeatForever: true,
                    isRepeatingAnimation: true,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        "MEGATRONIX",
                        textStyle: TextStyle(
                          fontSize: isWideScreen ? 60 : 50,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        colors: _nameColors,
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.01),
                  Text(
                    'Presents',
                    style: TextStyle(
                      color: AppTheme.whiteBackground,
                      fontSize: isWideScreen ? 30 : 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Image.asset(
                    'assets/images/paridhi_full.png',
                    height: isWideScreen ? 175 : 150,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),

                  // Middle Section - Description
                  Container(
                    height: constraints.maxHeight * 0.25, // Set fixed height relative to screen
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.transparentColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlueAccentColor.withAlpha(100),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        pause: Duration(seconds: 2),
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            "Megatronix presents Paridhi: Eastern Kolkata's biggest tech fest hosted annually at MSIT. As the official technical club's flagship event, Paridhi offers a dynamic platform for innovation through diverse competitions, hands-on workshops, and tech showcases. Students from various institutions participate in coding challenges, robotics events, and expert sessions that expand technical horizons. Join us to explore emerging technologies, connect with fellow innovators, and demonstrate your skills in an atmosphere of technical excellence and creative discovery.",
                            textStyle: TextStyle(
                              fontFamily: 'DaggerSquare',
                              fontSize: isWideScreen ? 24 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),

                  // Bottom Section - Timer
                  Text(
                    'Time left until the showdown'.toUpperCase(),
                    style: TextStyle(
                      color: AppTheme.whiteBackground,
                      fontSize: isWideScreen ? 28 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.025),
                  if (!_isParidhiLive)
                    Text(
                      timerText,
                      style: TextStyle(
                        color: AppTheme.timerTextColor,
                        fontSize: isWideScreen ? 70 : 60,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'DaggerSquare',
                      ),
                    )
                  else
                    AnimatedTextKit(
                      isRepeatingAnimation: true,
                      repeatForever: true,
                      pause: Duration.zero,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Paridhi is Live',
                          textStyle: TextStyle(
                            fontFamily: 'DaggerSquare',
                            fontSize: isWideScreen ? 50 : 40,
                            fontWeight: FontWeight.bold,
                          ),
                          colors: _bannerColors,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
