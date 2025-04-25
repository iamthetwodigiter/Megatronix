import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_image.dart';
import 'package:megatronix/features/events/presentation/pages/domain_events_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class DomainEventsCards extends StatefulWidget {
  final String domain;
  final String posterUrl;
  final double? height;
  final double? width;
  const DomainEventsCards({
    super.key,
    required this.domain,
    required this.posterUrl,
    this.height,
    this.width,
  });

  @override
  State<DomainEventsCards> createState() => _DomainEventsCardsState();
}

class _DomainEventsCardsState extends State<DomainEventsCards> {
  List<Color> colorizeColors = [
    AppTheme.whiteBackground,
    AppTheme.primaryRedAccentColor,
    AppTheme.darkBackground,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Calculate responsive dimensions
    final double cardWidth = widget.width ?? size.width;
    final double cardHeight = widget.height ?? 175;

    final double fontSize = 24;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return DomainEventsPage(title: widget.domain);
          }));
        },
        child: Container(
          height: cardHeight,
          width: cardWidth,
          margin: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppTheme.primaryRedAccentColor,
              width: 1.5,
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
            borderRadius: BorderRadius.circular(25),
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
                      bottom: 20,
                    ).copyWith(
                      left: 15,
                      right: 15,
                    ),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      repeatForever: false,
                      animatedTexts: [
                        ColorizeAnimatedText(
                          widget.domain,
                          textStyle: TextStyle(
                            fontFamily: 'FiraCode',
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
