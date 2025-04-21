import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_image.dart';
import 'package:megatronix/features/team/presentation/pages/team_page.dart';
import 'package:megatronix/features/team/presentation/pages/web/team_web_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class TeamHomeCards extends StatefulWidget {
  final String title;
  final bool isDeveloperPage;
  final String photoUrl;
  final bool isWebPage;
  final double? height;
  final double? width;
  const TeamHomeCards({
    super.key,
    required this.title,
    required this.isDeveloperPage,
    required this.photoUrl,
    this.isWebPage = false,
    this.height,
    this.width,
  });

  @override
  State<TeamHomeCards> createState() => _TeamHomeCardsState();
}

class _TeamHomeCardsState extends State<TeamHomeCards> {
  String developerImage = '';
  String membersImage = '';

  List<Color> colorizeColors = [
    AppTheme.whiteBackground,
    AppTheme.primaryBlueAccentColor,
    AppTheme.darkBackground,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return widget.isWebPage
              ? TeamWebPage(isDeveloperPage: widget.isDeveloperPage)
              : TeamPage(isDeveloperPage: widget.isDeveloperPage);
        }));
      },
      child: Container(
        height: widget.isWebPage ? widget.height ?? size.height * 0.25 : 195,
        width: widget.isWebPage ? widget.width ?? size.width * 0.3 : size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              Colors.black.withAlpha(100),
              Colors.black.withAlpha(200),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CustomImage(
                image: widget.photoUrl,
                height: widget.isWebPage
                    ? widget.height ?? size.height * 0.25
                    : 195,
                width: widget.isWebPage
                    ? widget.width ?? size.width * 0.3
                    : size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedTextKit(
                isRepeatingAnimation: true,
                repeatForever: true,
                pause: Duration.zero,
                animatedTexts: [
                  ColorizeAnimatedText(
                    widget.title,
                    textStyle: TextStyle(
                      fontFamily: 'DaggerSquare',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: colorizeColors,
                  ),
                ],
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
