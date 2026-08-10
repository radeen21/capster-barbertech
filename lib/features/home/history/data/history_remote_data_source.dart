import 'package:capster_barbertech/features/home/history/data/history_model.dart';
import 'package:dio/dio.dart';


class HistoryRemoteDataSource {
  final Dio dio;

  HistoryRemoteDataSource(this.dio);

  Future<List<HistoryModel>> getHistories() async {
    final response = await dio.get("/histories");

    final items = response.data["data"]["items"] as List;

    return items
        .map((json) => HistoryModel.fromJson(json))
        .toList();
  }

  Future startHaircut({required String phoneNumber, required String serviceId, required String haircutName, required List<Map<String, dynamic>> addOns}) async {}
}
