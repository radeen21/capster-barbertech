import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';

abstract class GrommingServiceRepository {
  Future<List<GrommingServiceEntity>> getServices();
}
