import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/theme/app_theme.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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

    String timerText = _formatDuration(_remainingTime);

    return CustomScaffold(
      title: 'Welcome to',
      secondaryImage: 'assets/images/background.png',
      isMainPage: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              AnimatedTextKit(
                repeatForever: true,
                isRepeatingAnimation: true,
                animatedTexts: [
                  ColorizeAnimatedText(
                    "MEGATRONIX",
                    textStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    colors: _nameColors,
                  ),
                ],
                onTap: () {},
              ),
              Text(
                'Presents',
                style: TextStyle(
                  color: AppTheme.whiteBackground,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/images/paridhi_full.png',
                height: 125,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: AppTheme.transparentColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlueAccentColor.withAlpha(100),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ]),
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              pause: Duration(seconds: 2),
              animatedTexts: [
                TypewriterAnimatedText(
                  "Megatronix presents Paridhi: Eastern Kolkata's biggest tech fest at MSIT. Featuring competitions, workshops and tech showcases for all tech enthusiasts.",
                  textStyle: TextStyle(
                    fontFamily: 'DaggerSquare',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
              onTap: () {},
            ),
          ),
          Column(
            children: [
              Container(
                height: 75,
                alignment: Alignment.center,
                child: Text(
                  'Time left until the showdown'.toUpperCase(),
                  style: TextStyle(
                    color: AppTheme.whiteBackground,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              (!_isParidhiLive)
                  ? Container(
                      height: 75,
                      width: size.width,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        timerText,
                        style: TextStyle(
                          color: AppTheme.timerTextColor,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DaggerSquare',
                        ),
                      ),
                    )
                  : AnimatedTextKit(
                      isRepeatingAnimation: true,
                      repeatForever: true,
                      pause: Duration.zero,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Paridhi is Live',
                          textStyle: TextStyle(
                            fontFamily: 'DaggerSquare',
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                          colors: _bannerColors,
                        ),
                      ],
                      onTap: () {},
                    ),
            ],
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
