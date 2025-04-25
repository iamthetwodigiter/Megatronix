import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/team/data/repository/team_repository_impl.dart';
import 'package:megatronix/features/team/data/services/team_service.dart';
import 'package:megatronix/features/team/domain/repository/team_repository.dart';
import 'package:megatronix/features/team/presentation/notifier/team_notifier.dart';

final teamServiceProvider = Provider<TeamService>((ref) {
  return TeamService();
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final teamService = ref.read(teamServiceProvider);
  return TeamRepositoryImpl(teamService);
});

final teamNotifierProvider =
    StateNotifierProvider<TeamNotifier, TeamState>((ref) {
  return TeamNotifier(ref.read(teamRepositoryProvider));
});
