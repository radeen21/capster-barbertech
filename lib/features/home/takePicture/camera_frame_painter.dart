import 'package:flutter/material.dart';

class CameraFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double cornerLength = 30; // panjang garis pojok
    const double sideLength = 20; // panjang garis tengah sisi
    const double strokeWidth = 3;

    final Paint yellowPaint = Paint()
      ..color = const Color(0xFFF6AD03)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // === 4 POJOK FRAME ===
    // Atas kiri
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), whitePaint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), yellowPaint);

    // Atas kanan
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      whitePaint,
    );
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, cornerLength),
      yellowPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      whitePaint,
    );

    // Bawah kiri
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      yellowPaint,
    );
    canvas.drawLine(
      Offset(0, size.height - cornerLength),
      Offset(0, size.height),
      yellowPaint,
    );

    // Bawah kanan
    canvas.drawLine(
      Offset(size.width - cornerLength, size.height),
      Offset(size.width, size.height),
      yellowPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      yellowPaint,
    );

    // === 4 SISI TENGAH FRAME ===
    // Tengah atas
    canvas.drawLine(
      Offset(size.width / 2 - sideLength, 0),
      Offset(size.width / 2 + sideLength, 0),
      whitePaint,
    );

    // Tengah bawah
    canvas.drawLine(
      Offset(size.width / 2 - sideLength, size.height),
      Offset(size.width / 2 + sideLength, size.height),
      yellowPaint,
    );

    // Tengah kiri
    canvas.drawLine(
      Offset(0, size.height / 2 - sideLength),
      Offset(0, size.height / 2 + sideLength),
      whitePaint,
    );

    // Tengah kanan
    canvas.drawLine(
      Offset(size.width, size.height / 2 - sideLength),
      Offset(size.width, size.height / 2 + sideLength),
      yellowPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
