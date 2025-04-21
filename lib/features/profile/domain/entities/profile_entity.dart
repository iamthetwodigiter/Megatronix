class ProfileEntity {
  final int id;
  final String? profilePicture;
  final String name;
  final String email;
  final String? contact;
  final String? college;
  final String? year;
  final String? department;
  final String? roll;
  final List<dynamic>? gids;
  final String? lastLogin;
  final String? createdAt;
  final String? updatedAt;
  final bool profileCreated;
  final bool isVerified;

  ProfileEntity({
    required this.id,
    required this.profilePicture,
    required this.name,
    required this.email,
    required this.contact,
    required this.college,
    required this.year,
    required this.department,
    required this.roll,
    required this.gids,
    required this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
    required this.profileCreated,
    required this.isVerified,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'profilePicture': profilePicture,
      'name': name,
      'email': email,
      'contact': contact,
      'college': college,
      'year': year,
      'department': department,
      'roll': roll,
      'gids': gids,
      'lastLogin': lastLogin,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'profileCreated': profileCreated,
      'isVerified': isVerified,
    };
  }

  factory ProfileEntity.fromMap(Map<String, dynamic> map) {
    return ProfileEntity(
      id: map['id'] as int,
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
      name: map['name'] as String,
      email: map['email'] as String,
      contact: map['contact'] != null ? map['contact'] as String : null,
      college: map['college'] != null ? map['college'] as String : null,
      year: map['year'] != null ? map['year'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      roll: map['roll'] != null ? map['roll'] as String : null,
      gids: map['gids'] != null
          ? List<dynamic>.from((map['gids'] as List<dynamic>))
          : null,
      lastLogin: map['lastLogin'] != null ? map['lastLogin'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      profileCreated: map['profileCreated'] as bool,
      isVerified: map['verified'] as bool,
    );
  }
}
