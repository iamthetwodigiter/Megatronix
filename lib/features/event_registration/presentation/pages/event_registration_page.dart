import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_scaffold.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/event_registration/presentation/notifier/event_registration_notifier.dart';
import 'package:megatronix/features/event_registration/providers/events_registration_provider.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class EventRegistrationPage extends ConsumerStatefulWidget {
  final int eventID;
  final int minPlayers;
  final int maxPlayers;

  const EventRegistrationPage({
    super.key,
    required this.eventID,
    required this.minPlayers,
    required this.maxPlayers,
  });

  @override
  ConsumerState<EventRegistrationPage> createState() =>
      _EventRegistrationPageState();
}

class _EventRegistrationPageState extends ConsumerState<EventRegistrationPage> {
  late TextEditingController _teamNameController;
  List<TextEditingController> _gidControllers = [];
  List<TextEditingController> _nameControllers = [];
  List<TextEditingController> _contactControllers = [];

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController();
    _gidControllers.add(TextEditingController());
    _nameControllers.add(TextEditingController());
    _contactControllers.add(TextEditingController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppErrorHandler.handleError(
        context,
        'Hint',
        'You can get your GID from your profile',
        type: ToastificationType.warning,
      );
    });
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    for (var controller in [
      ..._gidControllers,
      ..._nameControllers,
      ..._contactControllers
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addGidField() {
    if (_gidControllers.length < widget.maxPlayers) {
      setState(() {
        _gidControllers.add(TextEditingController());
      });
    }
  }

  void _addContactField() {
    if (_contactControllers.length < widget.maxPlayers) {
      setState(() {
        _nameControllers.add(TextEditingController());
        _contactControllers.add(TextEditingController());
      });
    }
  }

  void _removeGidField(int index) {
    if (_gidControllers.length > 1) {
      setState(() {
        _gidControllers[index].dispose();
        _gidControllers.removeAt(index);
      });
    }
  }

  void _removeContactField(int index) {
    if (_nameControllers.length > 1) {
      setState(() {
        _nameControllers[index].dispose();
        _contactControllers[index].dispose();
        _nameControllers.removeAt(index);
        _contactControllers.removeAt(index);
      });
    }
  }

  void _submitRegistration() {
    List<Map<String, dynamic>> contactList = [];
    List<String> gids = _gidControllers.map((c) => c.text.trim()).toList();
    List<String> names = _nameControllers.map((c) => c.text.trim()).toList();
    List<String> contacts = _contactControllers
        .map((c) => c.text.trim().replaceAll("+91", ""))
        .toList();

    if (_teamNameController.text.trim().isEmpty ||
        gids.any((gid) => gid.isEmpty) ||
        names.any((name) => name.isEmpty) ||
        contacts.any((contact) => contact.isEmpty)) {
      AppErrorHandler.handleError(
        context,
        'Invalid Details',
        "All fields are required!",
      );
      return;
    }

    if (gids.length < widget.minPlayers) {
      AppErrorHandler.handleError(
        context,
        'Invalid Registration',
        "Minimum ${widget.minPlayers} players must register",
      );
      return;
    }
    if (contacts.any((contact) => !RegExp(
            r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
        .hasMatch(contact))) {
      AppErrorHandler.handleError(
        context,
        'Invalid Contact',
        "Invalid contact number format!",
      );
      return;
    }

    if (gids.length != contacts.length) {
      AppErrorHandler.handleError(
        context,
        'Invalid Data',
        "Number of GIDs and contacts must be the same!",
      );
      return;
    }
    for (int i = 0; i < names.length; i++) {
      contactList.add(
        {"name": names.elementAt(i), "contact": contacts.elementAt(i)},
      );
    }

    ref.read(eventsRegistrationNotifierProvider.notifier).registerTeam(
          widget.eventID,
          _teamNameController.text.trim(),
          gids,
          contactList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final eventRegistrationState =
        ref.watch(eventsRegistrationNotifierProvider);
    ref.listen<EventRegistrationState>(eventsRegistrationNotifierProvider,
        (previous, current) {
      if (!context.mounted) return;
      if (current.isLoading) return;

      if (current.eventRegistrations != null && current.error == null) {
        AppErrorHandler.handleError(
          context,
          'Hurrah',
          'Event registration successful',
          type: ToastificationType.success,
        );
        Navigator.pop(context);
        return;
      }

      if (current.error != null) {
        AppErrorHandler.handleError(
          context,
          'Error',
          current.error!.contains(
            'Full authentication is required to access this resource',
          )
              ? 'Login to register'
              : current.error!,
        );
        return;
      }
    });

    if (eventRegistrationState.isLoading) {
      return CustomScaffold(
        title: 'Team Registration',
        secondaryImage: 'assets/images/background/home.jpg',
        customLottie: true,
        customOpacity: 0.5,
        child: Center(
          child: LoadingWidget(),
        ),
      );
    }
    return CustomScaffold(
      title: 'Team Registration',
      secondaryImage: 'assets/images/background/home.jpg',
      customLottie: true,
      customOpacity: 0.5,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            CustomTextField(
              hintText: 'Enter your team name',
              prefixIcon: Icons.group,
              controller: _teamNameController,
            ),
            const SizedBox(height: 16),
            ..._gidControllers.asMap().entries.map((entry) {
              int index = entry.key;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: 'Enter GID ${index + 1}',
                        prefixIcon: Icons.vpn_key,
                        controller: entry.value,
                      ),
                    ),
                    if (_gidControllers.length > 1)
                      IconButton(
                        onPressed: () => _removeGidField(index),
                        icon: const Icon(Icons.remove_circle,
                            color: Colors.red, size: 30),
                      ),
                  ],
                ),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Add GID", style: TextStyle(fontSize: 16)),
                IconButton(
                  onPressed: _addGidField,
                  icon: const Icon(Icons.add_circle,
                      color: AppTheme.primaryBlueAccentColor, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._nameControllers.asMap().entries.map((entry) {
              int index = entry.key;
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: CustomTextField(
                            hintText: 'Enter Name ${index + 1}',
                            prefixIcon: Icons.person,
                            controller: entry.value,
                          ),
                        ),
                      ),
                      if (_nameControllers.length > 1)
                        IconButton(
                          onPressed: () => _removeContactField(index),
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red, size: 30),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: CustomTextField(
                      hintText: 'Enter Contact ${index + 1}',
                      prefixIcon: Icons.phone,
                      controller: _contactControllers[index],
                    ),
                  ),
                ],
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Add Contact", style: TextStyle(fontSize: 16)),
                IconButton(
                  onPressed: _addContactField,
                  icon: const Icon(Icons.add_circle,
                      color: AppTheme.primaryBlueAccentColor, size: 30),
                ),
              ],
            ),
            CustomButton(
              onPressed: _submitRegistration,
              buttonText: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
