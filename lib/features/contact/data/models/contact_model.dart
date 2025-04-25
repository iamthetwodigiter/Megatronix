import 'package:megatronix/features/contact/domain/entities/contact_entity.dart';

class ContactModel {
  final int id;
  final String name;
  final String email;
  final String contact;
  final String query;
  final bool resolved;
  final String? response;
  final String? resolvedBy;
  final String createdAt;
  final String updatedAt;

  ContactModel({
    required this.id,
    required this.name,
    required this.email,
    required this.contact,
    required this.query,
    required this.resolved,
    required this.response,
    required this.resolvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'contact': contact,
      'query': query,
      'resolved': resolved,
      'response': response,
      'resolvedBy': resolvedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      contact: map['contact'] as String,
      query: map['query'] as String,
      resolved: map['resolved'] as bool,
      response: map['response'] != null ? map['response'] as String : null,
      resolvedBy:
          map['resolvedBy'] != null ? map['resolvedBy'] as String : null,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
    );
  }

  ContactEntity toEntity() {
    return ContactEntity(
      id: id,
      name: name,
      email: email,
      contact: contact,
      query: query,
      resolved: resolved,
      response: response,
      resolvedBy: resolvedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
