import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';

class GrommingServiceModel extends GrommingServiceEntity {
  GrommingServiceModel({
     required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.durationMinutes,
    required super.isRecommended,
    required super.hasAddons,
    required super.isAllowPhoto
  });

  factory GrommingServiceModel.fromJson(Map<String, dynamic> json) {
    return GrommingServiceModel(
          id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: json['price'],
      durationMinutes: json['duration_minutes'],
      isRecommended: json['is_recommended'] ?? false,
      hasAddons: json['has_addons'] ?? false,
      isAllowPhoto: json["is_allow_photo"] ?? false,
    );
  }
}
