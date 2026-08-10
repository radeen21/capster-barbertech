import 'package:dio/dio.dart';

class GrommingServiceRemoteDataSource {

  final Dio dio;

   GrommingServiceRemoteDataSource(this.dio);

  Future<List<Map<String, dynamic>>> getServices() async {
  const path = "/services";

  // ✅ DEBUG URL
  print("🌐 BASE URL = ${dio.options.baseUrl}");
  print("🌐 FULL URL = ${dio.options.baseUrl}$path");

  final response = await dio.get(path);

  print("📦 SERVICES RESPONSE = ${response.data}");

  return List<Map<String, dynamic>>.from(response.data["data"]);
}

}
