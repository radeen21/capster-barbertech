import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_repository.dart';

class GetGroomingServicesUseCase {
  final GrommingServiceRepository repository;

  GetGroomingServicesUseCase(this.repository);

  Future<List<GrommingServiceEntity>> call() {
    return repository.getServices();
  }
}
