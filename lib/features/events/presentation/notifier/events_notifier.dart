import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/events/domain/entities/combo_entity.dart';
import 'package:megatronix/features/events/domain/entities/domain_poster_entity.dart';
import 'package:megatronix/features/events/domain/entities/events_entity.dart';
import 'package:megatronix/features/events/domain/repository/events_repository.dart';

class EventsState {
  final bool isLoading;
  final List<EventsEntity>? eventsList;
  final EventsEntity? event;
  final List<ComboEntity>? combosList;
  final List<DomainPosterEntity>? domainPosters;
  final String? error;

  EventsState({
    this.isLoading = false,
    this.eventsList,
    this.event,
    this.combosList,
    this.domainPosters,
    this.error,
  });

  EventsState copyWith({
    bool? isLoading,
    List<EventsEntity>? eventsList,
    EventsEntity? event,
    List<ComboEntity>? combosList,
    List<DomainPosterEntity>? domainPosters,
    String? error,
  }) {
    return EventsState(
      isLoading: isLoading ?? this.isLoading,
      eventsList: eventsList ?? this.eventsList,
      event: event ?? this.event,
      combosList: combosList ?? this.combosList,
      domainPosters: domainPosters ?? this.domainPosters,
      error: error ?? this.error,
    );
  }
}

class EventsNotifier extends StateNotifier<EventsState> {
  final EventsRepository _eventsRepository;

  EventsNotifier(this._eventsRepository) : super(EventsState());

  Future<void> getAllEvents() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final eventsList = await _eventsRepository.getAllEvents();
      state = state.copyWith(isLoading: false, eventsList: eventsList);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getAllEventsByDomain(String domain) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final eventsList = await _eventsRepository.getAllEventsByDomain(domain);

      state = state.copyWith(isLoading: false, eventsList: eventsList);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getAllCombosByDomain(String domain) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final combosList = await _eventsRepository.getAllCombosByDomain(domain);
      state = state.copyWith(isLoading: false, combosList: combosList);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getAllDomainPosters() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final domainPosters = await _eventsRepository.getAllDomainPosters();
      state = state.copyWith(isLoading: false, domainPosters: domainPosters);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
