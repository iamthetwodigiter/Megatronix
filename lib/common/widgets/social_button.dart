import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButton extends StatefulWidget {
  final String url;
  final IconData? icon;
  final String? iconAsset;
  final String platform;
  final Color iconColor;
  final Color iconBgColor;
  final double iconSize;
  final bool isDisabled;
  const SocialButton({
    super.key,
    required this.url,
    this.icon,
    this.iconAsset,
    required this.platform,
    this.iconBgColor = AppTheme.primaryBlueAccentColor,
    this.iconColor = AppTheme.whiteBackground,
    this.iconSize = 30,
    this.isDisabled = false,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.isDisabled) {
          AppErrorHandler.handleError(
            context,
            'Error',
            'I do not use ${widget.platform}',
          );
          return;
        }
        try {
          await launchUrl(Uri.parse(widget.url),
              mode: LaunchMode.externalApplication);
        } catch (e) {
          AppErrorHandler.handleError(
            context,
            'Error',
            'Cannot launch ${widget.platform}',
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.icon != null
              ? widget.isDisabled
                  ? AppTheme.inactiveColor
                  : widget.iconBgColor
              : null,
          shape: BoxShape.circle,
        ),
        child: widget.icon != null
            ? HugeIcon(
                icon: widget.icon!,
                color: widget.iconColor,
                size: widget.iconSize,
              )
            : Image.asset(
                widget.iconAsset!,
                height: 45,
                width: 45,
              ),
      ),
    );
  }
}
