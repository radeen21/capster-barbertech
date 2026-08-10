import 'dart:io';

import 'package:capster_barbertech/features/home/takePicture/add-on/domain/take_and_generate_add_on_usecase.dart';
import 'package:capster_barbertech/features/home/takePicture/add-on/presentation/take_add_on_picture_state.dart';
import 'package:flutter/material.dart';

class TakeAddOnPictureController extends ChangeNotifier {
  final TakeAndGenerateAddOnUseCase useCase;

  TakeAddOnPictureController(this.useCase);

  TakeAddOnPictureState state = TakeAddOnInitial();

  Future<void> uploadAndGenerate({
    required String path,
    required Map<String, dynamic> addOn,
  }) async {
    state = TakeAddOnLoading();
    notifyListeners();

    try {
      final result = await useCase.execute(
        file: File(path),
        addOn: addOn,
      );

      state = TakeAddOnSuccess(
        uploadResponse: result["upload"],
        generateResponse: result["generate"],
      );
    } catch (e) {
      state = TakeAddOnError(e.toString());
    }

    notifyListeners();
  }

  void reset() {
    state = TakeAddOnInitial();
    notifyListeners();
  }
}
