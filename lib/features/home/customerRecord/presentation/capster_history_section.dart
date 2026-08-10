import 'package:capster_barbertech/features/home/customerRecord/presentation/capster_history_controller.dart';
import 'package:flutter/material.dart';

class CapsterHistorySection extends StatelessWidget {
  final CapsterHistoryController controller;

  const CapsterHistorySection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        if (controller.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }

        if (controller.histories.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const Divider(color: Colors.white12),
            ...controller.histories.map(_item).toList(),
          ],
        );
      },
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Latest Activities",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "See More →",
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _item(history) {
    final isOngoing = history.isOngoing;

    final badgeColor = isOngoing
        ? const Color(0xFF5C4B2C)
        : const Color(0xFF1F3A1F);

    final textColor =
        isOngoing ? Colors.amber : Colors.lightGreenAccent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TEXT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                history.memberName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                history.serviceName,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          // BADGE
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              isOngoing ? "On Going" : "Completed",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
