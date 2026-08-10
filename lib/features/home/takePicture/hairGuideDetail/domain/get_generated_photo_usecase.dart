import 'package:capster_barbertech/features/home/takePicture/hairGuideDetail/data/model/generated_photo_model.dart';

import 'recommendation_repository.dart';

class GetGeneratedPhotosUseCase {
  final RecommendationRepository repository;

  GetGeneratedPhotosUseCase(this.repository);

  Future<List<GeneratedPhoto>> execute({
    required String userId,
    required String requestId,
  }) {
    return repository.getGeneratedPhotos(
      userId: userId,
      requestId: requestId,
    );
  }
}
