import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/main_registration/data/repository/main_registration_repository_impl.dart';
import 'package:megatronix/features/main_registration/data/services/main_registration_service.dart';
import 'package:megatronix/features/main_registration/domain/repository/main_registration_repository.dart';
import 'package:megatronix/features/main_registration/presentation/notifier/main_registration_notifier.dart';

final mainRegistrationServiceProvider =
    Provider<MainRegistrationService>((ref) => MainRegistrationService());

final mainRegistrationRepositoryProvider =
    Provider<MainRegistrationRepository>((ref) {
  final mainRegistrationServices = ref.watch(mainRegistrationServiceProvider);
  return MainRegistrationRepositoryImpl(mainRegistrationServices);
});

final mainRegistrationNotifierProvider =
    StateNotifierProvider<MainRegistrationNotifier, MainRegistrationState>(
        (ref) {
  final mainRegistrationRepository =
      ref.watch(mainRegistrationRepositoryProvider);
  return MainRegistrationNotifier(mainRegistrationRepository);
});
