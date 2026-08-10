import 'package:flutter/material.dart';
import '../domain/finish_service_usecase.dart';

class FinishServiceController extends ChangeNotifier {
  final FinishServiceUseCase useCase;

  FinishServiceController(this.useCase);

  bool isLoading = false;

  Future<void> finish({
    required String historyId,
    required String photoUrl,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await useCase.execute(
        historyId: historyId,
        photoUrl: photoUrl,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
