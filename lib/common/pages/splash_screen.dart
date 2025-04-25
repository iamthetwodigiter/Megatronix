import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/pages/landing_page.dart';
import 'package:megatronix/common/pages/onboarding_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Box _preferences = Hive.box('preferences');
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    final bool firstTime = _preferences.get('firstTime', defaultValue: true);
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => firstTime ? OnBoardingPage() : LandingPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.blackBackground,
      body: SafeArea(
        child: Center(
          child: LottieBuilder.asset('assets/animations/amongus.json'),
        ),
      ),
    );
  }
}
