import 'package:megatronix/features/team/data/models/team_model.dart';
import 'package:megatronix/features/team/data/models/team_photo_model.dart';
import 'package:megatronix/features/team/data/services/team_service.dart';
import 'package:megatronix/features/team/domain/entities/team_entity.dart';
import 'package:megatronix/features/team/domain/entities/team_photo_entity.dart';
import 'package:megatronix/features/team/domain/repository/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamService _teamService;
  TeamRepositoryImpl(this._teamService);

  @override
  Future<List<TeamEntity>> getTeamMembers() async {
    try {
      final teamMembers = await _teamService.getTeamMembers();
      return teamMembers.map((e) => TeamModel.fromMap(e).toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TeamEntity>> getDevelopers() async {
    try {
      final teamMembers = await _teamService.getDevelopers();
      return teamMembers.map((e) => TeamModel.fromMap(e).toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TeamPosterEntity> getTeamPhoto() async {
    try {
      final teamPhotos = await _teamService.getTeamPhoto();
      final teamPhotosEntity = TeamPosterModel.fromMap(teamPhotos).toEntity();
      return teamPhotosEntity;
    } catch (e) {
      rethrow;
    }
  }
}
