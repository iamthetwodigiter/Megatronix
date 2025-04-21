import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/auth/presentation/pages/verify_email_page.dart';
import 'package:megatronix/features/auth/presentation/pages/web/verify_email_web_page.dart';
import 'package:megatronix/features/event_registration/presentation/pages/event_by_gid_page.dart';
import 'package:megatronix/features/event_registration/presentation/pages/web/event_by_gid_web_page.dart';
import 'package:megatronix/features/main_registration/presentation/pages/main_registration_page.dart';
import 'package:megatronix/features/main_registration/presentation/pages/web/main_registration_web_page.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class ProfileTiles extends StatelessWidget {
  final String leading;
  final dynamic title;
  final bool isGID;
  final bool isVerifiedField;
  final bool isWebPage;
  const ProfileTiles({
    super.key,
    required this.leading,
    required this.title,
    this.isGID = false,
    this.isVerifiedField = false,
    this.isWebPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWebPage ? 24 : 15,
        vertical: isWebPage ? 8 : 5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: isWebPage ? 150 : 125,
            padding: EdgeInsets.only(left: isWebPage ? 8 : 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$leading: ',
              style: TextStyle(
                fontSize: isWebPage ? 18 : 16,
                fontWeight: isWebPage ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          !isVerifiedField
              ? Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isGID
                        ? (title as List).isEmpty
                            ? GestureDetector(
                                onTap: () {
                                  AppErrorHandler.handleError(
                                    context,
                                    'Registration Required',
                                    'You need to complete main registration to get your GID',
                                    type: ToastificationType.warning,
                                  );
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return isWebPage
                                            ? MainRegistrationWebPage()
                                            : MainRegistrationPage();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  'Click me to Register',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryBlueAccentColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  itemCount: (title as List).length,
                                  itemBuilder: (context, index) {
                                    final gid =
                                        (title as List).elementAt(index);
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return isWebPage
                                                  ? EventByGidWebPage(gid: gid)
                                                  : EventByGidPage(gid: gid);
                                            },
                                          ),
                                        );
                                      },
                                      onLongPress: () {
                                        try {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: gid.toString(),
                                            ),
                                          );
                                          AppErrorHandler.handleError(
                                              context,
                                              'Success',
                                              'GID ${gid.toString()} copied to clipboard',
                                              type: ToastificationType.success);
                                        } catch (e) {
                                          AppErrorHandler.handleError(
                                            context,
                                            'Error',
                                            'Failed to copy GID',
                                          );
                                        }
                                      },
                                      child: Text(
                                        gid,
                                        style: TextStyle(
                                          color:
                                              AppTheme.primaryBlueAccentColor,
                                          fontWeight: FontWeight.w300,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              AppTheme.primaryBlueAccentColor,
                                          decorationThickness: 0.5,
                                          decorationStyle:
                                              TextDecorationStyle.double,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                        : Text(
                            title!.isEmpty ? 'N/A' : title!,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (title != 'Verified') {
                        AppErrorHandler.handleError(
                          context,
                          'Verify Email',
                          'Double tap to verify your email',
                          type: ToastificationType.warning,
                        );
                      }
                    },
                    onDoubleTap: () {
                      if (title != 'Verified') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return isWebPage
                                  ? VerifyEmailWebPage()
                                  : VerifyEmailPage();
                            },
                          ),
                        );
                      }
                    },
                    child: Text(
                      title!,
                      style: TextStyle(
                        color: title! == 'Verified'
                            ? AppTheme.primaryGreenAccentColor
                            : AppTheme.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
