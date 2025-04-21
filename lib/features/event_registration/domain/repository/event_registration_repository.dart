import 'package:megatronix/features/event_registration/domain/entities/combo_registration_details.dart';
import 'package:megatronix/features/event_registration/domain/entities/event_registration_details_entity.dart';

abstract class EventRegistrationRepository {
  Future<EventRegistrationDetailsEntity> registerTeam(
      int eventID,
      String teamName,
      List<String> gidList,
      List<Map<String, dynamic>> contact);
  Future<ComboRegistrationDetailsEntity> registerCombo(
      int comboID,
      String teamName,
      Map<String, dynamic> gidList,
      List<Map<String, dynamic>> contact);
  Future<List<EventRegistrationDetailsEntity>> getTeamsByGID(String gid);
}
