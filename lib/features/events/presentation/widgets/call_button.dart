import 'package:flutter/material.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CallButton extends StatefulWidget {
  final String name;
  final String number;
  const CallButton({
    super.key,
    required this.name,
    required this.number,
  });

  @override
  State<CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<CallButton> {
  void _callCoordinator(String number) async {
    try {
      await launchUrl(Uri.parse('tel:+91$number'));
    } catch (e) {
      AppErrorHandler.handleError(
        context,
        'Error',
        'Failed to make a call to the coordiator',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '${widget.name}- ',
        ),
        GestureDetector(
          onTap: () {
            _callCoordinator(widget.number);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppTheme.darkBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: 5,
              children: [
                Text(
                  widget.number,
                  style: TextStyle(color: AppTheme.whiteBackground),
                ),
                Icon(
                  Icons.call,
                  size: 15,
                  color: AppTheme.primaryGreenAccentColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
