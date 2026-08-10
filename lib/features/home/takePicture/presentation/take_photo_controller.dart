import 'dart:io';

import 'package:capster_barbertech/features/auth/domain/session/auth_session_repository.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:capster_barbertech/features/home/takePicture/presentation/take_photo_state.dart';
import 'package:flutter/material.dart';

class TakePhotoController extends ChangeNotifier {
  final TakeAndAnalyzePhotoUseCase useCase;
  final AuthSessionRepository sessionRepository;

  TakePhotoController({required this.useCase, required this.sessionRepository});

  String get userId => sessionRepository.getUserId()!;
  String get role => sessionRepository.getRole() ?? "user";

  TakePhotoState state = TakePhotoInitial();

 Future<void> uploadPhoto({
  required String path,
  required String serviceId,
  String? serviceType,
  Map<String, dynamic>? addOnPayload,
}) async {
  state = TakePhotoLoading();
  notifyListeners();

  try {
    final result = await useCase.execute(
      File(path),
      serviceId: serviceId,
      serviceType: serviceType,
      addOnPayload: addOnPayload,
    );

    state = TakePhotoSuccess(
      uploadResponse: result["upload"],
      analyzeResponse: result["analyze"],
      generateResponse: result["generate"],
    );
  } catch (e) {
    state = TakePhotoError(e.toString());
  }

  notifyListeners();
}

}
