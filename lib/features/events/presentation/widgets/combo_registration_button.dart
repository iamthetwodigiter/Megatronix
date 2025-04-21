import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/features/event_registration/presentation/pages/combo_registration_page.dart';
import 'package:megatronix/features/event_registration/presentation/pages/web/combo_registration_web_page.dart';
import 'package:megatronix/features/events/domain/entities/combo_entity.dart';
import 'package:megatronix/theme/app_theme.dart';

class ComboRegistrationButton extends StatefulWidget {
  final bool registrationOpen;
  final ComboEntity combo;
  final bool isWebPage;
  const ComboRegistrationButton({
    super.key,
    required this.registrationOpen,
    required this.combo,
    this.isWebPage = false,
  });

  @override
  State<ComboRegistrationButton> createState() =>
      _ComboRegistrationButtonState();
}

class _ComboRegistrationButtonState extends State<ComboRegistrationButton> {
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        if (widget.registrationOpen) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return widget.isWebPage
                ? ComboRegistrationWebPage(combo: widget.combo)
                : ComboRegistrationPage(
                    combo: widget.combo,
                  );
          }));
        }
      },
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.darkBackground,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: widget.registrationOpen
                ? AppTheme.primaryGreenAccentColor
                : AppTheme.errorColor,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(5),
          child: widget.registrationOpen
              ? Text(
                  'Register Now',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.primaryGreenAccentColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : BlinkText(
                  'Registration Closed',
                  beginColor: AppTheme.errorColor,
                  endColor: AppTheme.darkBackground,
                  duration: Duration(milliseconds: 1000),
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
