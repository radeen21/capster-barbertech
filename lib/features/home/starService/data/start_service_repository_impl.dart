import 'start_service_remote_data_source.dart';
import 'start_service_repository.dart';

class StartServiceRepositoryImpl implements StartServiceRepository {
  final StartServiceRemoteDataSource remote;

  StartServiceRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> startService({
    required String phoneNumber,
    required String serviceId,
    required String haircutName,
    required List<Map<String, dynamic>> addOns,
  }) {
    return remote.startService(
      phoneNumber: phoneNumber,
      serviceId: serviceId,
      haircutName: haircutName,
      addOns: addOns,
    );
  }
}
