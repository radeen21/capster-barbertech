import 'capster_history_entity.dart';

abstract class CapsterHistoryRepository {
  Future<List<CapsterHistoryEntity>> getHistories();
}
