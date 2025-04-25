import 'package:megatronix/features/team/domain/entities/team_photo_entity.dart';

class TeamPosterModel {
  final List<TeamPhotoModel> developers;
  final List<TeamPhotoModel> members;

  TeamPosterModel({required this.developers, required this.members});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'developers': developers.map((x) => x.toMap()).toList(),
      'members': members.map((x) => x.toMap()).toList(),
    };
  }

  factory TeamPosterModel.fromMap(Map<String, dynamic> map) {
    return TeamPosterModel(
      developers: List<TeamPhotoModel>.from(
        (map['developers'] as List<dynamic>).map<TeamPhotoModel>(
          (x) => TeamPhotoModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      members: List<TeamPhotoModel>.from(
        (map['members'] as List<dynamic>).map<TeamPhotoModel>(
          (x) => TeamPhotoModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  TeamPosterEntity toEntity() {
    return TeamPosterEntity(
      developers: developers.map((dev) => dev.toEntity()).toList(),
      members: members.map((member) => member.toEntity()).toList(),
    );
  }
}

class TeamPhotoModel {
  final int id;
  final String category;
  final String photo;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;

  TeamPhotoModel({
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

  factory TeamPhotoModel.fromMap(Map<String, dynamic> map) {
    return TeamPhotoModel(
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

  TeamPhotoEntity toEntity() {
    return TeamPhotoEntity(
      id: id,
      category: category,
      photo: photo,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }
}
