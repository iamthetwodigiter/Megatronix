class ContactEntity {
  final String name;
  final String contact;

  ContactEntity({required this.name, required this.contact});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'contact': contact,
    };
  }

  factory ContactEntity.fromMap(Map<String, dynamic> map) {
    return ContactEntity(
      name: map['name'] as String,
      contact: map['contact'] as String,
    );
  }
}