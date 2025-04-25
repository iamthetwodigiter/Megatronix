class DomainPosterEntity {
  final int id;
  final String domainName;
  final String posterUrl;
  final String createdAt;
  final String updatedAt;
  final String createdBy;
  final String updatedBy;

  DomainPosterEntity({
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

  factory DomainPosterEntity.fromMap(Map<String, dynamic> map) {
    return DomainPosterEntity(
      id: map['id'] as int,
      domainName: map['domainName'] as String,
      posterUrl: (map['posterDetails'] as Map<String, dynamic>)['secureUrl'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
    );
  }
}
