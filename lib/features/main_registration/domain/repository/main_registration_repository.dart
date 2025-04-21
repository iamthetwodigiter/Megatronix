import 'package:megatronix/features/main_registration/domain/entities/main_registration_entity.dart';

abstract class MainRegistrationRepository {
  Future<MainRegistrationEntity> mainRegistration(String email);
}
