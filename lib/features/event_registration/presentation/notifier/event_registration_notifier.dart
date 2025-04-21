import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/event_registration/domain/entities/combo_registration_details.dart';
import 'package:megatronix/features/event_registration/domain/entities/event_registration_details_entity.dart';
import 'package:megatronix/features/event_registration/domain/repository/event_registration_repository.dart';

class EventRegistrationState {
  final bool isLoading;
  final EventRegistrationDetailsEntity? eventRegistrations;
  final List<EventRegistrationDetailsEntity>? eventRegistrationList;
  final ComboRegistrationDetailsEntity? comboRegistrations;
  final List<EventRegistrationDetailsEntity>? eventByGID;
  final String? error;

  EventRegistrationState({
    this.isLoading = false,
    this.eventRegistrations,
    this.eventRegistrationList,
    this.comboRegistrations,
    this.eventByGID,
    this.error,
  });

  EventRegistrationState copyWith({
    bool? isLoading,
    EventRegistrationDetailsEntity? eventRegistrations,
    List<EventRegistrationDetailsEntity>? eventRegistrationList,
    ComboRegistrationDetailsEntity? comboRegistrations,
    List<EventRegistrationDetailsEntity>? eventByGID,
    String? error,
  }) {
    return EventRegistrationState(
      isLoading: isLoading ?? this.isLoading,
      eventRegistrations: eventRegistrations ?? this.eventRegistrations,
      eventRegistrationList:
          eventRegistrationList ?? this.eventRegistrationList,
      comboRegistrations: comboRegistrations ?? this.comboRegistrations,
      eventByGID: eventByGID ?? this.eventByGID,
      error: error ?? this.error,
    );
  }
}

class EventRegistrationNotifier extends StateNotifier<EventRegistrationState> {
  final EventRegistrationRepository _eventRegistrationRepository;
  EventRegistrationNotifier(this._eventRegistrationRepository)
      : super(EventRegistrationState());

  Future<void> registerTeam(int eventID, String teamName, List<String> gidList,
      List<Map<String, dynamic>> contact) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final eventsRegistration = await _eventRegistrationRepository
          .registerTeam(eventID, teamName, gidList, contact);
      state = state.copyWith(
        isLoading: false,
        eventRegistrations: eventsRegistration,
        error: null
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> registerCombo(int comboID, String teamName,
      Map<String, dynamic> gidList, List<Map<String, dynamic>> contact) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final comboRegistrations = await _eventRegistrationRepository
          .registerCombo(comboID, teamName, gidList, contact);
      state = state.copyWith(
        isLoading: false,
        comboRegistrations: comboRegistrations,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getTeamsByGID(String gid) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final eventByGID = await _eventRegistrationRepository.getTeamsByGID(gid);
      state = state.copyWith(
        isLoading: false,
        eventByGID: eventByGID,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
