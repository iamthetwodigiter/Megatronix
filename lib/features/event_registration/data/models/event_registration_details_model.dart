import 'package:megatronix/features/event_registration/data/models/contact_model.dart';
import 'package:megatronix/features/event_registration/domain/entities/event_registration_details_entity.dart';

class EventRegistrationDetailsModel {
  final int id;
  final String tid;
  final String teamName;
  final int eventID;
  final String eventName;
  final List<Contact> contacts;
  final List<String> gidList;
  final bool hasPlayed;
  final String position;
  final String registeredAt;
  final String updatedAt;
  final bool qualified;
  final bool paid;

  EventRegistrationDetailsModel({
    required this.id,
    required this.tid,
    required this.teamName,
    required this.eventID,
    required this.eventName,
    required this.contacts,
    required this.gidList,
    required this.hasPlayed,
    required this.position,
    required this.registeredAt,
    required this.updatedAt,
    required this.qualified,
    required this.paid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tid': tid,
      'teamName': teamName,
      'eventID': eventID,
      'eventName': eventName,
      'contacts': contacts.map((x) => x.toMap()).toList(),
      'gidList': gidList,
      'hasPlayed': hasPlayed,
      'position': position,
      'registeredAt': registeredAt,
      'updatedAt': updatedAt,
      'qualified': qualified,
      'paid': paid,
    };
  }

  factory EventRegistrationDetailsModel.fromMap(Map<String, dynamic> map) {
    return EventRegistrationDetailsModel(
      id: map['id'] as int,
      tid: map['tid'] as String,
      teamName: map['teamName'] as String,
      eventID: map['eventId'] as int,
      eventName: map['eventName'] as String,
      contacts: List<Contact>.from(
        (map['contacts'] as List<dynamic>).map<Contact>(
          (x) => Contact.fromMap(x as Map<String, dynamic>),
        ),
      ),
      gidList: List<String>.from(
        (map['gidList'] as List<dynamic>),
      ),
      hasPlayed: map['hasPlayed'] as bool,
      position: map['position'] as String,
      registeredAt: map['registeredAt'] as String,
      updatedAt: map['updatedAt'] as String,
      qualified: map['qualified'] as bool,
      paid: map['paid'] as bool,
    );
  }
  EventRegistrationDetailsEntity toEntity() {
    return EventRegistrationDetailsEntity(
      id: id,
      tid: tid,
      teamName: teamName,
      eventID: eventID,
      eventName: eventName,
      contacts: contacts.map((contact) => contact.toEntity()).toList(),
      gidList: gidList,
      hasPlayed: hasPlayed,
      position: position,
      registeredAt: registeredAt,
      updatedAt: updatedAt,
      qualified: qualified,
      paid: paid,
    );
  }
}
