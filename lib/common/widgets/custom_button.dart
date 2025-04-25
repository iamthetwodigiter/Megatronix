import 'package:flutter/material.dart';
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryRedAccentColor,
        elevation: 10,
        shadowColor: AppTheme.primaryRedAccentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
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
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
