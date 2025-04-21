import 'package:flutter/material.dart';
import 'package:megatronix/theme/app_theme.dart';

class CustomRichtext extends StatefulWidget {
  final String title;
  final String subtitle;
  const CustomRichtext({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<CustomRichtext> createState() => _CustomRichtextState();
}

class _CustomRichtextState extends State<CustomRichtext> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontFamily: 'DaggerSquare'),
        children: [
          TextSpan(
            text: '${widget.title}: ',
            style: TextStyle(
              color: AppTheme.whiteBackground,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: widget.subtitle,
            style: TextStyle(
              color: AppTheme.dividerColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
