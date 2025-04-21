import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/common/widgets/custom_button.dart';
import 'package:megatronix/common/widgets/custom_textfield.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/errors/app_error_handler.dart';
import 'package:megatronix/features/events/domain/entities/combo_entity.dart';
import 'package:megatronix/features/events/domain/entities/events_entity.dart';
import 'package:megatronix/features/event_registration/presentation/notifier/event_registration_notifier.dart';
import 'package:megatronix/features/event_registration/providers/events_registration_provider.dart';
import 'package:megatronix/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class ComboRegistrationWebPage extends ConsumerStatefulWidget {
  final ComboEntity combo;

  const ComboRegistrationWebPage({
    super.key,
    required this.combo,
  });

  @override
  ConsumerState<ComboRegistrationWebPage> createState() =>
      _ComboRegistrationWebPageState();
}

class _ComboRegistrationWebPageState
    extends ConsumerState<ComboRegistrationWebPage> {
  late TextEditingController _teamNameController;

  Map<int, List<TextEditingController>> _eventGidControllers = {};
  List<TextEditingController> _nameControllers = [];
  List<TextEditingController> _contactControllers = [];

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController();

    for (var event in widget.combo.events) {
      _eventGidControllers[event.id] = List.generate(
        event.minPlayers.toInt(),
        (_) => TextEditingController(),
      );
    }

    int maxMinPlayers = widget.combo.events
        .map((e) => e.minPlayers)
        .reduce((a, b) => a > b ? a : b)
        .toInt();

    _nameControllers =
        List.generate(maxMinPlayers, (_) => TextEditingController());
    _contactControllers =
        List.generate(maxMinPlayers, (_) => TextEditingController());
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    for (var controllers in _eventGidControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    for (var controller in [..._nameControllers, ..._contactControllers]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addGidField(EventsEntity event) {
    if (_eventGidControllers[event.id]!.length < event.maxPlayers) {
      setState(() {
        _eventGidControllers[event.id]!.add(TextEditingController());
      });
    }
  }

  void _addContactField() {
    int maxAllowedPlayers = widget.combo.events
        .map((e) => e.maxPlayers)
        .reduce((a, b) => a > b ? a : b)
        .toInt();

    if (_nameControllers.length < maxAllowedPlayers) {
      setState(() {
        _nameControllers.add(TextEditingController());
        _contactControllers.add(TextEditingController());
      });
    }
  }

  void _submitRegistration() {
    if (_teamNameController.text.trim().isEmpty) {
      AppErrorHandler.handleError(
        context,
        'Invalid Details',
        "Team name is required!",
      );
      return;
    }

    Map<String, List<String>> eventGidMap = {};

    for (var event in widget.combo.events) {
      List<String> gids = _eventGidControllers[event.id]!
          .map((c) => c.text.trim())
          .where((gid) => gid.isNotEmpty)
          .toList();

      if (gids.length < event.minPlayers) {
        AppErrorHandler.handleError(
          context,
          'Invalid Registration',
          "Event ${event.name} requires minimum ${event.minPlayers} GIDs",
        );
        return;
      }

      if (gids.length > event.maxPlayers) {
        AppErrorHandler.handleError(
          context,
          'Invalid Registration',
          "Event ${event.name} allows maximum ${event.maxPlayers} GIDs",
        );
        return;
      }

      eventGidMap[event.id.toString()] = gids;
    }

    List<Map<String, dynamic>> contactsList = [];
    List<String> names = _nameControllers.map((c) => c.text.trim()).toList();
    List<String> contacts = _contactControllers
        .map((c) => c.text.trim().replaceAll("+91", ""))
        .toList();

    if (names.any((name) => name.isEmpty) ||
        contacts.any((contact) => contact.isEmpty)) {
      AppErrorHandler.handleError(
        context,
        'Invalid Details',
        "All contact details are required!",
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

    for (int i = 0; i < names.length; i++) {
      contactsList.add({
        "name": names[i],
        "contact": contacts[i],
      });
    }
    ref.read(eventsRegistrationNotifierProvider.notifier).registerCombo(
          widget.combo.id,
          _teamNameController.text.trim(),
          eventGidMap,
          contactsList,
        );
  }

  @override
  Widget build(BuildContext context) {
    final eventRegistrationState =
        ref.watch(eventsRegistrationNotifierProvider);

    ref.listen<EventRegistrationState>(
      eventsRegistrationNotifierProvider,
      (previous, current) {
        if (current.eventRegistrations != null && context.mounted) {
          AppErrorHandler.handleError(
            context,
            'Success',
            'Combo registration successful',
            type: ToastificationType.success,
          );
          return;
        }
        if (current.error != null && context.mounted) {
          AppErrorHandler.handleError(
            context,
            'Error',
            current.error?.replaceAll("Exception: ", "") ??
                'Registration failed. Please try again later.',
          );
          return;
        }
        Navigator.pop(context);
      },
    );

    if (eventRegistrationState.isLoading) {
      return CustomWebScaffold(
        title: 'Combo Registration',
        child: Center(child: LoadingWidget()),
      );
    }

    return CustomWebScaffold(
      title: 'Combo Registration',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            CustomTextField(
              hintText: 'Enter your team name',
              prefixIcon: Icons.group,
              controller: _teamNameController,
              isWebPage: true,
            ),
            const SizedBox(height: 24),
            ...widget.combo.events.map((event) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Players required: ${event.minPlayers} - ${event.maxPlayers}',
                    style: TextStyle(
                      color: AppTheme.inactiveColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._eventGidControllers[event.id]!.asMap().entries.map(
                    (entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: CustomTextField(
                          hintText: 'Enter GID ${entry.key + 1}',
                          prefixIcon: Icons.vpn_key,
                          controller: entry.value,
                          isWebPage: true,
                        ),
                      );
                    },
                  ),
                  if (_eventGidControllers[event.id]!.length < event.maxPlayers)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Add GID", style: TextStyle(fontSize: 16)),
                        IconButton(
                          onPressed: () => _addGidField(event),
                          icon: const Icon(
                            Icons.add_circle,
                            color: AppTheme.primaryBlueAccentColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                ],
              );
            }),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Team Contact Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._nameControllers.asMap().entries.map((entry) {
              int index = entry.key;
              return Column(
                children: [
                  CustomTextField(
                    hintText: 'Enter Name ${index + 1}',
                    prefixIcon: Icons.person,
                    controller: entry.value,
                    isWebPage: true,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Enter Contact ${index + 1}',
                    prefixIcon: Icons.phone,
                    controller: _contactControllers[index],
                    isWebPage: true,
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Add Contact", style: TextStyle(fontSize: 16)),
                IconButton(
                  onPressed: _addContactField,
                  icon: const Icon(
                    Icons.add_circle,
                    color: AppTheme.primaryBlueAccentColor,
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              onPressed: _submitRegistration,
              buttonText: 'Register',
              isWebPage: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
