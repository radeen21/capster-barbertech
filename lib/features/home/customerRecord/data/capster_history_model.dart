import 'package:capster_barbertech/features/home/customerRecord/data/service_status.dart';
import 'package:capster_barbertech/features/home/customerRecord/domain/capster_history_entity.dart';

class CapsterHistoryModel {
  final String id;
  final String memberName;
  final String lastServiceType;
  final bool isMember;
  final int totalVisits;
  final DateTime? lastServedDate;
  final int transactionAmount;
  final ServiceStatus status;
   final String? haircutUrl;
  final String? fullHaircutUrl;

  CapsterHistoryModel({
    required this.id,
    required this.memberName,
    required this.lastServiceType,
    required this.isMember,
    required this.totalVisits,
    required this.lastServedDate,
    required this.transactionAmount,
    required this.status,
    this.haircutUrl,
    this.fullHaircutUrl,
  });

  factory CapsterHistoryModel.fromJson(
    Map<String, dynamic> json,
    String baseUrl, // 🔥 inject baseUrl dari dio
  ) {
    final rawUrl = json["haircut_url"];

    String? fullUrl;

    if (rawUrl != null && rawUrl.toString().isNotEmpty) {
      fullUrl = "$baseUrl/photos$rawUrl";
    }
    

    return CapsterHistoryModel(
      id: json["id"] ?? "",
      memberName: json["member"]?["full_name"] ?? "-",
      lastServiceType: json["last_service_type"] ?? "-",
      isMember: json["is_member"] ?? false,
      totalVisits: json["total_visits"] ?? 0,
      lastServedDate: json["last_served_date"] != null
          ? DateTime.tryParse(json["last_served_date"])
          : null,
      transactionAmount: json["transaction_amount"] ?? 0,
      status: parseStatus(json["status"]),
      haircutUrl: rawUrl,
      fullHaircutUrl: fullUrl, // 🔥 sudah full URL
    );
  }

  CapsterHistoryEntity toEntity() {
    return CapsterHistoryEntity(
      id: id,
      memberName: memberName,
      lastServiceType: lastServiceType,
      isMember: isMember,
      totalVisits: totalVisits,
      lastServedDate: lastServedDate,
      transactionAmount: transactionAmount,
      status: status,
      fullHaircutUrl: fullHaircutUrl,// 🔥 kirim ke entity
    );
  }
}
