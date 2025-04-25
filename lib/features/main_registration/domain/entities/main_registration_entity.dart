class MainRegistrationEntity {
  final int id;
  final String gid;
  final String name;
  final String email;
  final String contact;
  final String college;
  final String year;
  final String department;
  final String rollNo;
  final bool hasPaid;
  final String registeredAt;

  MainRegistrationEntity({
    required this.id,
    required this.gid,
    required this.name,
    required this.email,
    required this.contact,
    required this.college,
    required this.year,
    required this.department,
    required this.rollNo,
    required this.hasPaid,
    required this.registeredAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'gid': gid,
      'name': name,
      'email': email,
      'contact': contact,
      'college': college,
      'year': year,
      'department': department,
      'rollNo': rollNo,
      'hasPaid': hasPaid,
      'registeredAt': registeredAt,
    };
  }

  factory MainRegistrationEntity.fromMap(Map<String, dynamic> map) {
    return MainRegistrationEntity(
      id: map['id'] as int,
      gid: map['gid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      contact: map['contact'] as String,
      college: map['college'] as String,
      year: map['year'] as String,
      department: map['department'] as String,
      rollNo: map['rollNo'] as String,
      hasPaid: map['hasPaid'] as bool,
      registeredAt: map['registeredAt'] as String,
    );
  }

  
}
