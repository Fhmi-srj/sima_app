import 'package:flutter/material.dart';

/// Custom painter for drawing curved bracket corners
/// Matches the design reference with smooth rounded brackets
class CurvedBracketPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  CurvedBracketPainter({required this.color, this.strokeWidth = 4.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cornerLength = 100.0; // Length of each bracket arm
    final cornerRadius = 20.0; // Radius for the rounded corners

    // Top-Left Bracket [
    final topLeftPath = Path();
    topLeftPath.moveTo(cornerLength, 0);
    topLeftPath.lineTo(cornerRadius, 0);
    topLeftPath.quadraticBezierTo(0, 0, 0, cornerRadius);
    topLeftPath.lineTo(0, cornerLength);
    canvas.drawPath(topLeftPath, paint);

    // Top-Right Bracket ]
    final topRightPath = Path();
    topRightPath.moveTo(size.width - cornerLength, 0);
    topRightPath.lineTo(size.width - cornerRadius, 0);
    topRightPath.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    topRightPath.lineTo(size.width, cornerLength);
    canvas.drawPath(topRightPath, paint);

    // Bottom-Left Bracket [
    final bottomLeftPath = Path();
    bottomLeftPath.moveTo(0, size.height - cornerLength);
    bottomLeftPath.lineTo(0, size.height - cornerRadius);
    bottomLeftPath.quadraticBezierTo(0, size.height, cornerRadius, size.height);
    bottomLeftPath.lineTo(cornerLength, size.height);
    canvas.drawPath(bottomLeftPath, paint);

    // Bottom-Right Bracket ]
    final bottomRightPath = Path();
    bottomRightPath.moveTo(size.width, size.height - cornerLength);
    bottomRightPath.lineTo(size.width, size.height - cornerRadius);
    bottomRightPath.quadraticBezierTo(
      size.width,
      size.height,
      size.width - cornerRadius,
      size.height,
    );
    bottomRightPath.lineTo(size.width - cornerLength, size.height);
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
