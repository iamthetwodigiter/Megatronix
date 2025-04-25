import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/profile/data/repository/profile_repository_impl.dart';
import 'package:megatronix/features/profile/data/services/profile_service.dart';
import 'package:megatronix/features/profile/domain/repository/profile_repository.dart';
import 'package:megatronix/features/profile/presentation/notifier/profile_notifier.dart';

final profileServiceProvider =
    Provider<ProfileService>((ref) => ProfileService());

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final profileServices = ref.watch(profileServiceProvider);
  return ProfileRepositoryImpl(profileServices);
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ProfileNotifier(profileRepository);
});
