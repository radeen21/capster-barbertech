import 'dart:io';

import 'package:dio/dio.dart';

class AddOnPhotoApi {
  final Dio dio;
  AddOnPhotoApi(this.dio);

  Future<Response> uploadPhoto(File file) async {
    return await dio.post(
      "/photos",
      data: FormData.fromMap({
        "photo": await MultipartFile.fromFile(file.path),
      }),
    );
  }

  Future<Response> generateAddOn({
    required String photoId,
    required Map<String, dynamic> addOn,
  }) async {
    return await dio.post(
      "/generate-image/add-on",
      data: {
        "photo_id": photoId,
        "add_on": addOn,
      },
    );
  }
}
