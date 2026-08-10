import 'package:dio/dio.dart';

class RecommendationRemoteDataSource {
  final Dio dio;

  RecommendationRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> getGeneratedPhotos({
    required String userId,
    required String requestId,
  }) async {
    final response = await dio.get(
      "/photos/$userId/$requestId",
    );

    return response.data;
  }
}
