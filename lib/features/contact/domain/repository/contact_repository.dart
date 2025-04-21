import 'package:megatronix/features/contact/domain/entities/contact_entity.dart';

abstract class ContactRepository {
  Future<ContactEntity> createQuery({
    required String name,
    required String email,
    required String contact,
    required String query,
  });
}
