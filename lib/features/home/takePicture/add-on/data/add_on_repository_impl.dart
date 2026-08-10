import 'dart:io';

import 'package:capster_barbertech/features/home/takePicture/add-on/data/add_on_photo_api.dart';
import 'package:capster_barbertech/features/home/takePicture/add-on/domain/add_on_photo_repository.dart';

class AddOnPhotoRepositoryImpl implements AddOnPhotoRepository {
  final AddOnPhotoApi api;

  AddOnPhotoRepositoryImpl(this.api);

  @override
  Future<Map<String, dynamic>> uploadPhoto(File file) async {
    final response = await api.uploadPhoto(file);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> generateAddOn({
    required String photoId,
    required Map<String, dynamic> addOn,
  }) async {
    final response = await api.generateAddOn(
      photoId: photoId,
      addOn: addOn,
    );
    return response.data;
  }
}
