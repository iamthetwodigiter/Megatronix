import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/custom_image.dart';
import 'package:megatronix/features/team/presentation/pages/team_page.dart';
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
    AppTheme.primaryRedAccentColor,
    AppTheme.darkBackground,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return TeamPage(isDeveloperPage: widget.isDeveloperPage);
        }));
      },
      child: Container(
        height: widget.isWebPage ? widget.height ?? size.height * 0.25 : 195,
        width: widget.isWebPage ? widget.width ?? size.width * 0.3 : size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppTheme.blackBackground.withAlpha(150),
              blurRadius: 0,
              spreadRadius: 0,
              offset: Offset.zero,
            ),
          ],
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
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.transparentColor,
                    AppTheme.blackBackground.withAlpha(175),
                  ],
                ),
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
                      fontFamily: 'FiraCode',
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
