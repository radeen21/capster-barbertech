import '../domain/finish_service_repository.dart';
import 'finish_service_remote_data_source.dart';

class FinishServiceRepositoryImpl implements FinishServiceRepository {
  final FinishServiceRemoteDataSource remoteDataSource;

  FinishServiceRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> finishService({
    required String historyId,
    required String photoUrl,
  }) {
    return remoteDataSource.finishService(
      historyId: historyId,
      photoUrl: photoUrl,
    );
  }
}
