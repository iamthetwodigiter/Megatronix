import 'package:megatronix/features/event_registration/domain/entities/contact_entity.dart';

class Contact {
  final String name;
  final String contact;

  Contact({required this.name, required this.contact});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'contact': contact,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] as String,
      contact: map['contact'] as String,
    );
  }
  ContactEntity toEntity() => ContactEntity(name: name, contact: contact);
}
