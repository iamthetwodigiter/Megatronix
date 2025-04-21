// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/profile/domain/entities/profile_entity.dart';
import 'package:megatronix/features/profile/domain/repository/profile_repository.dart';

class ProfileState {
  final bool isLoading;
  final ProfileEntity? profile;
  final String? error;

  ProfileState({
    this.isLoading = false,
    this.profile,
    this.error,
  });

  ProfileState copyWith({
    bool? isLoading,
    ProfileEntity? profile,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error ?? this.error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _profileRepository;
  ProfileNotifier(this._profileRepository) : super(ProfileState());

  Future<void> createProfile(String email, String contact, String college,
      String year, String department, String rollNo,
      {String? profile}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profileResponse = await _profileRepository.createProfile(
          email, contact, college, year, department, rollNo,
          profile: profile);
      state = state.copyWith(isLoading: false, profile: profileResponse);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getProfileByID(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profileResponse = await _profileRepository.getProfileByID(id);
      state = state.copyWith(isLoading: false, profile: profileResponse);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
