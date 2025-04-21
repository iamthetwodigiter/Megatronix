import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_header.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:megatronix/features/auth/presentation/pages/web/login_web_page.dart';
import 'package:megatronix/features/auth/presentation/pages/web/verify_email_web_page.dart';
import 'package:megatronix/features/auth/providers/auth_providers.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class SignUpWebPage extends ConsumerStatefulWidget {
  const SignUpWebPage({super.key});

  @override
  ConsumerState<SignUpWebPage> createState() => _SignUpWebPageState();
}

class _SignUpWebPageState extends ConsumerState<SignUpWebPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _hasNavigated = false;
  bool _buttonClicked = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_nameController.text.isEmpty) {
      AppErrorHandler.handleError(
        context,
        'Invalid Name',
        'Name cannot be empty',
      );
      return;
    }
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      AppErrorHandler.handleError(
        context,
        'Invalid Email',
        'Enter a valid email address',
      );
      return;
    }
    if (_passwordController.text.length < 6 ||
        _passwordController.text.length > 64) {
      AppErrorHandler.handleError(
        context,
        'Invalid Password',
        'Password length must be between 6 and 64',
      );
      return;
    }

    ref.read(authNotifierProvider.notifier).registerUser(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, current) {
      if (current.user != null && context.mounted && !_hasNavigated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _hasNavigated = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const VerifyEmailWebPage(),
            ),
          );
          AppErrorHandler.handleError(
            context,
            'SignUp Successful',
            'Proceed to verify your email',
            type: ToastificationType.success,
          );
        });
        return;
      }

      if (_buttonClicked &&
          current.error != null &&
          current.error!.type == AuthErrorType.register &&
          context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppErrorHandler.handleError(
            context,
            'SignUp Error',
            current.error!.message,
          );
        });
        return;
      }
    });

    if (authState.isLoading) {
      return Scaffold(
        body: SafeArea(
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
        ),
      );
    }

    return CustomWebScaffold(
      title: 'SignUp',
      customOpacity: 0.6,
      isDisabled: true,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                'assets/animations/auth.json',
                height: size.height * 0.4,
              ),
              Column(
                children: [
                  CustomHeader(
                    title: 'Sign Up',
                    isWebPage: true,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    hintText: 'Name',
                    prefixIcon: Icons.person,
                    controller: _nameController,
                    isWebPage: true,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    isWebPage: true,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Password',
                    prefixIcon: Icons.key,
                    controller: _passwordController,
                    isPassword: true,
                    isWebPage: true,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text('Already have an account?'),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LogInWebPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: AppTheme.primaryBlueAccentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                    onPressed: () {
                      _signUp();
                      setState(() {
                        _buttonClicked = true;
                      });
                    },
                    buttonText: 'Sign Up',
                    isWebPage: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
