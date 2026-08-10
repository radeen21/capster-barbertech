import 'package:capster_barbertech/features/home/history/presentation/history_controller.dart';
import 'package:flutter/material.dart';
import 'history_item.dart';

class HistoryPage extends StatefulWidget {
  final HistoryController controller;

  const HistoryPage({
    super.key,
    required this.controller,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetchHistories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "History",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// LIST
            Expanded(
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (_, __) {
                  if (widget.controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  final histories = widget.controller.histories;

                  if (histories.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada history",
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: histories.length,
                    itemBuilder: (_, index) {
                      final item = histories[index];

                      return HistoryItem(
                        dateText: item.date.toString(),
                        points: "${item.memberPoint} Points",
                        capsterLeft: item.capsterName,
                        capsterRight: "-",
                        serviceLeft: item.haircutName,
                        serviceRight: item.serviceName,
                        lastPhoto: item.lastPhoto ?? "assets/logo_barberpedia.png",
                        totalCost: "Rp ${item.transactionAmount}",
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
