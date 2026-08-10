import 'package:capster_barbertech/features/home/customerRecord/domain/capster_history_entity.dart';
import 'package:flutter/material.dart';
import 'capster_history_item.dart';

class CustomerRecordPage extends StatelessWidget {
  final List<CapsterHistoryEntity> histories;
  final Future<void> Function()? onRefresh;

  const CustomerRecordPage({
    super.key,
    required this.histories,
    this.onRefresh,
  });

  Map<DateTime, List<CapsterHistoryEntity>> _groupByDate() {
    final map = <DateTime, List<CapsterHistoryEntity>>{};

    for (final item in histories) {
      final key = item.dateOnly;
      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate();
    final sortedDates = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Customer Record"),
      ),
      body: RefreshIndicator(
        color: Colors.orange,
        onRefresh: onRefresh ?? () async {},
        child: histories.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 150),
                  Center(
                    child: Text(
                      "Belum ada kegiatan",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: sortedDates.expand((date) {
                  final items = grouped[date]!;

                  return [
                    /// 📅 DATE HEADER
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, bottom: 12),
                      child: Text(
                        items.first.formattedHeaderDate,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    /// 🧾 CARDS
                    ...items.map(
                      (item) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: 16),
                        child: CapsterHistoryItem(data: item),
                      ),
                    ),
                  ];
                }).toList(),
              ),
      ),
    );
  }
}
