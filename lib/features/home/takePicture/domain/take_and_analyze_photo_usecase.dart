import 'dart:io';
import 'package:capster_barbertech/features/home/takePicture/domain/photo_repository.dart';

class TakeAndAnalyzePhotoUseCase {
  final PhotoRepository repository;

  TakeAndAnalyzePhotoUseCase(this.repository);

  Future<Map<String, dynamic>> execute(
    File file, {
    required String serviceId,
    String? serviceType,
    Map<String, dynamic>? addOnPayload,
  }) async {
    try {
      final uploadResponse = await repository.uploadPhoto(file);

      if (uploadResponse["code"] != 201) {
        throw (uploadResponse["message"] ?? "Upload gagal");
      }

      final photoId = uploadResponse["data"]?["id"];

      if (photoId == null) {
        throw "ID foto tidak ditemukan";
      }
      if (serviceType != null && serviceType != "haircut") {
        if (addOnPayload == null) {
          throw "Data add-on tidak ditemukan";
        }

        final generateAddOnResponse =
            await repository.generateImageAddOn(
          photoId: photoId,
          addOn: addOnPayload,
        );

        return {
          "upload": uploadResponse,
          "analyze": null,
          "generate": generateAddOnResponse,
        };
      }

      final analyzeResponse = await repository.analyzePhoto(
        photoId: photoId,
        serviceId: serviceId,
      );

      final recommendations =
          (analyzeResponse["data"]?["recommendation"]
                      as List<dynamic>? ??
                  [])
              .map<Map<String, dynamic>>(
                (e) => {
                  "haircut_name":
                      e["haircut_name"]?.toString() ?? "",
                  "rating":
                      e["rating"]?.toString() ?? "",
                },
              )
              .toList();

      final generateResponse =
          await repository.generateImageByName(
        photoId: photoId,
        recommendation: recommendations,
      );

      return {
        "upload": uploadResponse,
        "analyze": analyzeResponse,
        "generate": generateResponse,
      };
    } catch (e) {
      if (e is String) {
        throw e;
      }

      // Fallback unexpected error
      throw "Terjadi kesalahan saat memproses foto";
    }
  }
}
