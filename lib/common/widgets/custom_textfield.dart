import 'package:flutter/material.dart';
import 'package:megatronix/core/utils/responsive_utils.dart';
import 'package:megatronix/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool enabled;
  final bool numberType;
  final bool expands;
  final bool isWebPage;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    required this.prefixIcon,
    required this.controller,
    this.enabled = true,
    this.numberType = false,
    this.expands = false,
    this.isWebPage = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = ResponsiveBreakpoints.isMobile(size.width);
    final isTablet = ResponsiveBreakpoints.isTablet(size.width);

    return SizedBox(
      height: widget.expands ? (isSmallScreen ? 120 : 150) : null,
      width: widget.isWebPage
          ? (isSmallScreen
              ? size.width * 0.9
              : isTablet
                  ? size.width * 0.6
                  : size.width / 2.75)
          : size.width,
      child: TextField(
        controller: widget.controller,
        cursorColor: AppTheme.primaryBlueAccentColor,
        obscureText: widget.isPassword && !_isVisible,
        enabled: widget.enabled,
        expands: widget.expands,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: isSmallScreen ? 14 : 16,
        ),
        minLines: null,
        maxLines: widget.expands ? null : 1,
        textAlignVertical: TextAlignVertical.top,
        maxLength: widget.expands ? 1000 : null,
        keyboardType:
            widget.numberType ? TextInputType.number : TextInputType.text,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          maintainHintHeight: false,
          alignLabelWithHint: widget.expands,
          counterText: widget.expands
              ? '${widget.controller.text.length.toString()}/1000'
              : null,
          labelText: widget.hintText,
          labelStyle: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: AppTheme.whiteBackground,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: isSmallScreen ? 8 : 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryBlueAccentColor,
            ),
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryBlueAccentColor,
            ),
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
          ),
          prefixIcon: !widget.expands
              ? Icon(
                  widget.prefixIcon,
                  color: AppTheme.primaryBlueAccentColor,
                  size: isSmallScreen ? 20 : 24,
                )
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: Icon(
                    _isVisible ? Icons.visibility : Icons.visibility_off,
                    size: isSmallScreen ? 20 : 24,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
