import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FinishServiceRemoteDataSource {
  final Dio dio;

  FinishServiceRemoteDataSource(this.dio);

  Future<void> finishService({
    required String historyId,
    required String photoUrl,
  }) async {
    debugPrint("➡️ PUT /histories/$historyId/finish");

    final response = await dio.put( // ⬅️ GANTI POST → PUT
      "/histories/$historyId/finish",
      data: {
        "photo_url": photoUrl,
      },
    );

    debugPrint("✅ FINISH SERVICE RESPONSE = ${response.data}");
  }
}
