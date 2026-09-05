import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final String dateText;
  final String points;
  final String capsterLeft;
  final String capsterRight;
  final String serviceLeft;
  final String serviceRight;
  final String lastPhoto;
  final String totalCost;

  const HistoryItem({
    super.key,
    required this.dateText,
    required this.points,
    required this.capsterLeft,
    required this.capsterRight,
    required this.serviceLeft,
    required this.serviceRight,
    required this.lastPhoto,
    required this.totalCost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          /// DATE + POINT BADGE
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 14, color: Colors.white54),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        dateText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _pointBadge(),
            ],
          ),

          const SizedBox(height: 12),
          _divider(),

          const SizedBox(height: 12),

          ///  CAPSTER
          _infoRow(
            label: "Nama Capster",
            value: capsterLeft,
          ),

          const SizedBox(height: 8),

          /// SERVICE
          _infoRow(
            label: "Jenis Services",
            value: serviceLeft,
          ),

          const SizedBox(height: 12),
          _divider(),

          const SizedBox(height: 12),

          /// LAST PHOTO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Potongan Terakhir",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImage(),
              ),
            ],
          ),

          const SizedBox(height: 12),
          _divider(),

          const SizedBox(height: 12),

          /// TOTAL COST
          Row(
            children: [
              const Text(
                "Total Biaya",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Text(
                totalCost,
                style: const TextStyle(
                  color: Color(0xFFF6AD03),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.white12,
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _pointBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "+ $points",
        style: const TextStyle(
          color: Colors.greenAccent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (lastPhoto.startsWith("http")) {
      return Image.network(
        lastPhoto,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }

    return Image.asset(
      lastPhoto,
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: 64,
      height: 64,
      color: Colors.black26,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.white38,
      ),
    );
  }
}
