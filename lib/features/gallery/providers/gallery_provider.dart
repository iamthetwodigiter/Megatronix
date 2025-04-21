import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:megatronix/features/gallery/data/repository/gallery_repository_impl.dart';
import 'package:megatronix/features/gallery/data/services/gallery_service.dart';
import 'package:megatronix/features/gallery/domain/repository/gallery_repository.dart';
import 'package:megatronix/features/gallery/presentation/notifier/gallery_notifier.dart';

final galleryServiceProvier =
    Provider<GalleryService>((ref) => GalleryService());

final galleryRepositoryProvider = Provider<GalleryRepository>((ref) {
  final galleryService = ref.read(galleryServiceProvier);
  return GalleryRepositoryImpl(galleryService);
});

final galleryNotifierProvider =
    StateNotifierProvider<GalleryNotifier, GalleryState>((ref) {
  final galleryRepository = ref.read(galleryRepositoryProvider);
  return GalleryNotifier(galleryRepository);
});
