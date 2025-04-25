import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/pages/landing_page.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_dropdown.dart';
import 'package:megatronix/common/widgets/custom_header.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/auth/domain/entities/user_entity.dart';
import 'package:megatronix/features/profile/presentation/pages/user_profile_page.dart';
import 'package:megatronix/features/profile/provider/profile_providers.dart';
import 'package:toastification/toastification.dart';

class CreateProfilePage extends ConsumerStatefulWidget {
  final UserEntity user;

  const CreateProfilePage({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends ConsumerState<CreateProfilePage> {
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _collegeController;
  late TextEditingController _yearController;
  late TextEditingController _departmentController;
  late TextEditingController _rollNoController;

  final List<DropdownMenuEntry> _yearDropDownEntries = [
    DropdownMenuEntry(value: 'FIRST', label: 'First'),
    DropdownMenuEntry(value: 'SECOND', label: 'Second'),
    DropdownMenuEntry(value: 'THIRD', label: 'Third'),
    DropdownMenuEntry(value: 'FOURTH', label: 'Fourth'),
    DropdownMenuEntry(value: 'PASSOUT', label: 'Passout'),
    DropdownMenuEntry(value: 'ALUMNI', label: 'Alumni'),
    DropdownMenuEntry(value: 'OTHERS', label: 'Others'),
    DropdownMenuEntry(value: 'NOT_APPLICABLE', label: 'Not Applicable'),
  ];

  final List<DropdownMenuEntry> _departmentDropDownEntries = [
    DropdownMenuEntry(value: 'CSE', label: 'CSE'),
    DropdownMenuEntry(value: 'IT', label: 'IT'),
    DropdownMenuEntry(value: 'AIML', label: 'AIML'),
    DropdownMenuEntry(value: 'DS', label: 'DS'),
    DropdownMenuEntry(value: 'CSBS', label: 'CSBS'),
    DropdownMenuEntry(value: 'CYS', label: 'CYS'),
    DropdownMenuEntry(value: 'AIDS', label: 'AIDS'),
    DropdownMenuEntry(value: 'ECE', label: 'ECE'),
    DropdownMenuEntry(value: 'EE', label: 'EE'),
    DropdownMenuEntry(value: 'CE', label: 'CE'),
    DropdownMenuEntry(value: 'ME', label: 'ME'),
    DropdownMenuEntry(value: 'BBA', label: 'BBA'),
    DropdownMenuEntry(value: 'MBA', label: 'MBA'),
    DropdownMenuEntry(value: 'BCA', label: 'BCA'),
    DropdownMenuEntry(value: 'MCA', label: 'MCA'),
    DropdownMenuEntry(value: 'BSC', label: 'BSC'),
    DropdownMenuEntry(value: 'MSC', label: 'MSC'),
    DropdownMenuEntry(value: 'BCOM', label: 'BCOM'),
    DropdownMenuEntry(value: 'MCOM', label: 'MCOM'),
    DropdownMenuEntry(value: 'BA', label: 'BA'),
    DropdownMenuEntry(value: 'MA', label: 'MA'),
    DropdownMenuEntry(value: 'LLB', label: 'LLB'),
    DropdownMenuEntry(value: 'LLM', label: 'LLM'),
    DropdownMenuEntry(value: 'OTHERS', label: 'Others'),
  ];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _contactController = TextEditingController();
    _collegeController = TextEditingController();
    _yearController = TextEditingController();
    _departmentController = TextEditingController();
    _rollNoController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkProfile();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _contactController.dispose();
    _collegeController.dispose();
    _yearController.dispose();
    _departmentController.dispose();
    _rollNoController.dispose();
    super.dispose();
  }

  void _checkProfile() {
    ref.read(profileNotifierProvider.notifier).getProfileByID(widget.user.id);
    final profileState =
        ref.read(profileNotifierProvider).profile?.profileCreated;
    if (!mounted) return;
    if (profileState == true) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return UserProfilePage();
      }));
    }
  }

  void _createProfile() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      AppErrorHandler.handleError(
        context,
        'Invalid Email',
        'Enter a valid email address',
      );
      return;
    }

    if (_contactController.text.isEmpty ||
        _contactController.text.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(_contactController.text)) {
      AppErrorHandler.handleError(
        context,
        'Invalid Contact',
        'Enter a valid 10-digit contact number',
      );
      return;
    }

    if (_collegeController.text.isEmpty) {
      AppErrorHandler.handleError(
        context,
        'Invalid College',
        'College name cannot be empty',
      );
      return;
    }

    if (_departmentController.text.isEmpty) {
      AppErrorHandler.handleError(
        context,
        'Invalid Department',
        'Please select your department',
      );
      return;
    }

    if (_yearController.text.isEmpty) {
      AppErrorHandler.handleError(
        context,
        'Invalid Year',
        'Please select your year',
      );
      return;
    }

    if (_rollNoController.text.isEmpty ||
        !RegExp(r'^[0-9]+$').hasMatch(_rollNoController.text)) {
      AppErrorHandler.handleError(
        context,
        'Invalid Roll Number',
        'Please enter a valid roll number',
      );
      return;
    }

    ref.read(profileNotifierProvider.notifier).createProfile(
          _emailController.text.trim(),
          _contactController.text.trim(),
          _collegeController.text.trim(),
          _yearController.text.trim(),
          _departmentController.text.trim(),
          _rollNoController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    if (profileState.isLoading && context.mounted) {
      return CustomScaffold(
        title: 'Create Profile',
        child: Center(child: LoadingWidget()),
      );
    }

    if (profileState.profile?.profileCreated == true && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LandingPage(),
          ),
        );
        AppErrorHandler.handleError(
          context,
          'Profile Created Successfully',
          'Welcome to Paridhi 2025',
          type: ToastificationType.success,
        );
      });
    }

    if (profileState.error != null && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
      AppErrorHandler.handleError(
        context,
        'Error',
        profileState.error!.replaceAll("Exception: ", ""),
      );
    }

    return CustomScaffold(
      title: 'Create Profile',
      child: SingleChildScrollView(
        child: Column(
          spacing: 15,
          children: [
            SizedBox(height: 25),
            CustomHeader(title: 'Profile'),
            SizedBox(height: 10),
            CustomTextField(
              hintText: 'Email',
              prefixIcon: Icons.email,
              controller: _emailController,
              enabled: false,
            ),
            CustomTextField(
              hintText: 'Contact',
              prefixIcon: Icons.phone,
              controller: _contactController,
              numberType: true,
            ),
            CustomTextField(
              hintText: 'Institution Name',
              prefixIcon: Icons.school,
              controller: _collegeController,
            ),
            CustomDropdown(
              icon: Icons.abc,
              label: 'Department',
              dropDownEntries: _departmentDropDownEntries,
              controller: _departmentController,
              onValueChanged: (val) {
                setState(() {});
              },
            ),
            CustomDropdown(
              icon: Icons.numbers,
              label: 'Year',
              dropDownEntries: _yearDropDownEntries,
              controller: _yearController,
              onValueChanged: (val) {
                setState(() {});
              },
            ),
            CustomTextField(
              hintText: 'Roll No',
              prefixIcon: Icons.format_list_numbered,
              controller: _rollNoController,
              numberType: true,
            ),
            SizedBox(height: 10),
            CustomButton(
              onPressed: () {
                _createProfile();
              },
              buttonText: 'Create Profile',
            ),
          ],
        ),
      ),
    );
  }
}
