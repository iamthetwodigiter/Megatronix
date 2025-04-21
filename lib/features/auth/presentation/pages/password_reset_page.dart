import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_header.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:megatronix/features/auth/presentation/pages/login_page.dart';
import 'package:megatronix/features/auth/providers/auth_providers.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class PasswordResetPage extends ConsumerStatefulWidget {
  const PasswordResetPage({super.key});

  @override
  ConsumerState<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends ConsumerState<PasswordResetPage> {
  late TextEditingController _emailController;
  late TextEditingController _verificationTokenController;
  late TextEditingController _passwordController;
  bool _isTokenSent = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _verificationTokenController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _verificationTokenController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _requestPasswordResetOTP() {
    if (_emailController.text.isEmpty ||
        !_emailController.text.contains('@') ||
        !_emailController.text.contains('.com')) {
      AppErrorHandler.handleError(
        context,
        'Invalid Email',
        'Enter a valid email address',
      );
    }
    ref
        .read(authNotifierProvider.notifier)
        .resetPasswordRequest(_emailController.text.trim());
  }

  void _verifyPasswordResetOTP() {
    if (_verificationTokenController.text.isEmpty) {
      AppErrorHandler.handleError(
        context,
        'Invalid Token',
        'Enter a valid verification token',
      );
    }
    ref.read(authNotifierProvider.notifier).validateToken(
          _verificationTokenController.text.trim(),
        );
  }

  void _confirmResetPassword() {
    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 6 ||
        _passwordController.text.length > 64) {
      AppErrorHandler.handleError(
        context,
        'Invalid Password',
        'Password length must be between 6 and 64',
      );
    }

    ref.read(authNotifierProvider.notifier).confirmResetPassword(
          _verificationTokenController.text.trim(),
          _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final authState = ref.watch(authNotifierProvider);
    final availableHeight =
        size.height - MediaQuery.of(context).viewInsets.bottom;

    ref.listen<AuthState>(authNotifierProvider, (previous, current) {
      if (current.message?.message ==
          "Password reset instructions sent successfully to your email") {
        setState(() {
          _isTokenSent = true;
        });
        AppErrorHandler.handleError(
          context,
          'Token Sent',
          'Password Reset Token sent successfully to your email',
          type: ToastificationType.success,
        );

        return;
      }

      if (current.message?.message == "Token is valid") {
        setState(() {
          _isVerified = true;
        });
        AppErrorHandler.handleError(
          context,
          'Token Verified',
          'Create a new password',
          type: ToastificationType.success,
        );

        return;
      }

      if (current.message?.message == "Token is invalid") {
        AppErrorHandler.handleError(
          context,
          'Token Invalid',
          'Please enter a valid token',
        );

        return;
      }

      if (current.message?.message == "Password reset successful") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LogInPage()),
            (route) => false);
        AppErrorHandler.handleError(
          context,
          'Password Reset',
          'New password set successfully\nPlease login',
          type: ToastificationType.success,
        );

        return;
      }

      if (current.error != null && context.mounted && !current.isLoading) {
        AppErrorHandler.handleError(
          context,
          'Error',
          current.error!.message,
        );

        return;
      }
    });

    return CustomScaffold(
      title: 'Password Reset',
      isDisabled: true,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                LottieBuilder.asset(
                  'assets/animations/password_reset.json',
                  height: availableHeight * 0.325,
                ),
                SizedBox(height: 15),
                Column(
                  spacing: 15,
                  children: [
                    CustomHeader(
                      title: 'Reset Password',
                      fontSize: 24,
                    ),
                    Text(
                      "Enter your registered email to get account's password reset token",
                      style: TextStyle(
                        color: AppTheme.primaryBlueAccentColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (!_isVerified)
                      CustomTextField(
                        hintText: 'Email',
                        prefixIcon: Icons.email,
                        controller: _emailController,
                        enabled: !_isTokenSent,
                      ),
                    if (_isTokenSent)
                      CustomTextField(
                        hintText: 'Verification Token',
                        prefixIcon: Icons.key,
                        controller: _verificationTokenController,
                        enabled: !_isVerified,
                      ),
                    if (_isVerified)
                      CustomTextField(
                        hintText: 'New Password',
                        prefixIcon: Icons.key,
                        isPassword: true,
                        controller: _passwordController,
                      ),
                    CustomButton(
                      onPressed: () {
                        _isVerified
                            ? _confirmResetPassword()
                            : _isTokenSent
                                ? _verifyPasswordResetOTP()
                                : _requestPasswordResetOTP();
                      },
                      buttonText: _isVerified
                          ? 'Set Password'
                          : _isTokenSent
                              ? 'Verify Token'
                              : 'Send Token',
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text("Want to take chances?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LogInPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Text(
                        'Log In',
                        style:
                            TextStyle(color: AppTheme.primaryBlueAccentColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (authState.isLoading)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.scaffoldBackgroundColor.withAlpha(235),
                      ),
                    ],
                  ),
                  child: LoadingWidget(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
