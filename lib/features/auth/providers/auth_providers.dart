import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/auth/data/repository/auth_repository_impl.dart';
import 'package:megatronix/features/auth/data/services/auth_service.dart';
import 'package:megatronix/features/auth/domain/repository/auth_repository.dart';
import 'package:megatronix/features/auth/presentation/notifier/auth_notifier.dart';

// provider for auth services to be passed in auth repository constructor
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// provider for auth repository provider to be passed in auth notifier constructor
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authServices = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authServices);
});

// state notifier provider for auth notifier to handle all the auth related services methods
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
