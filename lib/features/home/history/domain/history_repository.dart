import 'package:capster_barbertech/features/home/history/domain/history_entity.dart';

abstract class HistoryRepository {
  Future<List<HistoryEntity>> getHistories();
}
