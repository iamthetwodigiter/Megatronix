import 'package:megatronix/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> createProfile(String email, String contact,
      String college, String year, String department, String rollNo,
      {String? profile});
  Future<ProfileEntity> getProfileByID(int id);
}
