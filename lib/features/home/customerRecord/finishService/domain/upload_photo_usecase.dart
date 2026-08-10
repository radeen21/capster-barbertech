// domain/upload_photo_usecase.dart
import 'dart:io';
import 'package:capster_barbertech/features/home/takePicture/domain/photo_repository.dart';

class UploadPhotoUseCase {
  final PhotoRepository repository;

  UploadPhotoUseCase(this.repository);

  Future<String> execute(File file) async {
    final response = await repository.uploadPhoto(file);

    if (response["code"] != 201) {
      throw Exception(response["message"] ?? "Upload gagal");
    }

    return response["data"]["url"] as String;
  }
}
