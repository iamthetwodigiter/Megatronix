import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/auth/domain/entities/user_entity.dart';
import 'package:megatronix/features/auth/domain/repository/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final AuthError? error;
  final AuthMessage? message;
  final UserEntity? user;

  AuthState({
    this.isLoading = false,
    this.error,
    this.message,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    AuthError? error,
    AuthMessage? message,
    UserEntity? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}

enum AuthErrorType {
  register,
  login,
  checkAuth,
  logout,
  passwordReset,
  validateToken,
  confirmResetPassword,
  otp,
  general
}

class AuthError {
  final String message;
  final AuthErrorType type;

  AuthError(this.message, this.type);
}

class AuthMessage {
  final String message;
  final AuthErrorType type;

  AuthMessage(this.message, this.type);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState());

  Future<void> resetState() async {
    state = state.copyWith(
      isLoading: false,
      error: null,
      message: null,
      user: null,
    );
  }

  Future<void> registerUser(String name, String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      final user = await _authRepository.registerUser(name, email, password);
      state = AuthState(
        isLoading: false,
        user: user,
        message: AuthMessage(
          "Registration successful",
          AuthErrorType.register,
        ),
      );
    } catch (e) {
      state = AuthState(
        isLoading: false,
        error: AuthError(
          e.toString(),
          AuthErrorType.register,
        ),
      );
    }
  }

  Future<void> loginUser(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      final user = await _authRepository.loginUser(email, password);
      state = AuthState(
        isLoading: false,
        user: user,
        message: AuthMessage(
          "Login successful",
          AuthErrorType.login,
        ),
      );
    } catch (e) {
      state = AuthState(
        isLoading: false,
        error: AuthError(
          e.toString(),
          AuthErrorType.login,
        ),
      );
    }
  }

  Future<void> checkAuth() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authRepository.checkAuthStatus();
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthError(e.toString(), AuthErrorType.checkAuth),
        user: null,
      );
    }
  }

  Future<void> logOut() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.logOut();
      state = AuthState(
        isLoading: false,
        user: null,
        error: null,
        message: AuthMessage("Logged out successfully", AuthErrorType.logout),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthError(
          e.toString(),
          AuthErrorType.logout,
        ),
      );
    }
  }

  Future<void> resetPasswordRequest(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final message = await _authRepository.resetPasswordRequest(email);
      state = state.copyWith(
        isLoading: false,
        message: AuthMessage(
          message,
          AuthErrorType.passwordReset,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthError(
          e.toString(),
          AuthErrorType.passwordReset,
        ),
      );
    }
  }

  Future<void> validateToken(String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final message = await _authRepository.validateToken(token);
      state = state.copyWith(
        isLoading: false,
        message: AuthMessage(
          message,
          AuthErrorType.passwordReset,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthError(
          e.toString(),
          AuthErrorType.passwordReset,
        ),
      );
    }
  }

  Future<void> confirmResetPassword(String token, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final message =
          await _authRepository.confirmResetPassword(token, newPassword);
      state = state.copyWith(
        isLoading: false,
        message: AuthMessage(
          message,
          AuthErrorType.passwordReset,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthError(
          e.toString(),
          AuthErrorType.passwordReset,
        ),
      );
    }
  }

  Future<void> sendEmailVerificationOTP(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final message = await _authRepository.sendEmailVerificationOTP(email);
      state = state.copyWith(
        isLoading: false,
        message: AuthMessage(
          message,
          AuthErrorType.otp,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthError(
          e.toString(),
          AuthErrorType.general,
        ),
      );
    }
  }

  Future<void> verifyEmailVerificationOTP(String email, String otp) async {
    state = state.copyWith(isLoading: true, error: null, message: null);
    try {
      final message =
          await _authRepository.verifyEmailVerificationOTP(email, otp);

      final user = await _authRepository.checkAuthStatus();
      state = state.copyWith(
        isLoading: false,
        message: AuthMessage(message, AuthErrorType.otp),
        user: user,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthError(e.toString(), AuthErrorType.otp),
        message: null,
      );
    }
  }

  Future<void> resendEmailVerificationOTP(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final message = await _authRepository.resendEmailVerificationOTP(email);

      state = state.copyWith(
        isLoading: false,
        message: AuthMessage(
          message,
          AuthErrorType.otp,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: AuthError(
          e.toString(),
          AuthErrorType.otp,
        ),
      );
    }
  }
}
