import 'package:megatronix/features/events/data/models/events_model.dart';
import 'package:megatronix/features/events/domain/entities/combo_entity.dart';

class ComboModel {
  final int id;
  final String name;
  final String description;
  final String domain;
  final List<EventsModel> events;
  final String image;
  final double registrationFee;
  final String createdAt;
  final String updatedAt;
  final String createdByUsername;
  final bool registrationOpen;

  ComboModel({
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

  factory ComboModel.fromMap(Map<String, dynamic> map) {
    return ComboModel(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      domain: map['domain'] as String,
      events: List<EventsModel>.from(
        (map['events'] as List<dynamic>?)?.map<EventsModel>(
              (x) => EventsModel.fromMap(x as Map<String, dynamic>),
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

  ComboEntity toEntity() => ComboEntity(
        id: id,
        name: name,
        description: description,
        domain: domain,
        events: events.map((e) => e.toEntity()).toList(),
        image: image,
        registrationFee: registrationFee,
        createdAt: createdAt,
        updatedAt: updatedAt,
        createdByUsername: createdByUsername,
        registrationOpen: registrationOpen,
      );
}
