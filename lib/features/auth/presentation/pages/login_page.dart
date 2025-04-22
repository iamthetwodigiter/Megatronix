import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/pages/landing_page.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_header.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:megatronix/features/auth/presentation/pages/password_reset_page.dart';
import 'package:megatronix/features/auth/presentation/pages/signup_page.dart';
import 'package:megatronix/features/auth/providers/auth_providers.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      AppErrorHandler.handleError(
        context,
        'Invalid Email',
        'Enter a valid email address',
      );
    }

    if (_passwordController.text.length < 6 ||
        _passwordController.text.length > 64) {
      AppErrorHandler.handleError(
        context,
        'Invalid Password',
        'Password length must be between 6 and 64',
      );
    }

    if (_emailController.text.isNotEmpty &&
        _emailController.text.contains('@') &&
        _passwordController.text.length >= 6 &&
        _passwordController.text.length <= 64) {
      ref.read(authNotifierProvider.notifier).loginUser(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final availableHeight =
        size.height - MediaQuery.of(context).viewInsets.bottom;

    ref.listen<AuthState>(authNotifierProvider, (previous, current) {
      if (current.user != null && context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LandingPage(),
          ),
          (route) => false,
        );
        AppErrorHandler.handleError(
          context,
          'Login Successful',
          'Welcome to Paridhi 2025',
          type: ToastificationType.success,
        );
        return;
      }

      if (current.error != null && context.mounted) {
        if (current.error!.type == AuthErrorType.login && context.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppErrorHandler.handleError(
              context,
              'LogIn Error',
              current.error!.message,
            );
            
          });
          return;
        }
      }
    });

    return CustomScaffold(
      title: 'Login',
      isDisabled: true,
      
      secondaryImage: 'assets/images/background/home.jpg',
      customOpacity: 0.6,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LottieBuilder.asset(
                'assets/animations/auth.json',
                height: availableHeight * 0.32,
              ),
              Column(
                children: [
                  CustomHeader(title: 'Log In'),
                  SizedBox(height: 15),
                  CustomTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Password',
                    prefixIcon: Icons.key,
                    controller: _passwordController,
                    isPassword: true,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text("Forgot Password?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PasswordResetPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Reset',
                          style:
                              TextStyle(color: AppTheme.primaryBlueAccentColor),
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    onPressed: () {
                      _logIn();
                    },
                    buttonText: 'Log In',
                  ),
                ],
              ),
              SizedBox(height: availableHeight * 0.125),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text("Didn't register yet?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: AppTheme.primaryBlueAccentColor),
                    ),
                  ),
                ],
              ),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
