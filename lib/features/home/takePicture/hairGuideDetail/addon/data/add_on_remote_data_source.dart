// add_on_remote_data_source.dart
import 'package:dio/dio.dart';

class AddOnRemoteDataSource {
  final Dio dio;
  AddOnRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getAddOns() async {
    final response = await dio.get("/add-ons");
    return response.data;
  }

  Future<Map<String, dynamic>> generateAddOn({
    required String photoId,
    required Map<String, dynamic> addOnPayload,
  }) async {
    final response = await dio.post(
      "/generate-image/add-on",
      data: {
        "photo_id": photoId,
        "add_on": addOnPayload,
      },
    );
    return response.data;
  }
}
