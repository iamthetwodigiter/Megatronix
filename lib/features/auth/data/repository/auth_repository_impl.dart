import 'package:megatronix/features/auth/data/models/user_model.dart';
import 'package:megatronix/features/auth/data/services/auth_service.dart';
import 'package:megatronix/features/auth/domain/entities/user_entity.dart';
import 'package:megatronix/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authServices;
  AuthRepositoryImpl(this._authServices);

  @override
  Future<UserEntity> registerUser(
      String name, String email, String password) async {
    try {
      final response = await _authServices.registerUser(name, email, password);
      final UserModel userModel = UserModel.fromMap(response);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> loginUser(String email, String password) async {
    try {
      final response = await _authServices.loginUser(email, password);
      final UserModel userModel = UserModel.fromMap(response);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> checkAuthStatus() async {
    try {
      final response = await _authServices.checkAuthStatus();
      final UserModel userModel = UserModel.fromMap(response);
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> logOut() async {
    try {
      final response = await _authServices.logOut();
      return response['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> resetPasswordRequest(String email) async {
    try {
      final response = await _authServices.resetPasswordRequest(email);
      return response['message'];
    } catch (e) {
      rethrow;
    }
  }

  // Here valid value is returned which is boolean value typecasted to String
  @override
  Future<String> validateToken(String token) async {
    try {
      final response = await _authServices.validateToken(token);
      return response['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> confirmResetPassword(String token, String newPassword) async {
    try {
      final response =
          await _authServices.confirmResetPassword(token, newPassword);
      return response['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> sendEmailVerificationOTP(String email) async {
    try {
      final response = await _authServices.sendEmailVerificationOTP(email);
      return response['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> verifyEmailVerificationOTP(String email, String otp) async {
    try {
      final response =
          await _authServices.verifyEmailVerificationOTP(email, otp);
      return response['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> resendEmailVerificationOTP(String email) async {
    try {
      final response = await _authServices.resendEmailVerificationOTP(email);

      return response['message'];
    } catch (e) {
      rethrow;
    }
  }
}
