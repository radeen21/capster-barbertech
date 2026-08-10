import 'package:capster_barbertech/features/home/customerRecord/domain/capster_history_entity.dart';
import 'package:capster_barbertech/features/home/customerRecord/domain/capster_history_repository.dart';

import 'capster_history_remote_data_source.dart';

class CapsterHistoryRepositoryImpl
    implements CapsterHistoryRepository {
  final CapsterHistoryRemoteDataSource remote;

  CapsterHistoryRepositoryImpl(this.remote);

  @override
  Future<List<CapsterHistoryEntity>> getHistories() async {
    final models = await remote.fetchHistories();
    return models.map((e) => e.toEntity()).toList();
  }
}
