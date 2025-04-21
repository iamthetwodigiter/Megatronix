import 'package:megatronix/features/events/domain/entities/events_entity.dart';

class EventsModel {
  final int id;
  final String domain;
  final String name;
  final String eventType;
  final String eventDate;
  final String description;
  final String venue;
  final List<String> coordinatorDetails;
  final String eventPictureUrl;
  final String ruleBook;
  final num minPlayers;
  final num maxPlayers;
  final num registrationFee;
  final num prizePool;
  final String createdAt;
  final String updatedAt;
  final String createdByUserName;
  final bool registrationOpen;

  EventsModel({
    required this.id,
    required this.domain,
    required this.name,
    required this.eventType,
    required this.eventDate,
    required this.description,
    required this.venue,
    required this.coordinatorDetails,
    required this.eventPictureUrl,
    required this.ruleBook,
    required this.minPlayers,
    required this.maxPlayers,
    required this.registrationFee,
    required this.prizePool,
    required this.createdAt,
    required this.updatedAt,
    required this.createdByUserName,
    required this.registrationOpen,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'domain': domain,
      'name': name,
      'eventType': eventType,
      'eventDate': eventDate,
      'description': description,
      'venue': venue,
      'coordinatorDetails': coordinatorDetails,
      'eventPictureUrl': eventPictureUrl,
      'ruleBook': ruleBook,
      'minPlayers': minPlayers,
      'maxPlayers': maxPlayers,
      'registrationFee': registrationFee,
      'prizePool': prizePool,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdByUserName': createdByUserName,
      'registrationOpen': registrationOpen,
    };
  }

  factory EventsModel.fromMap(Map<String, dynamic> map) {
    return EventsModel(
      id: map['id'] as int,
      domain: map['domain'] as String,
      name: map['name'] as String,
      eventType: map['eventType'] as String,
      eventDate: map['eventDate'] as String,
      description: map['description'] as String,
      venue: map['venue'] as String,
      coordinatorDetails:
          List<String>.from((map['coordinatorDetails'] as List<dynamic>)),
      eventPictureUrl:
          (map['imageDetails'] as Map<String, dynamic>)['secure_url'] as String,
      ruleBook: map['ruleBook'] as String,
      minPlayers: map['minPlayers'] as num,
      maxPlayers: map['maxPlayers'] as num,
      registrationFee: map['registrationFee'] as num,
      prizePool: map['prizePool'] as num,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      createdByUserName: map['createdByUserName'] as String,
      registrationOpen: map['registrationOpen'] as bool,
    );
  }

  EventsEntity toEntity() => EventsEntity(
        id: id,
        domain: domain,
        name: name,
        eventType: eventType,
        eventDate: eventDate,
        description: description,
        venue: venue,
        coordinatorDetails: coordinatorDetails,
        eventPictureUrl: eventPictureUrl,
        ruleBook: ruleBook,
        minPlayers: minPlayers,
        maxPlayers: maxPlayers,
        registrationFee: registrationFee,
        prizePool: prizePool,
        createdAt: createdAt,
        updatedAt: updatedAt,
        createdByUserName: createdByUserName,
        registrationOpen: registrationOpen,
      );
}
