import 'package:megatronix/features/profile/data/models/profile_model.dart';
import 'package:megatronix/features/profile/data/services/profile_service.dart';
import 'package:megatronix/features/profile/domain/entities/profile_entity.dart';
import 'package:megatronix/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _profileServices;

  ProfileRepositoryImpl(this._profileServices);

  @override
  Future<ProfileEntity> createProfile(String email, String contact,
      String college, String year, String department, String rollNo,
      {String? profile}) async {
    try {
      final response = await _profileServices.createProfile(
          email, contact, college, year, department, rollNo);
      final ProfileModel profile = ProfileModel.fromMap(response);
      return profile.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfileEntity> getProfileByID(int id) async {
    try {
      final response = await _profileServices.getProfileByID(id);
      final ProfileModel profile = ProfileModel.fromMap(response);
      return profile.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
