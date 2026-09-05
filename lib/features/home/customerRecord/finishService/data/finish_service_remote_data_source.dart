import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FinishServiceRemoteDataSource {
  final Dio dio;

  FinishServiceRemoteDataSource(this.dio);

  Future<void> finishService({
    required String historyId,
    required String photoUrl,
  }) async {

    final response = await dio.put( 
      "/histories/$historyId/finish",
      data: {
        "photo_url": photoUrl,
      },
    );

  }
}
