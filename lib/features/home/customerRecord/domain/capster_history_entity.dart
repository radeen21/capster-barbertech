import 'package:intl/intl.dart';
import '../data/service_status.dart';

class CapsterHistoryEntity {
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

  const CapsterHistoryEntity({
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

  /// ======================
  /// STATUS
  /// ======================
  bool get isDone => status == ServiceStatus.done;
  bool get isProcessing => status == ServiceStatus.processing;

  /// ======================
  /// DATE GROUPING
  /// ======================
  DateTime get dateOnly {
    if (lastServedDate == null) {
      return DateTime(1970); // fallback aman
    }
    final d = lastServedDate!;
    return DateTime(d.year, d.month, d.day);
  }

  String get formattedHeaderDate {
    if (lastServedDate == null) return "-";
    return DateFormat(
      "EEEE, d MMMM yyyy",
      "id_ID",
    ).format(lastServedDate!);
  }

  /// 🕒 ITEM: 14.30
  String get formattedItemDate =>
      DateFormat('HH.mm', 'id_ID').format(lastServedDate!);
}
