import 'package:flutter/material.dart';
import 'package:megatronix/core/utils/responsive_utils.dart';
import 'package:megatronix/theme/app_theme.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool isWebPage;
  final double? width;
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isWebPage = false,
    this.width,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = ResponsiveBreakpoints.isMobile(size.width);
    final isTablet = ResponsiveBreakpoints.isTablet(size.width);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryBlueAccentColor,
        elevation: isSmallScreen ? 5 : 10,
        fixedSize: widget.isWebPage
            ? Size(
                widget.width ??
                    (isSmallScreen
                        ? size.width * 0.9
                        : isTablet
                            ? size.width * 0.6
                            : size.width / 2.75),
                isSmallScreen ? 45 : 50,
              )
            : null,
        shadowColor: AppTheme.primaryBlueAccentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 24,
          vertical: isSmallScreen ? 8 : 12,
        ),
        enableFeedback: true,
      ),
      onPressed: () {
        widget.onPressed();
      },
      child: Text(
        widget.buttonText,
        style: TextStyle(
          color: AppTheme.whiteBackground,
          fontSize: isSmallScreen ? 16 : 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
