import 'capster_history_entity.dart';
import 'capster_history_repository.dart';

class GetCapsterHistoriesUseCase {
  final CapsterHistoryRepository repository;

  GetCapsterHistoriesUseCase(this.repository);

  Future<List<CapsterHistoryEntity>> execute() {
    return repository.getHistories();
  }
}
