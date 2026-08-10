import 'package:capster_barbertech/features/home/customerRecord/domain/get_capster_history_usecase.dart';
import 'package:flutter/material.dart';
import '../domain/capster_history_entity.dart';

class CapsterHistoryController extends ChangeNotifier {
  final GetCapsterHistoriesUseCase useCase;

  CapsterHistoryController(this.useCase);

  bool isLoading = false;
  List<CapsterHistoryEntity> histories = [];

  Future<void> fetch() async {
    isLoading = true;
    notifyListeners();

    try {
      histories = await useCase.execute();
    } catch (e) {
      debugPrint("❌ CAPSTER HISTORY ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
