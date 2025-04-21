import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/gallery/domain/entitites/gallery_entity.dart';
import 'package:megatronix/features/gallery/domain/repository/gallery_repository.dart';

class GalleryState {
  final bool isLoading;
  final List<GalleryEntity>? galleries;
  final String? error;

  GalleryState({
    this.isLoading = false,
    this.galleries,
    this.error,
  });

  GalleryState copyWith({
    bool? isLoading,
    List<GalleryEntity>? galleries,
    String? error,
  }) {
    return GalleryState(
      isLoading: isLoading ?? this.isLoading,
      galleries: galleries ?? this.galleries,
      error: error ?? this.error,
    );
  }
}

class GalleryNotifier extends StateNotifier<GalleryState> {
  final GalleryRepository _galleryRepository;
  GalleryNotifier(this._galleryRepository) : super(GalleryState());

  Future<void> getGalleries({int page = 0, int size = 20}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final galleries =
          await _galleryRepository.getGalleries(page: page, size: size);
      state = state.copyWith(isLoading: false, galleries: galleries);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
