import 'package:megatronix/features/contact/data/models/contact_model.dart';
import 'package:megatronix/features/contact/data/service/contact_service.dart';
import 'package:megatronix/features/contact/domain/entities/contact_entity.dart';
import 'package:megatronix/features/contact/domain/repository/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactService _contactService;
  ContactRepositoryImpl(this._contactService);

  @override
  Future<ContactEntity> createQuery({
    required String name,
    required String email,
    required String contact,
    required String query,
  }) async {
    try {
      final response = await _contactService.createQuery(
          name: name, email: email, contact: contact, query: query);
      final ContactModel contactModel = ContactModel.fromMap(response);
      return contactModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
