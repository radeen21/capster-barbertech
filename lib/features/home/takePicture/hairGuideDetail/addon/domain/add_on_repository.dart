// add_on_repository.dart
abstract class AddOnRepository {
  Future<Map<String, dynamic>> getAddOns();
  Future<Map<String, dynamic>> generateAddOn(
    String photoId,
    Map<String, dynamic> payload,
  );
}
