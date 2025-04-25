// {
//     "id": 2,
//     "domainName": "ROBOTICS",
//     "posterDetails": {
//         "secureUrl": "https://res.cloudinary.com/drxvzwtfr/image/upload/v1744149747/paridhi-2025/events/488662599_18454951462076118_8461770927685196498_n.jpg/2025-04-08/85A8F1.jpg",
//         "publicId": "paridhi-2025/events/488662599_18454951462076118_8461770927685196498_n.jpg/2025-04-08/85A8F1"
//     },
//     "createdAt": "2025-04-08 22:02:28",
//     "updatedAt": "2025-04-08 22:02:28",
//     "createdBy": "admin1@email.com",
//     "updatedBy": "admin1@email.com"
// }

import 'package:megatronix/features/events/domain/entities/domain_poster_entity.dart';

class DomainPosterModel {
  final int id;
  final String domainName;
  final String posterUrl;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;

  DomainPosterModel({
    required this.id,
    required this.domainName,
    required this.posterUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'domainName': domainName,
      'posterUrl': posterUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory DomainPosterModel.fromMap(Map<String, dynamic> map) {
    return DomainPosterModel(
      id: map['id'] as int,
      domainName: map['domainName'] as String,
      posterUrl:
          (map['posterDetails'] as Map<String, dynamic>)['secureUrl'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
    );
  }

  DomainPosterEntity toEntity() {
    return DomainPosterEntity(
      id: id,
      domainName: domainName,
      posterUrl: posterUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }
}
