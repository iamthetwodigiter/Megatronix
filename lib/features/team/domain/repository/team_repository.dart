import 'package:megatronix/features/team/domain/entities/team_entity.dart';
import 'package:megatronix/features/team/domain/entities/team_photo_entity.dart';

abstract class TeamRepository {
  Future<List<TeamEntity>> getTeamMembers();
  Future<List<TeamEntity>> getDevelopers();
  Future<TeamPosterEntity> getTeamPhoto();
}
