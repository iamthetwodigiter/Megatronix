import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:megatronix/common/pages/landing_page.dart';
import 'package:megatronix/common/pages/onboarding_page.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ChewieController _controller;
  final Box _preferences = Hive.box('preferences');
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bool firstTime = _preferences.get('firstTime', defaultValue: true);
      _controller.videoPlayerController.addListener(() {
        if (_controller.videoPlayerController.value.position ==
            _controller.videoPlayerController.value.duration) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  firstTime ? OnBoardingPage() : LandingPage(),
            ),
          );
        }
      });
    });
  }

  void _initializeVideoPlayer() {
    _controller = ChewieController(
      videoPlayerController: VideoPlayerController.asset(
        'assets/videos/splashScreen.mp4',
      ),
      autoInitialize: true,
      autoPlay: true,
      showControls: false,
      showOptions: false,
      aspectRatio: 9 / 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blackBackground,
      body: Center(
        child: Chewie(
          controller: _controller,
        ),
      ),
    );
  }
}
