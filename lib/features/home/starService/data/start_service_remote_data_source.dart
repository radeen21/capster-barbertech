import 'package:dio/dio.dart';

abstract class StartServiceRemoteDataSource {
  Future<Map<String, dynamic>> startService({
    required String phoneNumber,
    required String serviceId,
    required String haircutName,
    required List<Map<String, dynamic>> addOns,
  });
}

class StartServiceRemoteDataSourceImpl implements StartServiceRemoteDataSource {
  final Dio dio;

  StartServiceRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> startService({
    required String phoneNumber,
    required String serviceId,
    required String haircutName,
    required List<Map<String, dynamic>> addOns,
  }) async {
    final body = {
      "phone_number": phoneNumber,
      "service_id": serviceId,
      "haircut_name": haircutName,
      "add_ons": addOns,
    };

    try {
      final response = await dio.post("/histories/start", data: body);

      return response.data;
    } on DioException catch (e) {

      String message = "Terjadi kesalahan";
      final statusCode = e.response?.statusCode;

      if (e.response != null) {
        final data = e.response?.data;

        if (data is Map<String, dynamic>) {
          // Ambil message dari backend kalau ada
          message =
              data["message"] ??
              data["error"] ??
              data["detail"] ??
              "Error $statusCode";
        } else if (data is String) {
          message = data;
        } else {
          message = "Error $statusCode";
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        message = "Tidak dapat terhubung ke server";
      }

      throw Exception(message);
    }
  }
}
