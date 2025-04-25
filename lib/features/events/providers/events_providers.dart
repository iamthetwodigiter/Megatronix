import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/events/data/repository/events_repository_impl.dart';
import 'package:megatronix/features/events/data/services/events_service.dart';
import 'package:megatronix/features/events/domain/repository/events_repository.dart';
import 'package:megatronix/features/events/presentation/notifier/events_notifier.dart';

final eventsServiceProvider = Provider<EventsService>((ref) => EventsService());

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final eventsServices = ref.watch(eventsServiceProvider);
  return EventsRepositoryImpl(eventsServices);
});

final eventsNotifierProvider =
    StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  final eventsRepository = ref.watch(eventsRepositoryProvider);
  return EventsNotifier(eventsRepository);
});
