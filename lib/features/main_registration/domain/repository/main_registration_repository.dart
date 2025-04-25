import 'package:megatronix/features/main_registration/domain/entities/main_registration_entity.dart';

abstract interface class MainRegistrationRepository {
  Future<MainRegistrationEntity> mainRegistration(String email);
}
