import 'package:capster_barbertech/features/home/history/domain/history_entity.dart';
import 'package:capster_barbertech/features/home/history/domain/history_repository.dart';

class GetHistoriesUseCase {
  final HistoryRepository repository;

  GetHistoriesUseCase(this.repository);

  Future<List<HistoryEntity>> call() {
    return repository.getHistories();
  }
}
