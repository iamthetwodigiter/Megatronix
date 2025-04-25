import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:megatronix/common/pages/landing_page.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/core/utils/util_functions.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  Box preferences = Hive.box('preferences');
  List<String> _images = [];
  bool _enableAnimation = true;

  @override
  void initState() {
    super.initState();
    _images = UtilFunctions.getTextFieldImagesList(4);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return OnBoardingSlider(
      headerBackgroundColor: AppTheme.scaffoldBackgroundColor,
      pageBackgroundColor: AppTheme.scaffoldBackgroundColor,
      centerBackground: true,
      finishButtonText: "Let's Go!!!",
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: AppTheme.primaryRedAccentColor,
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
        Image.asset(_images[0]),
        Image.asset(_images[1]),
        Image.asset(_images[2]),
        SizedBox()
      ],
      totalPage: 4,
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
                height: size.height * 0.4,
              ),
              Container(
                width: size.width * 0.75,
                alignment: Alignment.center,
                child: Text(
                  'WARNING!!',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "The app is using test API so you will be able to use all the features of the app but won't be able to view or register in actual Paridhi events.",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 15),
              Text(
                "This app is solely built as my personal project and the official Megatronix app can be downloaded from below.",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  try {
                    launchUrl(Uri.parse(
                        'https://megatronix-apk-release.vercel.app/'));
                  } catch (e) {
                    AppErrorHandler.handleError(
                      context,
                      'Error',
                      'Failed to launch url. Please check your network connection',
                    );
                  }
                },
                child: Text(
                  'Download Official App',
                  style: TextStyle(
                    color: AppTheme.primaryGreenAccentColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.primaryGreenAccentColor,
                    decorationThickness: 2,
                    decorationStyle: TextDecorationStyle.double,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 350,
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
                    activeColor: AppTheme.primaryRedAccentColor,
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
          height: size.height,
          padding: EdgeInsets.symmetric(horizontal: 16),
          margin: EdgeInsets.only(bottom: 80),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(_images[2]),
                SizedBox(
                  height: size.height * 0.42,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'How to pariticipate in Paridhi 2025?',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        ListTile(
                          title: const Text('Main Registration'),
                          subtitle: const Text(
                            'Navigate to Events > Paridhi > Main Registration to complete Paridhi 2025 registration to be able to participate in events.',
                            style:
                                TextStyle(fontSize: 12, fontFamily: 'Poppins'),
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
                            style:
                                TextStyle(fontSize: 12, fontFamily: 'Poppins'),
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
                            style:
                                TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                          ),
                          leading: Text(
                            '3. ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '[Tip]: You can always find the guide in the help section of the app.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
