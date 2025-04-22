import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_image.dart';
import 'package:megatronix/core/utils/responsive_utils.dart';
import 'package:megatronix/features/events/presentation/pages/domain_events_page.dart';
import 'package:megatronix/features/events/presentation/pages/web/domain_events_web_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class DomainEventsCards extends StatefulWidget {
  final String domain;
  final String posterUrl;
  final bool isWebPage;
  final double? height;
  final double? width;
  const DomainEventsCards({
    super.key,
    required this.domain,
    required this.posterUrl,
    this.isWebPage = false,
    this.height,
    this.width,
  });

  @override
  State<DomainEventsCards> createState() => _DomainEventsCardsState();
}

class _DomainEventsCardsState extends State<DomainEventsCards> {
  List<Color> colorizeColors = [
    AppTheme.whiteBackground,
    AppTheme.primaryBlueAccentColor,
    AppTheme.darkBackground,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = ResponsiveBreakpoints.isMobile(size.width);
    final isTablet = ResponsiveBreakpoints.isTablet(size.width);

    // Calculate responsive dimensions
    final double cardWidth = widget.width ??
        (widget.isWebPage
            ? (isSmallScreen
                ? size.width * 0.9
                : isTablet
                    ? size.width * 0.45
                    : size.width * 0.3)
            : size.width);

    final double cardHeight = widget.height ??
        (widget.isWebPage
            ? (isSmallScreen
                ? 200
                : isTablet
                    ? 250
                    : 275)
            : 175);

    final double fontSize = isSmallScreen ? 24 : (isTablet ? 28 : 32);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return widget.isWebPage
                ? DomainEventsWebPage(title: widget.domain)
                : DomainEventsPage(title: widget.domain);
          }));
        },
        child: Container(
          height: cardHeight,
          width: cardWidth,
          margin: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 0 : 15,
            horizontal: isSmallScreen ? 0 : 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 25),
            border: Border.all(
              color: AppTheme.primaryBlueAccentColor,
              width: isSmallScreen ? 1 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.blackBackground.withAlpha(100),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 25),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomImage(
                  image: widget.posterUrl,
                  width: widget.width,
                  height: widget.height,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: isSmallScreen ? 5 : 20,
                    ).copyWith(
                      left: isSmallScreen ? 10 : 15,
                      right: isSmallScreen ? 10 : 15,
                    ),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      repeatForever: false,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          widget.domain,
                          textStyle: TextStyle(
                            fontFamily: 'DaggerSquare',
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          colors: colorizeColors,
                        ),
                      ],
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
