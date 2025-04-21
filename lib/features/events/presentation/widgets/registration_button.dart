import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/core/utils/responsive_utils.dart';
import 'package:megatronix/features/event_registration/presentation/pages/event_registration_page.dart';
import 'package:megatronix/features/event_registration/presentation/pages/web/event_registration_web_page.dart';
import 'package:megatronix/theme/app_theme.dart';

class RegistrationButton extends StatefulWidget {
  final bool registrationOpen;
  final int eventID;
  final int minPlayers;
  final int maxPlayers;
  final bool isWebPage;

  const RegistrationButton({
    super.key,
    required this.registrationOpen,
    required this.eventID,
    required this.minPlayers,
    required this.maxPlayers,
    this.isWebPage = false,
  });

  @override
  State<RegistrationButton> createState() => _RegistrationButtonState();
}

class _RegistrationButtonState extends State<RegistrationButton> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = ResponsiveBreakpoints.isMobile(size.width);
    final isTablet = ResponsiveBreakpoints.isTablet(size.width);

    return GestureDetector(
      onTap: () {
        if (widget.registrationOpen) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return widget.isWebPage
                    ? EventRegistrationWebPage(
                        eventID: widget.eventID,
                        minPlayers: widget.minPlayers,
                        maxPlayers: widget.maxPlayers,
                      )
                    : EventRegistrationPage(
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
        height: isSmallScreen ? 45 : 50,
        width: widget.isWebPage
            ? (isSmallScreen
                ? size.width * 0.9
                : isTablet
                    ? size.width * 0.6
                    : size.width / 2.75)
            : null,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.darkBackground,
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 15),
          border: Border.all(
            color: widget.registrationOpen
                ? AppTheme.primaryGreenAccentColor
                : AppTheme.errorColor,
            width: isSmallScreen ? 1 : 1.5,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 4 : 5),
          child: widget.registrationOpen
              ? Text(
                  'Register Now',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 20,
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
                    fontSize: isSmallScreen ? 16 : 20,
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
