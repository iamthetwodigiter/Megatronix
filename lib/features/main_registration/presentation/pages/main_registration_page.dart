import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/auth/presentation/pages/login_page.dart';
import 'package:megatronix/features/auth/providers/auth_providers.dart';
import 'package:megatronix/features/main_registration/presentation/notifier/main_registration_notifier.dart';
import 'package:megatronix/features/main_registration/providers/main_registration_providers.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class MainRegistrationPage extends ConsumerStatefulWidget {
  const MainRegistrationPage({super.key});

  @override
  ConsumerState<MainRegistrationPage> createState() =>
      _MainRegistrationPageState();
}

class _MainRegistrationPageState extends ConsumerState<MainRegistrationPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).checkAuth();
    });
  }

  void _register(String email) {
    ref.read(mainRegistrationNotifierProvider.notifier).mainRegistration(email);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final mainRegistrationState = ref.watch(mainRegistrationNotifierProvider);

    ref.listen<MainRegistrationState>(mainRegistrationNotifierProvider,
        (previous, current) {
      if (current.mainRegistrationEntity != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppErrorHandler.handleError(
            context,
            'Congratulations',
            'Your Paridhi 2025 registration is done successfully',
            type: ToastificationType.success,
          );
        });
        return;
      }
      if (current.error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppErrorHandler.handleError(
            context,
            'Error',
            current.error!,
          );
        });
        return;
      }
    });

    if (authState.isLoading || mainRegistrationState.isLoading) {
      return CustomScaffold(
        title: 'Main Registration',
        child: Center(
          child: LoadingWidget(),
        ),
      );
    }

    if (authState.user == null) {
      return CustomScaffold(
        title: 'Main Registration',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                'You need to login to be able to register in Paridhi 2025',
                style: const TextStyle(
                  color: AppTheme.primaryRedAccentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              CustomButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return LogInPage();
                      },
                    ),
                  );
                },
                buttonText: 'LogIn',
              ),
            ],
          ),
        ),
      );
    }

    if (authState.user != null) {
      return CustomScaffold(
        title: 'Main Registration',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Register yourself for Paridhi 2025 and participate in exciting events and get yourself amazing prizes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            CustomTextField(
              hintText: 'Email',
              prefixIcon: Icons.email,
              controller: TextEditingController(text: authState.user!.email),
              enabled: false,
            ),
            SizedBox(height: 20),
            const Text(
              'Your Paridhi 2025 registration will be done against this email, make sure you signup with correct email',
              style: TextStyle(
                fontWeight: FontWeight.w100,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CustomButton(
              onPressed: () {
                _register(authState.user!.email);
              },
              buttonText: 'Register',
            ),
            const Spacer(flex: 3),
          ],
        ),
      );
    }

    return CustomScaffold(
      title: 'Main Registration',
      child: Center(
        child: LoadingWidget(),
      ),
    );
  }
}
