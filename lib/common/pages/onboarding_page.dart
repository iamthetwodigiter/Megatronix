import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/pages/landing_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  Box preferences = Hive.box('preferences');
  bool _enableAnimation = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return OnBoardingSlider(
      headerBackgroundColor: AppTheme.scaffoldBackgroundColor,
      pageBackgroundColor: AppTheme.scaffoldBackgroundColor,
      centerBackground: true,
      finishButtonText: "Let's Go!!!",
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: AppTheme.primaryBlueAccentColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onFinish: () {
        preferences.put('firstTime', false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LandingPage(),
          ),
        );
      },
      background: [
        LottieBuilder.asset('assets/animations/hello.json'),
        LottieBuilder.asset('assets/animations/confused.json'),
        LottieBuilder.asset('assets/animations/confused.json'),
      ],
      totalPage: 3,
      speed: 1.8,
      pageBodies: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 480,
              ),
              Text(
                'Welcome to Megatronix',
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              Text(
                'presents',
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              Text(
                'Paridhi 2025',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 300,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.75,
                    child: Text(
                      'Do you want to enable background animations in the app?',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: AppTheme.primaryBlueAccentColor,
                    value: _enableAnimation,
                    onChanged: (value) {
                      setState(
                        () {
                          _enableAnimation = value;
                          preferences.put('enableAnimation', value);
                        },
                      );
                    },
                  )
                ],
              ),
              SizedBox(height: 15),
              Text(
                "You can toggle between animated and non-animated background modes. Use non-animated mode for low-end devices.",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 15),
              Text(
                "[Tip]: Don't worry, you can always change it later in the settings.",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 70),
          child: Column(
            children: [
              SizedBox(
                height: 250,
              ),
              Text(
                'How to pariticipate in Paridhi 2025?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              ListTile(
                title: const Text('Main Registration'),
                subtitle: const Text(
                  'Navigate to Events > Paridhi > Main Registration to complete Paridhi 2025 registration to be able to participate in events.',
                  style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                ),
                leading: Text(
                  '1. ',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ListTile(
                title: const Text('Event Registration'),
                subtitle: const Text(
                  'Navigate to Events > Paridhi > Domain > Events > Event Registration to register for events.',
                  style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                ),
                leading: Text(
                  '2. ',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              ListTile(
                title: const Text('Combo Event Registration'),
                subtitle: const Text(
                  'Navigate to Events > Paridhi > Domain > Combo Events > Combo Events Registration to register your team for combo events.',
                  style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                ),
                leading: Text(
                  '3. ',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(
                '[Tip]: You can always find the guide in the help section of the app.',
                style: TextStyle(fontSize: 12),
              ),
              
            ],
          ),
        ),
      ],
    );
  }
}
