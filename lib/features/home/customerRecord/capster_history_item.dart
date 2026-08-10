import 'package:capster_barbertech/features/home/customerRecord/capster_finish_service_page.dart';
import 'package:capster_barbertech/features/home/customerRecord/data/service_status.dart';
import 'package:capster_barbertech/features/home/customerRecord/domain/capster_history_entity.dart';
import 'package:flutter/material.dart';

class CapsterHistoryItem extends StatelessWidget {
  final CapsterHistoryEntity data;

  const CapsterHistoryItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ================= HEADER =================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// FOTO
              _buildImage(),

              const SizedBox(width: 16),

              /// RIGHT SIDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TOTAL + BADGE
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Total kunjungan : ${data.totalVisits}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _MemberBadge(isMember: data.isMember),
                        const SizedBox(width: 6),
                        _StatusBadge(status: data.status),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// NAMA CUSTOMER
                    Text(
                      data.memberName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(color: Colors.white12),

          /// ================= INFO =================
          const SizedBox(height: 12),

          _infoRow("Terakhir dilayani", data.formattedHeaderDate),
          const SizedBox(height: 8),
          _infoRow("Jenis terakhir service", data.lastServiceType),

          const SizedBox(height: 16),
          const Divider(color: Colors.white12),

          /// ================= BUTTON =================
          if (data.isProcessing)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6AD03),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CapsterFinishServicePage(
                          historyId: data.id,
                          customerName: data.memberName,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Lanjut",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ================= IMAGE BUILDER =================
  Widget _buildImage() {
    if (data.fullHaircutUrl == null ||
        data.fullHaircutUrl!.isEmpty) {
      return _placeholderImage();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        data.fullHaircutUrl!,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _placeholderImage();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            width: 72,
            height: 72,
            color: Colors.black,
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.orange,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white54,
      ),
    );
  }
}


class _MemberBadge extends StatelessWidget {
  final bool isMember;

  const _MemberBadge({required this.isMember});

  @override
  Widget build(BuildContext context) {
    final bgColor = isMember
        ? const Color(0xFF3A2E0C)
        : const Color(0xFF2A2A2A);

    final textColor = isMember ? const Color(0xFFF6AD03) : Colors.white70;

    final label = isMember ? "Member" : "Non Member";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ServiceStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bgColor;
    late Color textColor;
    late String label;

    switch (status) {
      case ServiceStatus.done:
        bgColor = const Color(0xFF123A1E);
        textColor = const Color(0xFF4ADE80);
        label = "Done";
        break;

      case ServiceStatus.processing:
      default:
        bgColor = const Color(0xFF3A2A12);
        textColor = const Color(0xFFF6AD03);
        label = "On Going";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Widget _infoRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: Colors.white54)),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}


