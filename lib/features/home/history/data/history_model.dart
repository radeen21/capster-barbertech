

import 'package:capster_barbertech/features/home/history/domain/history_entity.dart';

class HistoryModel {
  final String id;
  final DateTime date;
  final String capsterName;
  final String haircutName;
  final String serviceName;
  final int transactionAmount;
  final int memberPoint;
  final String? lastPhoto;

  HistoryModel({
    required this.id,
    required this.date,
    required this.capsterName,
    required this.haircutName,
    required this.serviceName,
    required this.transactionAmount,
    required this.memberPoint,
    this.lastPhoto,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json["id"],
      date: DateTime.parse(json["date"]),
      capsterName: json["capster"]?["name"] ?? "-",
      haircutName: json["haircut_name"] ?? "-",
      serviceName: json["service"]?["name"] ?? "-",
      transactionAmount: json["transaction_amount"] ?? 0,
      memberPoint: json["member_point"] ?? 0,
      lastPhoto: json["last_cut_photo"],
    );
  }

  HistoryEntity toEntity() {
    return HistoryEntity(
      id: id,
      date: date,
      capsterName: capsterName,
      haircutName: haircutName,
      serviceName: serviceName,
      transactionAmount: transactionAmount,
      memberPoint: memberPoint,
      lastPhoto: lastPhoto,
    );
  }
}
