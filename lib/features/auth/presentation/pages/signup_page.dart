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
import 'package:megatronix/features/auth/presentation/pages/verify_email_page.dart';
import 'package:megatronix/features/auth/providers/auth_providers.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
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
    final availableHeight = size.height * 0.94;

    ref.listen<AuthState>(authNotifierProvider, (previous, current) {
      if (current.user != null && context.mounted && !_hasNavigated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _hasNavigated = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const VerifyEmailPage(),
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

    return CustomScaffold(
      title: 'SignUp',
      customOpacity: 0.6,
      isDisabled: true,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: availableHeight * 0.15),
              Image.asset('assets/images/among_us_bg.png'),
              SizedBox(height: availableHeight * 0.15),
              Column(
                children: [
                  CustomHeader(title: 'Sign Up'),
                  SizedBox(height: 15),
                  CustomTextField(
                    hintText: 'Name',
                    prefixIcon: Icons.person,
                    controller: _nameController,
                  ),
                  SizedBox(height: 10),
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
                  CustomButton(
                    onPressed: () {
                      _signUp();
                      setState(() {
                        _buttonClicked = true;
                      });
                    },
                    buttonText: 'Sign Up',
                  ),
                ],
              ),
              SizedBox(height: availableHeight * 0.125),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text('Already have an account?'),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LogInPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: AppTheme.primaryRedAccentColor,
                      ),
                    ),
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
