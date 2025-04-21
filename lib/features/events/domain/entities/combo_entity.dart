import 'package:megatronix/features/events/domain/entities/events_entity.dart';

class ComboEntity {
  final int id;
  final String name;
  final String description;
  final String domain;
  final List<EventsEntity> events;
  final String image;
  final double registrationFee;
  final String createdAt;
  final String updatedAt;
  final String createdByUsername;
  final bool registrationOpen;

  ComboEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.domain,
    required this.events,
    required this.image,
    required this.registrationFee,
    required this.createdAt,
    required this.updatedAt,
    required this.createdByUsername,
    required this.registrationOpen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'domain': domain,
      'events': events.map((x) => x.toMap()).toList(),
      'image': image,
      'registrationFee': registrationFee,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdByUsername': createdByUsername,
      'registrationOpen': registrationOpen,
    };
  }

  factory ComboEntity.fromMap(Map<String, dynamic> map) {
    return ComboEntity(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      domain: map['domain'] as String,
      events: List<EventsEntity>.from(
        (map['events'] as List<dynamic>?)?.map<EventsEntity>(
              (x) => EventsEntity.fromMap(x as Map<String, dynamic>),
            ) ??
            [],
      ),
      image:
          (map['imageDetails'] as Map<String, dynamic>)['secure_url'] as String,
      registrationFee: map['registrationFee'] as double,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      createdByUsername: map['createdByUsername'] as String,
      registrationOpen: map['registrationOpen'] as bool,
    );
  }
}
