// add_on_repository_impl.dart
import 'package:capster_barbertech/features/home/takePicture/hairGuideDetail/addon/domain/add_on_repository.dart';

import 'add_on_remote_data_source.dart';

class AddOnRepositoryImpl implements AddOnRepository {
  final AddOnRemoteDataSource remote;
  AddOnRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> getAddOns() {
    return remote.getAddOns();
  }

  @override
  Future<Map<String, dynamic>> generateAddOn(
    String photoId,
    Map<String, dynamic> payload,
  ) {
    return remote.generateAddOn(
      photoId: photoId,
      addOnPayload: payload,
    );
  }
}
