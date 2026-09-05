import 'package:dio/dio.dart';
import 'capster_history_model.dart';

class CapsterHistoryRemoteDataSource {
  final Dio dio;

  CapsterHistoryRemoteDataSource(this.dio);

  Future<List<CapsterHistoryModel>> fetchHistories() async {
    try {

      final response = await dio.get("/histories/capster");
      final baseUrl = dio.options.baseUrl;
      final items = response.data["data"]["items"] as List;

      for (var e in items) {
        print("---------------");
        print("ID: ${e["id"]}");
        print("RAW haircut_url: ${e["haircut_url"]}");
        print(
            "FULL haircut_url: ${e["haircut_url"] != null && e["haircut_url"] != "" 
                ? "$baseUrl/photos${e["haircut_url"]}" 
                : "EMPTY"}");
      }

      return items
          .map((e) => CapsterHistoryModel.fromJson(e, baseUrl))
          .toList();
    } catch (e, s) {
      rethrow;
    }
  }
}
