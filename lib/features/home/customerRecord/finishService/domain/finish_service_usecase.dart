import 'finish_service_repository.dart';

class FinishServiceUseCase {
  final FinishServiceRepository repository;

  FinishServiceUseCase(this.repository);

  Future<void> execute({
    required String historyId,
    required String photoUrl,
  }) {
    return repository.finishService(
      historyId: historyId,
      photoUrl: photoUrl,
    );
  }
}
