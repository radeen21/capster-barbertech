import 'package:flutter/material.dart';
import '../domain/start_service_usecase.dart';

class StartServiceController extends ChangeNotifier {
  final StartServiceUseCase useCase;

  StartServiceController(this.useCase);

  bool isLoading = false;
  String? error;

  Future<bool> startService({
    required String phoneNumber,
    required String serviceId,
    required String haircutName,
    required List<Map<String, dynamic>> addOns,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await useCase.execute(
        phoneNumber: phoneNumber,
        serviceId: serviceId,
        haircutName: haircutName,
        addOns: addOns,
      );

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
