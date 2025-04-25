import 'package:megatronix/features/gallery/domain/entitites/gallery_entity.dart';

abstract interface class GalleryRepository {
  Future<List<GalleryEntity>> getGalleries({int page = 0, int size = 20});
}
