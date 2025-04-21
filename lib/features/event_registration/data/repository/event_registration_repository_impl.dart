import 'package:megatronix/features/event_registration/data/models/combo_registration_details.dart';
import 'package:megatronix/features/event_registration/data/models/event_registration_details_model.dart';
import 'package:megatronix/features/event_registration/data/services/event_registration_service.dart';
import 'package:megatronix/features/event_registration/domain/entities/combo_registration_details.dart';
import 'package:megatronix/features/event_registration/domain/entities/event_registration_details_entity.dart';
import 'package:megatronix/features/event_registration/domain/repository/event_registration_repository.dart';

class EventRegistrationRepositoryImpl implements EventRegistrationRepository {
  final EventRegistrationService _eventRegistrationServices;
  EventRegistrationRepositoryImpl(this._eventRegistrationServices);

  @override
  Future<EventRegistrationDetailsEntity> registerTeam(
    int eventID,
    String teamName,
    List<String> gidList,
    List<Map<String, dynamic>> contact,
  ) async {
    try {
      final response = await _eventRegistrationServices.registerTeam(
          eventID, teamName, gidList, contact);
      final EventRegistrationDetailsModel eventRegistration =
          EventRegistrationDetailsModel.fromMap(response);
      return eventRegistration.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ComboRegistrationDetailsEntity> registerCombo(
      int comboID,
      String teamName,
      Map<String, dynamic> gidList,
      List<Map<String, dynamic>> contact) async {
    try {
      final response = await _eventRegistrationServices.registerCombo(
          comboID, teamName, gidList, contact);
      final ComboRegistrationDetailsModel comboRegistration =
          ComboRegistrationDetailsModel.fromMap(response);
      return comboRegistration.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<EventRegistrationDetailsEntity>> getTeamsByGID(String gid) async {
    try {
      final response = await _eventRegistrationServices.getTeamsByGID(gid);

      return response
          .map((e) => EventRegistrationDetailsModel.fromMap(e).toEntity())
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
