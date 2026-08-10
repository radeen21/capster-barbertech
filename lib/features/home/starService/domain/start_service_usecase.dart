import '../data/start_service_repository.dart';

class StartServiceUseCase {
  final StartServiceRepository repository;

  StartServiceUseCase(this.repository);

  Future<Map<String, dynamic>> execute({
    required String phoneNumber,
    required String serviceId,
    required String haircutName,
    required List<Map<String, dynamic>> addOns,
  }) {
    return repository.startService(
      phoneNumber: phoneNumber,
      serviceId: serviceId,
      haircutName: haircutName,
      addOns: addOns,
    );
  }
}
