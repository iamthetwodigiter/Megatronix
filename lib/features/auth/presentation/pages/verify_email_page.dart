import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_header.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/auth/domain/entities/user_entity.dart';
import 'package:megatronix/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:megatronix/features/auth/providers/auth_providers.dart';
import 'package:megatronix/features/profile/presentation/pages/create_profile_page.dart';
import 'package:megatronix/features/profile/presentation/pages/user_profile_page.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool _isNavigating = false;
  bool _otpSent = false;

  Timer? _otpValidityTimer;
  Timer? _resendCooldownTimer;
  final List<int> _resendSeconds = [180, 600, 1800, 6000, 12000];
  int _currentResendIndex = 0;
  int _remainingValiditySeconds = 600;
  int _remainingResendSeconds = 0;
  bool get canResendOTP => _remainingResendSeconds <= 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_otpSent) {
        _sendEmailVerificationOTP();
        _startOTPValidityTimer();
        _startResendCooldown();
        _otpSent = true;
      }
    });
  }

  @override
  void dispose() {
    _otpValidityTimer?.cancel();
    _resendCooldownTimer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startOTPValidityTimer() {
    _otpValidityTimer?.cancel();
    _remainingValiditySeconds = 600;
    _otpValidityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingValiditySeconds > 0) {
        setState(() {
          _remainingValiditySeconds--;
        });
      } else {
        timer.cancel();

        for (var controller in _otpControllers) {
          controller.clear();
        }

        if (mounted) {
          AppErrorHandler.handleError(
            context,
            'OTP Expired',
            'Please request a new OTP',
          );
        }
      }
    });
  }

  void _startResendCooldown() {
    _resendCooldownTimer?.cancel();
    _remainingResendSeconds = _resendSeconds[_currentResendIndex];
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingResendSeconds > 0) {
        setState(() {
          _remainingResendSeconds--;
        });
      } else {
        timer.cancel();

        setState(() {});
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _sendEmailVerificationOTP() {
    final authState = ref.read(authNotifierProvider);
    if (authState.user != null) {
      ref
          .read(authNotifierProvider.notifier)
          .sendEmailVerificationOTP(authState.user!.email);
    }
  }

  void _resentEmailVerificationOTP(String email) {
    if (!canResendOTP) return;

    _currentResendIndex =
        (_currentResendIndex + 1).clamp(0, _resendSeconds.length - 1);
    ref.read(authNotifierProvider.notifier).resendEmailVerificationOTP(email);

    _startOTPValidityTimer();

    _startResendCooldown();

    for (var controller in _otpControllers) {
      controller.clear();
    }
  }

  void _verifyEmailVerificationOTP(String email) {
    if (_isNavigating) return;

    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      AppErrorHandler.handleError(
        context,
        'Invalid OTP',
        'Please enter all 6 digits',
      );
      return;
    }

    ref
        .read(authNotifierProvider.notifier)
        .verifyEmailVerificationOTP(email, otp);
    AppErrorHandler.handleError(
      context,
      'Verifying...',
      'Please wait while we verify your OTP\n[Do not press multiple times]',
      type: ToastificationType.info,
    );
  }

  void _handleNavigation(UserEntity user) {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppErrorHandler.handleError(
        context,
        'Account Verified Successfully',
        user.profileCreated
            ? 'Welcome back!'
            : 'Please complete your profile creation',
        type: ToastificationType.success,
      );

      if (user.profileCreated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UserProfilePage(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CreateProfilePage(user: user),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final authState = ref.watch(authNotifierProvider);

    if (authState.isLoading) {
      return CustomScaffold(
        title: 'SignUp',
        customOpacity: 0.6,
        isDisabled: true,
        child: Stack(
          children: [
            RotatedBox(
              quarterTurns: -1,
              child: Opacity(
                opacity: 0.6,
                child: LottieBuilder.asset(
                  'assets/animations/background.json',
                  height: size.width,
                  width: size.height,
                  frameRate: FrameRate(30),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: LoadingWidget(),
            ),
          ],
        ),
      );
    }

    ref.listen<AuthState>(authNotifierProvider, (previous, current) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authNotifierProvider.notifier).resetState();
      });
      if (current.isLoading || current.user == null) return;

      if (current.message?.message == 'OTP verified successfully' &&
          current.user != null &&
          context.mounted &&
          !_isNavigating) {
        _handleNavigation(authState.user!);
        return;
      }

      if (current.error != null &&
          current.error!.type == AuthErrorType.otp &&
          context.mounted) {
        setState(() {
          _isNavigating = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppErrorHandler.handleError(
            context,
            'Invalid OTP',
            'Please enter a valid verification OTP',
          );
        });
        return;
      }
    });

    return CustomScaffold(
      title: 'Verify Email',
      customOpacity: 0.6,
      isDisabled: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.15),
            Image.asset('assets/images/among_us_bg.png'),
            SizedBox(height: size.height * 0.15),
            Column(
              spacing: 15,
              children: [
                CustomHeader(
                  title: 'Verify Email',
                  fontSize: 28,
                ),
                Text(
                  'Please Enter OTP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => Container(
                        height: 45,
                        width: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.primaryRedAccentColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          cursorColor: AppTheme.primaryRedAccentColor,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.length == 1 && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OTP valid for: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.whiteBackground,
                        ),
                      ),
                      Text(
                        _formatTime(_remainingValiditySeconds),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _remainingValiditySeconds > 0
                              ? AppTheme.whiteBackground
                              : AppTheme.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Please verify your email to receive event confirmations and updates",
                  style: TextStyle(
                    color: AppTheme.primaryGreenAccentColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                CustomButton(
                  onPressed: () {
                    _verifyEmailVerificationOTP(authState.user!.email);
                  },
                  buttonText: 'Verify',
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Didn\'t receive OTP?'),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: canResendOTP
                      ? () => _resentEmailVerificationOTP(authState.user!.email)
                      : null,
                  child: Text(
                    canResendOTP
                        ? 'Resend OTP'
                        : 'Wait ${_formatTime(_remainingResendSeconds)}',
                    style: TextStyle(
                      color: canResendOTP
                          ? AppTheme.primaryRedAccentColor
                          : AppTheme.primaryGreenAccentColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
