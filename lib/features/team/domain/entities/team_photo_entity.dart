class TeamPosterEntity {
  final List<TeamPhotoEntity> developers;
  final List<TeamPhotoEntity> members;

  TeamPosterEntity({required this.developers, required this.members});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'developers': developers.map((x) => x.toMap()).toList(),
      'members': members.map((x) => x.toMap()).toList(),
    };
  }

  factory TeamPosterEntity.fromMap(Map<String, dynamic> map) {
    return TeamPosterEntity(
      developers: List<TeamPhotoEntity>.from(
        (map['developers'] as List<dynamic>).map<TeamPhotoEntity>(
          (x) => TeamPhotoEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      members: List<TeamPhotoEntity>.from(
        (map['members'] as List<dynamic>).map<TeamPhotoEntity>(
          (x) => TeamPhotoEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class TeamPhotoEntity {
  final int id;
  final String category;
  final String photo;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;

  TeamPhotoEntity({
    required this.id,
    required this.category,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'photo': photo,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory TeamPhotoEntity.fromMap(Map<String, dynamic> map) {
    return TeamPhotoEntity(
      id: map['id'] as int,
      category: map['category'] as String,
      photo:
          (map['imageDetails'] as Map<String, dynamic>)['secureUrl'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
    );
  }
}
