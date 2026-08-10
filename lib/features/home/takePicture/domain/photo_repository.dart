import 'dart:io';
import 'dart:typed_data';

abstract class PhotoRepository {
  Future<Map<String, dynamic>> uploadPhoto(File file);

  Future<Map<String, dynamic>> analyzePhoto({
    required String photoId,
    String? serviceId,
  });

  Future<Map<String, dynamic>> generateImageByName({
    required String photoId,
    required List<Map<String, dynamic>> recommendation,
  });

  Future<Map<String, dynamic>> generateImageAddOn({
    required String photoId,
    required Map<String, dynamic> addOn,
  });

  Future<Uint8List> getPhotoById(String photoId);

  Future<Uint8List> getPhotoByUrl(String url);
}
