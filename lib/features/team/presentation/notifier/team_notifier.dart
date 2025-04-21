import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/team/domain/entities/team_entity.dart';
import 'package:megatronix/features/team/domain/entities/team_photo_entity.dart';
import 'package:megatronix/features/team/domain/repository/team_repository.dart';

class TeamState {
  final bool isLoading;
  final List<TeamEntity>? teamMembers;
  final TeamPosterEntity? teamPhotos;
  final String? error;

  TeamState({
    this.isLoading = false,
    this.teamMembers = const [],
    this.teamPhotos,
    this.error,
  });

  TeamState copyWith({
    bool? isLoading,
    List<TeamEntity>? teamMembers,
    TeamPosterEntity? teamPhotos,
    String? error,
  }) {
    return TeamState(
      isLoading: isLoading ?? this.isLoading,
      teamMembers: teamMembers ?? this.teamMembers,
      teamPhotos: teamPhotos ?? this.teamPhotos,
      error: error ?? this.error,
    );
  }
}

class TeamNotifier extends StateNotifier<TeamState> {
  final TeamRepository _teamRepository;

  TeamNotifier(this._teamRepository) : super(TeamState());

  Future<void> getTeamMembers() async {
    state = state.copyWith(isLoading: true);
    try {
      final teamMembers = await _teamRepository.getTeamMembers();
      state = state.copyWith(isLoading: false, teamMembers: teamMembers);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getDevelopers() async {
    state = state.copyWith(isLoading: true);
    try {
      final teamMembers = await _teamRepository.getDevelopers();
      state = state.copyWith(isLoading: false, teamMembers: teamMembers);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getTeamPhoto() async {
    state = state.copyWith(isLoading: true);
    try {
      final teamPhotos = await _teamRepository.getTeamPhoto();
      state = state.copyWith(isLoading: false, teamPhotos: teamPhotos);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
