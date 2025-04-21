import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/contact/domain/entities/contact_entity.dart';
import 'package:megatronix/features/contact/domain/repository/contact_repository.dart';

class ContactState {
  final bool isLoading;
  final ContactEntity? contactQuery;
  final String? error;

  ContactState({
    this.isLoading = false,
    this.contactQuery,
    this.error,
  });

  ContactState copyWith({
    bool? isLoading,
    ContactEntity? contactQuery,
    String? error,
  }) {
    return ContactState(
      isLoading: isLoading ?? this.isLoading,
      contactQuery: contactQuery ?? this.contactQuery,
      error: error ?? this.error,
    );
  }
}

class ContactNotifier extends StateNotifier<ContactState> {
  final ContactRepository _contactRepository;
  ContactNotifier(this._contactRepository) : super(ContactState());

  Future<void> createQuery({
    required String name,
    required String email,
    required String contact,
    required String query,
  }) async {
    state = state.copyWith(isLoading: true, error: null, contactQuery: null);
    try {
      final contactQuery = await _contactRepository.createQuery(
          name: name, email: email, contact: contact, query: query);
      state = state.copyWith(
          isLoading: false, contactQuery: contactQuery, error: null);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: e.toString(), contactQuery: null);
    }
  }

  Future<void> resetContactQueryState() async {
    state = state.copyWith(contactQuery: null);
  }
}
