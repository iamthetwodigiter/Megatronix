class TeamEntity {
  final int id;
  final String name;
  final String email;
  final String year;
  final String linkedIn;
  final String instagram;
  final String github;
  final String facebook;
  final String profile;
  final String? designation;

  TeamEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.year,
    required this.linkedIn,
    required this.instagram,
    required this.github,
    required this.facebook,
    required this.profile,
    this.designation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'year': year,
      'linkedIn': linkedIn,
      'instagram': instagram,
      'github': github,
      'facebook': facebook,
      'profile': profile,
      'designation': designation,
    };
  }

  factory TeamEntity.fromMap(Map<String, dynamic> map) {
    return TeamEntity(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      year: map['year'] as String,
      linkedIn: (map['socialLinks'] as Map<String, dynamic>)['linkedInLink']
          as String,
      instagram: (map['socialLinks'] as Map<String, dynamic>)['instagramLink']
          as String,
      github:
          (map['socialLinks'] as Map<String, dynamic>)['githubLink'] as String,
      facebook: (map['socialLinks'] as Map<String, dynamic>)['facebookLink']
          as String,
      profile: map['imageLink'] as String,
      designation: map['designation'] as String?,
    );
  }
}