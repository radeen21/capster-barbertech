import 'dart:io';

import 'package:capster_barbertech/features/home/takePicture/add-on/domain/add_on_photo_repository.dart';

class TakeAndGenerateAddOnUseCase {
  final AddOnPhotoRepository repository;

  TakeAndGenerateAddOnUseCase(this.repository);

  Future<Map<String, dynamic>> execute({
    required File file,
    required Map<String, dynamic> addOn,
  }) async {
    final uploadResponse = await repository.uploadPhoto(file);

    if (uploadResponse["code"] != 201) {
      throw Exception("Upload foto gagal");
    }

    final photoId = uploadResponse["data"]["id"];

    final generateResponse = await repository.generateAddOn(
      photoId: photoId,
      addOn: addOn,
    );

    return {
      "upload": uploadResponse,
      "generate": generateResponse,
    };
  }
}
