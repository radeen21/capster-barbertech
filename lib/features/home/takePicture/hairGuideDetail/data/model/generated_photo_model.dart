class GeneratedPhoto {
  final String id;
  final String url;
  final DateTime createdAt;

  GeneratedPhoto({
    required this.id,
    required this.url,
    required this.createdAt,
  });

  factory GeneratedPhoto.fromJson(Map<String, dynamic> json) {
    return GeneratedPhoto(
      id: json["id"],
      url: json["url"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}
