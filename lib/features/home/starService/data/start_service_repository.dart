abstract class StartServiceRepository {
  Future<Map<String, dynamic>> startService({
    required String phoneNumber,
    required String serviceId,
    required String haircutName,
    required List<Map<String, dynamic>> addOns,
  });
}
