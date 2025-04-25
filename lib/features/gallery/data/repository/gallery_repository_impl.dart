import 'package:megatronix/features/gallery/data/models/gallery_model.dart';
import 'package:megatronix/features/gallery/data/services/gallery_service.dart';
import 'package:megatronix/features/gallery/domain/entitites/gallery_entity.dart';
import 'package:megatronix/features/gallery/domain/repository/gallery_repository.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  final GalleryService _galleryService;
  GalleryRepositoryImpl(this._galleryService);

  @override
  Future<List<GalleryEntity>> getGalleries(
      {int page = 0, int size = 20}) async {
    try {
      final response =
          await _galleryService.getGalleries(page: page, size: size);
      final galleryModel =
          response.map((e) => GalleryModel.fromMap(e).toEntity()).toList();
      return galleryModel;
    } catch (e) {
      throw Exception(e);
    }
  }
}
