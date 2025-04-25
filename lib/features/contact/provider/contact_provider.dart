import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/contact/data/repository/contact_repository_impl.dart';
import 'package:megatronix/features/contact/data/service/contact_service.dart';
import 'package:megatronix/features/contact/domain/repository/contact_repository.dart';
import 'package:megatronix/features/contact/presentation/notifier/contact_notifier.dart';

final contactServiceProvider = Provider<ContactService>((ref) {
  return ContactService();
});

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final contactService = ref.read(contactServiceProvider);
  return ContactRepositoryImpl(contactService);
});

final contactNotifierProvider =
    StateNotifierProvider<ContactNotifier, ContactState>((ref) {
  final contactRepository = ref.read(contactRepositoryProvider);
  return ContactNotifier(contactRepository);
});
