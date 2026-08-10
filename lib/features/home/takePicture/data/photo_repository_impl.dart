import 'dart:io';
import 'dart:typed_data';
import '../domain/photo_repository.dart';
import 'photo_remote_data_source.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource remote;

  PhotoRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> uploadPhoto(File file) {
    return remote.uploadPhoto(file);
  }

  @override
  Future<Map<String, dynamic>> analyzePhoto({
    required String photoId,
    String? serviceId,
  }) {
    return remote.analyzePhoto(photoId: photoId, serviceId: serviceId);
  }

  @override
  Future<Map<String, dynamic>> generateImageByName({
    required String photoId,
    required List<Map<String, dynamic>> recommendation,
  }) {
    return remote.generateImageByName(
      photoId: photoId,
      recommendation: recommendation,
    );
  }

  @override
  Future<Map<String, dynamic>> generateImageAddOn({
    required String photoId,
    required Map<String, dynamic> addOn,
  }) {
    return remote.generateImageAddOn(photoId: photoId, addOn: addOn);
  }

  @override
  Future<Uint8List> getPhotoById(String photoId) {
    return remote.getPhotoById(photoId);
  }

  @override
  Future<Uint8List> getPhotoByUrl(String url) {
    return remote.getPhotoByUrl(url);
  }
}
