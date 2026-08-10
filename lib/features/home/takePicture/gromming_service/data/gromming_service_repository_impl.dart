import 'package:capster_barbertech/features/home/takePicture/gromming_service/data/gromming_service_model.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/data/gromming_service_remote_data_source.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_repository.dart';

class GrommingServiceRepositoryImpl implements GrommingServiceRepository {
  final GrommingServiceRemoteDataSource remote;
  
  GrommingServiceRepositoryImpl(this.remote);

  
  @override
  Future<List<GrommingServiceEntity>> getServices() async {
    final List<Map<String, dynamic>> list = await remote.getServices();

    return list
        .map((json) => GrommingServiceModel.fromJson(json))
        .toList();
  }
}
