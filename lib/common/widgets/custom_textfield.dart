import 'package:flutter/material.dart';
import 'package:megatronix/theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool enabled;
  final bool numberType;
  final bool expands;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    required this.prefixIcon,
    required this.controller,
    this.enabled = true,
    this.numberType = false,
    this.expands = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: widget.expands ? 150 : null,
      width: size.width,
      child: TextField(
        controller: widget.controller,
        cursorColor: AppTheme.primaryRedAccentColor,
        obscureText: widget.isPassword && !_isVisible,
        enabled: widget.enabled,
        expands: widget.expands,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
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
            fontSize: 16,
            color: AppTheme.whiteBackground,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryRedAccentColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.primaryRedAccentColor,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: !widget.expands
              ? Icon(
                  widget.prefixIcon,
                  color: AppTheme.primaryRedAccentColor,
                  size: 24,
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
                    size: 24,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
