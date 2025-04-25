import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/common/widgets/social_button.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/contact/presentation/notifier/contact_notifier.dart';
import 'package:megatronix/features/contact/provider/contact_provider.dart';
import 'package:toastification/toastification.dart';

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
                  SizedBox(height: 20),
                  Image.asset('assets/images/among_us_bg.png'),
                  SizedBox(height: 20),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialButton(
                        url: 'https://www.instagram.com/megatronix__msit',
                        iconAsset: 'assets/images/socials/instagram.png',
                        platform: 'Instagram',
                      ),
                      SocialButton(
                        url: 'https://www.facebook.com/groups/142028662672795',
                        iconAsset: 'assets/images/socials/facebook.png',
                        platform: 'Facebook',
                      ),
                      SocialButton(
                        url: 'https://www.youtube.com/@megatronixmsit921',
                        iconAsset: 'assets/images/socials/youtube.png',
                        platform: 'YouTube',
                      ),
                    ],
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
