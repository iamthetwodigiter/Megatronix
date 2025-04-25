import 'package:flutter/material.dart';
import 'package:megatronix/core/utils/util_functions.dart';
import 'package:megatronix/theme/app_theme.dart';

class CustomHeader extends StatefulWidget {
  final String title;
  final double fontSize;
  const CustomHeader({
    super.key,
    required this.title,
    this.fontSize = 35,
  });

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  final String _image = UtilFunctions.getHeaderImage();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 75,
          width: size.width,
          decoration: BoxDecoration(
            color: AppTheme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppTheme.primaryRedAccentColor,
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
        Positioned(
          top: -35,
          child: Image.asset(
            _image,
            height: 100,
          ),
        ),
      ],
    );
  }
}
