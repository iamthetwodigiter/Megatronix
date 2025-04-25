import 'package:megatronix/features/event_registration/data/models/contact_model.dart';
import 'package:megatronix/features/event_registration/domain/entities/combo_registration_details.dart';

class ComboRegistrationDetailsModel {
  final int id;
  final String tid;
  final String teamName;
  final int eventId;
  final String eventName;
  final List<Contact> contacts;
  final List<String> gidList;
  final bool hasPlayed;
  final String position;
  final String registeredAt;
  final String updatedAt;
  final bool qualified;
  final bool paid;

  ComboRegistrationDetailsModel({
    required this.id,
    required this.tid,
    required this.teamName,
    required this.eventId,
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
      'eventId': eventId,
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

  factory ComboRegistrationDetailsModel.fromMap(Map<String, dynamic> map) {
    return ComboRegistrationDetailsModel(
      id: map['id'] as int,
      tid: map['tid'] as String,
      teamName: map['teamName'] as String,
      eventId: map['eventId'] as int,
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
  ComboRegistrationDetailsEntity toEntity() => ComboRegistrationDetailsEntity(
        id: id,
        tid: tid,
        teamName: teamName,
        eventId: eventId,
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
