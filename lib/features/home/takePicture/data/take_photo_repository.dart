import 'package:capster_barbertech/features/home/takePicture/data/take_photo_api.dart';

class TakePhotoRepository {
  final TakePhotoApi api;
  TakePhotoRepository(this.api);

  Future<Map<String, dynamic>> upload(String path) async {
    final response = await api.uploadPhoto(path);
    return response.data;
  }
}
