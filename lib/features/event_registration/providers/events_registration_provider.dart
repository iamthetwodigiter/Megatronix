import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/event_registration/data/repository/event_registration_repository_impl.dart';
import 'package:megatronix/features/event_registration/data/services/event_registration_service.dart';
import 'package:megatronix/features/event_registration/domain/repository/event_registration_repository.dart';
import 'package:megatronix/features/event_registration/presentation/notifier/event_registration_notifier.dart';

final eventsRegistrationServicesProvider =
    Provider<EventRegistrationService>((ref) => EventRegistrationService());

final eventsRegistrationRepositoryProvider =
    Provider<EventRegistrationRepository>((ref) {
  final eventsRegistrationServices =
      ref.watch(eventsRegistrationServicesProvider);
  return EventRegistrationRepositoryImpl(eventsRegistrationServices);
});

final eventsRegistrationNotifierProvider =
    StateNotifierProvider<EventRegistrationNotifier, EventRegistrationState>(
        (ref) {
  final eventsRegistrationRepository =
      ref.watch(eventsRegistrationRepositoryProvider);
  return EventRegistrationNotifier(eventsRegistrationRepository);
});
