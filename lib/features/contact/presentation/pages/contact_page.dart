import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/contact/presentation/notifier/contact_notifier.dart';
import 'package:megatronix/features/contact/provider/contact_provider.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  ConsumerState<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _contactController = TextEditingController();
    _queryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  void _openUrl(String url, String platform) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      AppErrorHandler.handleError(
        context,
        'Error',
        'Cannot launch $platform',
      );
    }
  }

  void _createQuery() {
    if (_nameController.text.isEmpty) {
      AppErrorHandler.handleError(
        context,
        'Invalid Name',
        'Name cannot be empty',
      );
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(_emailController.text)) {
      AppErrorHandler.handleError(
        context,
        'Invalid Email',
        'Please enter a valid email address',
      );
      return;
    }

    if (_contactController.text.isEmpty ||
        _contactController.text.length < 10) {
      AppErrorHandler.handleError(
        context,
        'Invalid Contact',
        'Please enter a valid phone number',
      );
      return;
    }

    if (_queryController.text.length <= 10) {
      AppErrorHandler.handleError(
        context,
        'Invalid Query',
        'Query must be greater than 10 characters',
      );
      return;
    }

    ref.read(contactNotifierProvider.notifier).createQuery(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          contact: _contactController.text.trim(),
          query: _queryController.text.trim(),
        );

    _nameController.clear();
    _emailController.clear();
    _contactController.clear();
    _queryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ContactState>(contactNotifierProvider, (previous, current) {
      if (!current.isLoading &&
          current.contactQuery != null &&
          context.mounted) {
        AppErrorHandler.handleError(
          context,
          'Success',
          'Query submitted successfully',
          type: ToastificationType.success,
        );
      }

      if (!current.isLoading && current.error != null && context.mounted) {
        AppErrorHandler.handleError(
          context,
          'Error',
          current.error!,
        );
      }
    });

    return CustomScaffold(
      title: 'Contact',
      isMainPage: true,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: SpeedDial(
          closedForegroundColor: AppTheme.primaryBlueAccentColor,
          openForegroundColor: AppTheme.primaryBlueAccentColor,
          closedBackgroundColor: AppTheme.primaryBlueAccentColor,
          openBackgroundColor: AppTheme.primaryBlueAccentColor,
          labelsBackgroundColor: AppTheme.primaryBlueAccentColor,
          speedDialChildren: [
            SpeedDialChild(
              child: Image.asset('assets/images/socials/facebook.png'),
              foregroundColor: AppTheme.darkBackground,
              backgroundColor: AppTheme.darkBackground,
              onPressed: () {
                _openUrl(
                  'https://www.facebook.com/share/g/1D4bRRtVtx/',
                  'Facebook',
                );
              },
              closeSpeedDialOnPressed: true,
            ),
            SpeedDialChild(
              child: Image.asset('assets/images/socials/instagram.png'),
              foregroundColor: AppTheme.darkBackground,
              backgroundColor: AppTheme.darkBackground,
              onPressed: () {
                _openUrl(
                  'https://www.instagram.com/megatronix__msit',
                  'Instagram',
                );
              },
              closeSpeedDialOnPressed: true,
            ),
            SpeedDialChild(
              child: Image.asset('assets/images/socials/youtube.png'),
              foregroundColor: AppTheme.darkBackground,
              backgroundColor: AppTheme.darkBackground,
              onPressed: () {
                _openUrl(
                  'https://www.youtube.com/@megatronixmsit921',
                  'YouTube',
                );
              },
              closeSpeedDialOnPressed: true,
            ),
          ],
          child: Icon(
            Icons.link,
            color: AppTheme.whiteBackground,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  LottieBuilder.asset(
                    'assets/animations/contact.json',
                    height: 175,
                  ),
                  CustomTextField(
                    hintText: 'Name',
                    prefixIcon: Icons.person,
                    controller: _nameController,
                  ),
                  CustomTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                  ),
                  CustomTextField(
                    hintText: 'Contact',
                    prefixIcon: Icons.phone,
                    controller: _contactController,
                    numberType: true,
                  ),
                  CustomTextField(
                    hintText: 'Your Query',
                    prefixIcon: Icons.question_answer,
                    controller: _queryController,
                    expands: true,
                  ),
                  CustomButton(
                    onPressed: () {
                      _createQuery();
                    },
                    buttonText: 'Send us your query',
                  ),
                  SizedBox(height: 90)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
