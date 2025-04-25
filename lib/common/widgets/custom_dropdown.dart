import 'package:flutter/material.dart';
import 'package:megatronix/theme/app_theme.dart';

class CustomDropdown extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<DropdownMenuEntry> dropDownEntries;
  final TextEditingController controller;
  final Function(String) onValueChanged;
  const CustomDropdown({
    super.key,
    required this.icon,
    required this.label,
    required this.dropDownEntries,
    required this.controller,
    required this.onValueChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return DropdownMenu(
      menuHeight: size.height * 0.4,
      width: size.width - 30,
      label: Text(
        widget.label,
        style: TextStyle(
          color: AppTheme.whiteBackground,
        ),
      ),
      controller: widget.controller,
      leadingIcon: Icon(
        widget.icon,
        color: AppTheme.primaryRedAccentColor,
      ),
      trailingIcon: Icon(
        Icons.arrow_drop_down,
        color: AppTheme.primaryRedAccentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryRedAccentColor),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          AppTheme.scaffoldBackgroundColor,
        ),
      ),
      onSelected: (value) {
        if (value != null) {
          setState(() {
            widget.controller.text = value;
          });
          widget.onValueChanged.call(value);
        }
      },
      dropdownMenuEntries: widget.dropDownEntries,
    );
  }
}
