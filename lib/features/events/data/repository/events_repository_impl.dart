import 'package:megatronix/features/events/data/models/combo_model.dart';
import 'package:megatronix/features/events/data/models/domain_poster_model.dart';
import 'package:megatronix/features/events/data/models/events_model.dart';
import 'package:megatronix/features/events/data/services/events_service.dart';
import 'package:megatronix/features/events/domain/entities/combo_entity.dart';
import 'package:megatronix/features/events/domain/entities/domain_poster_entity.dart';
import 'package:megatronix/features/events/domain/entities/events_entity.dart';
import 'package:megatronix/features/events/domain/repository/events_repository.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsService _eventsServices;

  EventsRepositoryImpl(this._eventsServices);

  @override
  Future<List<EventsEntity>> getAllEvents() async {
    try {
      final response = await _eventsServices.getAllEvents();
      final List<EventsModel> events =
          response.map((e) => EventsModel.fromMap(e)).toList();
      return events.map((eventsModel) => eventsModel.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<EventsEntity>> getAllEventsByDomain(String domain) async {
    try {
      final response = await _eventsServices.getAllEventsByDomain(domain);
      // print(response);
      final List<EventsModel> events =
          response.map((e) => EventsModel.fromMap(e)).toList();
      return events.map((eventsModel) => eventsModel.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ComboEntity>> getAllCombosByDomain(String domain) async {
    try {
      final response = await _eventsServices.getAllCombosByDomain(domain);

      final List<ComboModel> combo =
          response.map((e) => ComboModel.fromMap(e)).toList();
      final comboList =
          combo.map((comboModel) => comboModel.toEntity()).toList();
      return comboList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DomainPosterEntity>> getAllDomainPosters() async {
    try {
      final response = await _eventsServices.getAllDomainPosters();
      final List<DomainPosterModel> domainPosters =
          response.map((e) => DomainPosterModel.fromMap(e)).toList();
      return domainPosters
          .map((domainPosterModel) => domainPosterModel.toEntity())
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
