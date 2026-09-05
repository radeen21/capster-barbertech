import 'package:capster_barbertech/features/home/history/domain/get_history_usecase.dart';
import 'package:capster_barbertech/features/home/history/domain/history_entity.dart';
import 'package:flutter/material.dart';

class HistoryController extends ChangeNotifier {
  final GetHistoriesUseCase getHistoriesUseCase;

  HistoryController(this.getHistoriesUseCase);

  bool isLoading = false;
  List<HistoryEntity> histories = [];

  Future<void> fetchHistories() async {
    try {
      isLoading = true;
      notifyListeners();

      histories = await getHistoriesUseCase();

      debugPrint("HISTORIES LOADED: ${histories.length}");
    } catch (e) {
      debugPrint("FETCH HISTORIES ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
