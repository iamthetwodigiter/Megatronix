import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/main_registration/domain/entities/main_registration_entity.dart';
import 'package:megatronix/features/main_registration/domain/repository/main_registration_repository.dart';

class MainRegistrationState {
  final bool isLoading;
  final MainRegistrationEntity? mainRegistrationEntity;
  final List<MainRegistrationEntity>? mainRegistrationDetailsList;
  final String? error;

  MainRegistrationState({
    this.isLoading = false,
    this.mainRegistrationEntity,
    this.mainRegistrationDetailsList,
    this.error,
  });

  MainRegistrationState copyWith({
    bool? isLoading,
    MainRegistrationEntity? mainRegistrationEntity,
    List<MainRegistrationEntity>? mainRegistrationDetailsList,
    String? error,
  }) {
    return MainRegistrationState(
      isLoading: isLoading ?? this.isLoading,
      mainRegistrationEntity:
          mainRegistrationEntity ?? this.mainRegistrationEntity,
      mainRegistrationDetailsList:
          mainRegistrationDetailsList ?? this.mainRegistrationDetailsList,
      error: error ?? this.error,
    );
  }
}

class MainRegistrationNotifier extends StateNotifier<MainRegistrationState> {
  final MainRegistrationRepository _mainRegistrationRepository;

  MainRegistrationNotifier(this._mainRegistrationRepository)
      : super(MainRegistrationState());

  Future<void> mainRegistration(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final mainRegistrationEntity =
          await _mainRegistrationRepository.mainRegistration(email);
      state = state.copyWith(
          isLoading: false, mainRegistrationEntity: mainRegistrationEntity);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
