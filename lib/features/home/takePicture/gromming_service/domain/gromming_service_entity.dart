class GrommingServiceEntity {
  final String id;
  final String name;
  final String description;
  final int price;
  final int durationMinutes;
  final bool isRecommended;
  final bool hasAddons;
  final bool isAllowPhoto;

  GrommingServiceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.isRecommended,
    required this.hasAddons,
    required this.isAllowPhoto,
  });

  factory GrommingServiceEntity.fromJson(Map<String, dynamic> json) {
    return GrommingServiceEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      durationMinutes: json['duration_minutes'] as int,
      isRecommended: json['is_recommended'] == true,
      hasAddons: json['has_addons'] == true,

      isAllowPhoto: json['is_allow_photo'] == true,
    );
  }
}
