import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/features/events/presentation/pages/events_page.dart';
import 'package:megatronix/features/events/presentation/widgets/event_home_page_cards.dart';
import 'package:megatronix/theme/app_theme.dart';

class EventsHomePage extends StatefulWidget {
  const EventsHomePage({super.key});

  @override
  State<EventsHomePage> createState() => _EventsHomePageState();
}

class _EventsHomePageState extends State<EventsHomePage> {
  List<Color> colorizeColors = [
    AppTheme.whiteBackground,
    AppTheme.errorColor,
    AppTheme.primaryBlueAccentColor,
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Events',
      isMainPage: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            EventHomePageCards(
              title: 'WorkShop 2025',
              description: 'App and Web Development Workshop',
              navigateTo: CustomScaffold(
                title: 'WorkShop 2025',
                child: Center(
                  child: AnimatedTextKit(
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    pause: Duration.zero,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Coming Soon...',
                        textStyle: TextStyle(
                          fontFamily: 'DaggerSquare',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: colorizeColors,
                      ),
                    ],
                    onTap: () {},
                  ),
                ),
              ),
              imageUrl: 'assets/images/workshop_poster.jpg',
            ),
            EventHomePageCards(
              title: 'TechXtra 2025',
              description: 'Intra-College Tech Fest of MSIT',
              navigateTo: CustomScaffold(
                title: 'TechXtra 2025',
                child: Center(
                  child: AnimatedTextKit(
                    isRepeatingAnimation: true,
                    repeatForever: true,
                    pause: Duration.zero,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Coming Soon...',
                        textStyle: TextStyle(
                          fontFamily: 'DaggerSquare',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        colors: colorizeColors,
                      ),
                    ],
                    onTap: () {},
                  ),
                ),
              ),
              imageUrl: 'assets/images/techxtra_poster.jpg',
            ),
            EventHomePageCards(
              title: 'Paridhi 2025',
              description: 'Inter-College Tech Fest of MSIT',
              navigateTo: EventsPage(),
              imageUrl: 'assets/images/paridhi_poster.jpg',
            ),
            SizedBox(height: 70)
          ],
        ),
      ),
    );
  }
}
