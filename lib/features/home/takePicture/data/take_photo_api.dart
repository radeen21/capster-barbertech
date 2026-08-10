import 'package:dio/dio.dart';

class TakePhotoApi {
  final Dio dio;
  TakePhotoApi(this.dio);

  Future<Response> uploadPhoto(String filePath) async {
    FormData formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(filePath),
    });

    return await dio.post(
      "/photos",
      data: formData,
    );
  }
}
