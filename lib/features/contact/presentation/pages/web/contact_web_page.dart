import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/contact/presentation/notifier/contact_notifier.dart';
import 'package:megatronix/features/contact/provider/contact_provider.dart';
import 'package:toastification/toastification.dart';

class ContactWebPage extends ConsumerStatefulWidget {
  final bool isMainPage;
  const ContactWebPage({
    super.key,
    this.isMainPage = true,
  });

  @override
  ConsumerState<ContactWebPage> createState() => _ContactWebPageState();
}

class _ContactWebPageState extends ConsumerState<ContactWebPage> {
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

    return CustomWebScaffold(
      title: 'Contact',
      isMainPage: widget.isMainPage,
      // floatingActionButton: ExpandableFab(
      //     openButtonBuilder: RotateFloatingActionButtonBuilder(
      //       child: const Icon(Icons.link),
      //       fabSize: ExpandableFabSize.small,
      //       foregroundColor: AppTheme.whiteBackground,
      //       backgroundColor: AppTheme.primaryBlueAccentColor,
      //       shape: const CircleBorder(),
      //     ),
      //     closeButtonBuilder: DefaultFloatingActionButtonBuilder(
      //       child: const Icon(Icons.close),
      //       fabSize: ExpandableFabSize.small,
      //       foregroundColor: AppTheme.whiteBackground,
      //       backgroundColor: AppTheme.primaryBlueAccentColor,
      //       shape: const CircleBorder(),
      //     ),
      //     overlayStyle: ExpandableFabOverlayStyle(
      //       blur: 2.5,
      //       color: AppTheme.transparentColor,
      //     ),
      //     type: ExpandableFabType.side,
      //     childrenAnimation: ExpandableFabAnimation.rotate,
      //     distance: 100,
      //     margin: EdgeInsets.only(bottom: 50),
      //     children: const [
      //       SocialButton(
      //         url: 'https://www.facebook.com/share/g/1D4bRRtVtx/',
      //         icon: HugeIcons.strokeRoundedFacebook02,
      //         platform: 'Facebook',
      //       ),
      //       SocialButton(
      //         url: 'https://www.instagram.com/megatronix__msit',
      //         icon: HugeIcons.strokeRoundedInstagram,
      //         platform: 'Instagram',
      //       ),
      //       SocialButton(
      //         url: 'https://www.youtube.com/@megatronixmsit921',
      //         icon: HugeIcons.strokeRoundedYoutube,
      //         platform: 'Youtube',
      //       ),
      //     ],
      //   ),
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
                    height: 250,
                  ),
                  CustomTextField(
                    hintText: 'Name',
                    prefixIcon: Icons.person,
                    controller: _nameController,
                    isWebPage: true,
                  ),
                  CustomTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    isWebPage: true,
                  ),
                  CustomTextField(
                    hintText: 'Contact',
                    prefixIcon: Icons.phone,
                    controller: _contactController,
                    numberType: true,
                    isWebPage: true,
                  ),
                  CustomTextField(
                    hintText: 'Your Query',
                    prefixIcon: Icons.question_answer,
                    controller: _queryController,
                    expands: true,
                    isWebPage: true,
                  ),
                  CustomButton(
                    onPressed: () {
                      _createQuery();
                    },
                    buttonText: 'Send us your query',
                    isWebPage: true,
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
