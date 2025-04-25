import 'package:megatronix/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<UserEntity> registerUser(String name, String email, String password);
  Future<UserEntity> loginUser(String email, String password);
  Future<UserEntity> checkAuthStatus();
  Future<String> logOut();
  Future<String> resetPasswordRequest(String email);
  Future<String> validateToken(String token);
  Future<String> confirmResetPassword(String token, String newPassword);
  Future<String> sendEmailVerificationOTP(String email);
  Future<String> verifyEmailVerificationOTP(String email, String otp);
  Future<String> resendEmailVerificationOTP(String email);
}
