import 'package:flutter/material.dart';
import 'package:megatronix/theme/app_theme.dart';

class EventHomePageCards extends StatelessWidget {
  final String title;
  final String description;
  final Widget navigateTo;
  final String imageUrl;
  final bool isWebPage;
  final double? height;
  final double? width;
  const EventHomePageCards({
    super.key,
    required this.title,
    required this.description,
    required this.navigateTo,
    required this.imageUrl,
    this.isWebPage = false,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // Calculate responsive dimensions
    final double cardHeight = isWebPage
        ? height ?? 350 // fixed height for web
        : 175.0; // fixed height for mobile
    final double cardWidth = isWebPage
        ? width ?? size.width * 0.28 // fixed width for web
        : size.width; // full width for mobile

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust text sizes based on available width
        final double titleSize = constraints.maxWidth > 600 ? 28 : 25;
        final double descriptionSize = constraints.maxWidth > 600 ? 18 : 16;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return navigateTo;
              }));
            },
            child: Container(
              height: cardHeight,
              width: cardWidth,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppTheme.primaryBlueAccentColor,
                  width: 2,
                ),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.blackBackground.withAlpha(100),
                    AppTheme.blackBackground.withAlpha(255),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.blackBackground.withAlpha(150),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: cardHeight,
                      width: cardWidth,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.blackBackground.withAlpha(200),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.all(constraints.maxWidth > 600 ? 20 : 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: AppTheme.whiteBackground,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            color: AppTheme.whiteBackground,
                            fontSize: descriptionSize,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
