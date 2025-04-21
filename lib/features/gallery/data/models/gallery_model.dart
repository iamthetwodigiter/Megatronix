import 'package:megatronix/features/gallery/domain/entitites/gallery_entity.dart';

class GalleryModel {
  final int id;
  final String batchYear;
  final String imageLink;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;

  GalleryModel({
    required this.id,
    required this.batchYear,
    required this.imageLink,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'batchYear': batchYear,
      'imageLink': imageLink,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory GalleryModel.fromMap(Map<String, dynamic> map) {
    return GalleryModel(
      id: map['id'] as int,
      batchYear: map['batchYear'] as String,
      imageLink:
          (map['imageDetails'] as Map<String, dynamic>)['secureUrl'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
    );
  }

  GalleryEntity toEntity() {
    return GalleryEntity(
      id: id,
      batchYear: batchYear,
      imageLink: imageLink,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }
}
