import 'package:megatronix/features/events/domain/entities/combo_entity.dart';
import 'package:megatronix/features/events/domain/entities/domain_poster_entity.dart';
import 'package:megatronix/features/events/domain/entities/events_entity.dart';

abstract interface class EventsRepository {
  Future<List<EventsEntity>> getAllEvents();
  Future<List<EventsEntity>> getAllEventsByDomain(String domain);
  Future<List<ComboEntity>> getAllCombosByDomain(String domain);
  Future<List<DomainPosterEntity>> getAllDomainPosters();
}
