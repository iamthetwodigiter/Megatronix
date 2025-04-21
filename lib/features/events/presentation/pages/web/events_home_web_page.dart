import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/core/utils/responsive_utils.dart';
import 'package:megatronix/features/events/presentation/pages/web/events_web_page.dart';
import 'package:megatronix/features/events/presentation/widgets/event_home_page_cards.dart';
import 'package:megatronix/theme/app_theme.dart';

class EventsHomeWebPage extends StatefulWidget {
  final bool isMainPage;
  const EventsHomeWebPage({
    super.key,
    this.isMainPage = true,
  });

  @override
  State<EventsHomeWebPage> createState() => _EventsHomeWebPageState();
}

class _EventsHomeWebPageState extends State<EventsHomeWebPage> {
  List<Color> colorizeColors = [
    AppTheme.whiteBackground,
    AppTheme.errorColor,
    AppTheme.primaryBlueAccentColor,
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isSmallScreen = ResponsiveBreakpoints.isMobile(width);

    return CustomWebScaffold(
      title: 'Megatronix Events',
      isMainPage: widget.isMainPage,
      child: Center(
        child: Flex(
          direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Event Cards with responsive sizing
            Flexible(
              child: SizedBox(
                width: isSmallScreen ? width * 0.75 : width * 0.3,
                child: EventHomePageCards(
                  title: 'WorkShop 2025',
                  description: 'App and Web Development Workshop',
                  navigateTo: CustomWebScaffold(
                    title: 'WorkShop 2025',
                    child: _buildComingSoonAnimation(),
                  ),
                  imageUrl: 'assets/images/workshop_poster.jpg',
                  isWebPage: true,
                  width: isSmallScreen ? width * 0.75 : width * 0.3,
                ),
              ),
            ),
            SizedBox(
              height: isSmallScreen ? 20 : 0,
              width: isSmallScreen ? 0 : 20,
            ),
            Flexible(
              child: SizedBox(
                width: isSmallScreen ? width * 0.75 : width * 0.3,
                child: EventHomePageCards(
                  title: 'TechXtra 2025',
                  description: 'Intra-College Tech Fest of MSIT',
                  navigateTo: CustomWebScaffold(
                    title: 'TechXtra 2025',
                    child: _buildComingSoonAnimation(),
                  ),
                  imageUrl: 'assets/images/techxtra_poster.jpg',
                  isWebPage: true,
                  width: isSmallScreen ? width * 0.75 : width * 0.3,
                ),
              ),
            ),
            SizedBox(
              height: isSmallScreen ? 20 : 0,
              width: isSmallScreen ? 0 : 20,
            ),
            Flexible(
              child: SizedBox(
                width: isSmallScreen ? width * 0.75 : width * 0.3,
                child: EventHomePageCards(
                  title: 'Paridhi 2025',
                  description: 'Inter-College Tech Fest of MSIT',
                  navigateTo: EventsWebPage(),
                  imageUrl: 'assets/images/paridhi_poster.jpg',
                  isWebPage: true,
                  width: isSmallScreen ? width * 0.75 : width * 0.3,
                ),
              ),
            ),
            if (!widget.isMainPage) SizedBox(height: isSmallScreen ? 20 : 0),
          ],
        ),
      ),
    );
  }

  // Helper method to reduce code duplication
  Widget _buildComingSoonAnimation() {
    return Center(
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
    );
  }
}
