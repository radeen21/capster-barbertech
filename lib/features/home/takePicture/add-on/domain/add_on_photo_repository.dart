import 'dart:io';

abstract class AddOnPhotoRepository {
  Future<Map<String, dynamic>> uploadPhoto(File file);

  Future<Map<String, dynamic>> generateAddOn({
    required String photoId,
    required Map<String, dynamic> addOn,
  });
}
