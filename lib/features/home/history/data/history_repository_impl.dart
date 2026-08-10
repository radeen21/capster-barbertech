import 'package:capster_barbertech/features/home/history/domain/history_entity.dart';
import 'package:capster_barbertech/features/home/history/domain/history_repository.dart';
import 'history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remote;

  HistoryRepositoryImpl(this.remote);

  @override
  Future<List<HistoryEntity>> getHistories() async {
    final models = await remote.getHistories();
    return models.map((e) => e.toEntity()).toList();
  }
}
