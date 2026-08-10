import 'package:capster_barbertech/features/home/takePicture/hairGuideDetail/domain/recommendation_repository.dart';
import 'recommendation_remote_data_source.dart';
import 'model/generated_photo_model.dart';

class RecommendationRepositoryImpl
    implements RecommendationRepository {
  final RecommendationRemoteDataSource remote;

  RecommendationRepositoryImpl(this.remote);

  @override
  Future<List<GeneratedPhoto>> getGeneratedPhotos({
    required String userId,
    required String requestId,
  }) async {
    final response = await remote.getGeneratedPhotos(
      userId: userId,
      requestId: requestId,
    );

    final List list = response["data"];
    return list
        .map((e) => GeneratedPhoto.fromJson(e))
        .toList();
  }
}
