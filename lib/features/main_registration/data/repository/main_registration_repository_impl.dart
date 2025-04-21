import 'package:megatronix/features/main_registration/data/models/main_registration_model.dart';
import 'package:megatronix/features/main_registration/data/services/main_registration_service.dart';
import 'package:megatronix/features/main_registration/domain/entities/main_registration_entity.dart';
import 'package:megatronix/features/main_registration/domain/repository/main_registration_repository.dart';

class MainRegistrationRepositoryImpl implements MainRegistrationRepository {
  final MainRegistrationService _mainRegistrationServices;
  MainRegistrationRepositoryImpl(this._mainRegistrationServices);

  @override
  Future<MainRegistrationEntity> mainRegistration(String email) async {
    try {
      final response = await _mainRegistrationServices.mainRegistration(email);
      final MainRegistrationModel mainRegistrationModel =
          MainRegistrationModel.fromMap(response);
      return mainRegistrationModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
