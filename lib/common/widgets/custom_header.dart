import 'package:flutter/material.dart';
import 'package:megatronix/theme/app_theme.dart';

class CustomHeader extends StatefulWidget {
  final String title;
  final double fontSize;
  final bool isWebPage;
  const CustomHeader({
    super.key,
    required this.title,
    this.fontSize = 35,
    this.isWebPage = false,
  });

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 75,
          width: widget.isWebPage ? size.width / 2.75 : size.width,
          decoration: BoxDecoration(
            color: AppTheme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppTheme.primaryBlueAccentColor,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
