class HistoryEntity {
  final String id;
  final DateTime date;
  final String capsterName;
  final String haircutName;
  final String serviceName;
  final int transactionAmount;
  final int memberPoint;
  final String? lastPhoto;

  HistoryEntity({
    required this.id,
    required this.date,
    required this.capsterName,
    required this.haircutName,
    required this.serviceName,
    required this.transactionAmount,
    required this.memberPoint,
    this.lastPhoto,
  });
}
