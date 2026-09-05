import 'package:dio/dio.dart';

class GrommingServiceRemoteDataSource {

  final Dio dio;

   GrommingServiceRemoteDataSource(this.dio);

  Future<List<Map<String, dynamic>>> getServices() async {
  const path = "/services";

  final response = await dio.get(path);

  return List<Map<String, dynamic>>.from(response.data["data"]);
}

}
