import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/features/event_registration/presentation/pages/event_registration_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class RegistrationButton extends StatefulWidget {
  final bool registrationOpen;
  final int eventID;
  final int minPlayers;
  final int maxPlayers;
  const RegistrationButton({
    super.key,
    required this.registrationOpen,
    required this.eventID,
    required this.minPlayers,
    required this.maxPlayers,
  });

  @override
  State<RegistrationButton> createState() => _RegistrationButtonState();
}

class _RegistrationButtonState extends State<RegistrationButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.registrationOpen) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return EventRegistrationPage(
                  eventID: widget.eventID,
                  minPlayers: widget.minPlayers,
                  maxPlayers: widget.maxPlayers,
                );
              },
            ),
          );
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
            width: 1.5,
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
