import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PatternDisplayWidget extends StatefulWidget {
  final Map<String, dynamic> designData;
  final double zoom;
  final Function(double, double) onPanUpdate;

  const PatternDisplayWidget({
    Key? key,
    required this.designData,
    required this.zoom,
    required this.onPanUpdate,
  }) : super(key: key);

  @override
  State<PatternDisplayWidget> createState() => _PatternDisplayWidgetState();
}

class _PatternDisplayWidgetState extends State<PatternDisplayWidget> {
  Offset _panOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _panOffset += details.delta;
        });
        widget.onPanUpdate(_panOffset.dx, _panOffset.dy);
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.lightTheme.colorScheme.surface,
        child: Transform.scale(
          scale: widget.zoom,
          child: Transform.translate(
            offset: _panOffset,
            child: CustomPaint(
              painter: GarmentPatternPainter(
                designData: widget.designData,
              ),
              size: Size.infinite,
            ),
          ),
        ),
      ),
    );
  }
}

class GarmentPatternPainter extends CustomPainter {
  final Map<String, dynamic> designData;

  GarmentPatternPainter({required this.designData});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final garmentType = designData['garmentType'] as String? ?? 'shirt';

    switch (garmentType.toLowerCase()) {
      case 'shirt':
        _drawShirtPattern(canvas, center, paint, fillPaint);
        break;
      case 'dress':
        _drawDressPattern(canvas, center, paint, fillPaint);
        break;
      case 'saree jacket':
        _drawSareeJacketPattern(canvas, center, paint, fillPaint);
        break;
      case 't-shirt':
        _drawTShirtPattern(canvas, center, paint, fillPaint);
        break;
      default:
        _drawShirtPattern(canvas, center, paint, fillPaint);
    }

    _drawMeasurementLines(canvas, center, paint);
    _drawPatternDetails(canvas, center);
  }

  void _drawShirtPattern(
      Canvas canvas, Offset center, Paint strokePaint, Paint fillPaint) {
    final path = Path();

    // Shirt body outline
    path.moveTo(center.dx - 120, center.dy - 150); // Left shoulder
    path.lineTo(center.dx - 80, center.dy - 180); // Left neck
    path.lineTo(center.dx + 80, center.dy - 180); // Right neck
    path.lineTo(center.dx + 120, center.dy - 150); // Right shoulder
    path.lineTo(center.dx + 120, center.dy - 100); // Right armpit
    path.lineTo(center.dx + 90, center.dy + 150); // Right waist
    path.lineTo(center.dx - 90, center.dy + 150); // Left waist
    path.lineTo(center.dx - 120, center.dy - 100); // Left armpit
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    // Sleeves
    _drawSleeve(canvas, Offset(center.dx - 120, center.dy - 125), strokePaint,
        fillPaint, true);
    _drawSleeve(canvas, Offset(center.dx + 120, center.dy - 125), strokePaint,
        fillPaint, false);

    // Collar
    _drawCollar(canvas, center, strokePaint, fillPaint);
  }

  void _drawDressPattern(
      Canvas canvas, Offset center, Paint strokePaint, Paint fillPaint) {
    final path = Path();

    // Dress body outline (longer than shirt)
    path.moveTo(center.dx - 100, center.dy - 150); // Left shoulder
    path.lineTo(center.dx - 60, center.dy - 180); // Left neck
    path.lineTo(center.dx + 60, center.dy - 180); // Right neck
    path.lineTo(center.dx + 100, center.dy - 150); // Right shoulder
    path.lineTo(center.dx + 100, center.dy - 100); // Right armpit
    path.lineTo(center.dx + 130, center.dy + 200); // Right hem (flared)
    path.lineTo(center.dx - 130, center.dy + 200); // Left hem (flared)
    path.lineTo(center.dx - 100, center.dy - 100); // Left armpit
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    // Sleeves (shorter for dress)
    _drawSleeve(canvas, Offset(center.dx - 100, center.dy - 125), strokePaint,
        fillPaint, true,
        isShort: true);
    _drawSleeve(canvas, Offset(center.dx + 100, center.dy - 125), strokePaint,
        fillPaint, false,
        isShort: true);
  }

  void _drawSareeJacketPattern(
      Canvas canvas, Offset center, Paint strokePaint, Paint fillPaint) {
    final path = Path();

    // Saree jacket body (cropped length)
    path.moveTo(center.dx - 110, center.dy - 150); // Left shoulder
    path.lineTo(center.dx - 70, center.dy - 180); // Left neck
    path.lineTo(center.dx + 70, center.dy - 180); // Right neck
    path.lineTo(center.dx + 110, center.dy - 150); // Right shoulder
    path.lineTo(center.dx + 110, center.dy - 100); // Right armpit
    path.lineTo(center.dx + 100, center.dy + 50); // Right waist (cropped)
    path.lineTo(center.dx - 100, center.dy + 50); // Left waist (cropped)
    path.lineTo(center.dx - 110, center.dy - 100); // Left armpit
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    // Traditional sleeves (fitted)
    _drawSleeve(canvas, Offset(center.dx - 110, center.dy - 125), strokePaint,
        fillPaint, true,
        isFitted: true);
    _drawSleeve(canvas, Offset(center.dx + 110, center.dy - 125), strokePaint,
        fillPaint, false,
        isFitted: true);

    // Traditional collar
    _drawTraditionalCollar(canvas, center, strokePaint, fillPaint);
  }

  void _drawTShirtPattern(
      Canvas canvas, Offset center, Paint strokePaint, Paint fillPaint) {
    final path = Path();

    // T-shirt body (casual fit)
    path.moveTo(center.dx - 130, center.dy - 140); // Left shoulder
    path.lineTo(center.dx - 90, center.dy - 170); // Left neck
    path.lineTo(center.dx + 90, center.dy - 170); // Right neck
    path.lineTo(center.dx + 130, center.dy - 140); // Right shoulder
    path.lineTo(center.dx + 130, center.dy - 90); // Right armpit
    path.lineTo(center.dx + 100, center.dy + 140); // Right hem
    path.lineTo(center.dx - 100, center.dy + 140); // Left hem
    path.lineTo(center.dx - 130, center.dy - 90); // Left armpit
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);

    // Short sleeves
    _drawSleeve(canvas, Offset(center.dx - 130, center.dy - 115), strokePaint,
        fillPaint, true,
        isShort: true);
    _drawSleeve(canvas, Offset(center.dx + 130, center.dy - 115), strokePaint,
        fillPaint, false,
        isShort: true);

    // Round neckline
    _drawRoundNeckline(canvas, center, strokePaint);
  }

  void _drawSleeve(Canvas canvas, Offset position, Paint strokePaint,
      Paint fillPaint, bool isLeft,
      {bool isShort = false, bool isFitted = false}) {
    final path = Path();
    final width = isFitted ? 40.0 : 60.0;
    final length = isShort ? 60.0 : 120.0;
    final direction = isLeft ? -1 : 1;

    path.moveTo(position.dx, position.dy - 25);
    path.lineTo(position.dx + (width * direction), position.dy - 25);
    path.lineTo(position.dx + (width * direction), position.dy + length);
    path.lineTo(position.dx, position.dy + length);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawCollar(
      Canvas canvas, Offset center, Paint strokePaint, Paint fillPaint) {
    final path = Path();

    path.moveTo(center.dx - 80, center.dy - 180);
    path.quadraticBezierTo(
        center.dx, center.dy - 200, center.dx + 80, center.dy - 180);
    path.quadraticBezierTo(
        center.dx, center.dy - 160, center.dx - 80, center.dy - 180);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawTraditionalCollar(
      Canvas canvas, Offset center, Paint strokePaint, Paint fillPaint) {
    final path = Path();

    // Traditional high collar
    path.moveTo(center.dx - 70, center.dy - 180);
    path.lineTo(center.dx - 50, center.dy - 190);
    path.lineTo(center.dx + 50, center.dy - 190);
    path.lineTo(center.dx + 70, center.dy - 180);
    path.lineTo(center.dx + 50, center.dy - 170);
    path.lineTo(center.dx - 50, center.dy - 170);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawRoundNeckline(Canvas canvas, Offset center, Paint strokePaint) {
    canvas.drawCircle(
      Offset(center.dx, center.dy - 160),
      30,
      strokePaint,
    );
  }

  void _drawMeasurementLines(Canvas canvas, Offset center, Paint paint) {
    final measurementPaint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.tertiary
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dashedPaint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Chest measurement line
    _drawDashedLine(canvas, Offset(center.dx - 140, center.dy - 50),
        Offset(center.dx + 140, center.dy - 50), dashedPaint);

    // Length measurement line
    _drawDashedLine(canvas, Offset(center.dx + 140, center.dy - 180),
        Offset(center.dx + 140, center.dy + 150), dashedPaint);

    // Shoulder measurement line
    _drawDashedLine(canvas, Offset(center.dx - 120, center.dy - 150),
        Offset(center.dx + 120, center.dy - 150), dashedPaint);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startOffset =
          start + (end - start) * (i * (dashWidth + dashSpace) / distance);
      final endOffset = start +
          (end - start) *
              ((i * (dashWidth + dashSpace) + dashWidth) / distance);
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  void _drawPatternDetails(Canvas canvas, Offset center) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Draw size label
    textPainter.text = TextSpan(
      text: 'Size: ${designData['size'] ?? 'M'}',
      style: TextStyle(
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - 140, center.dy + 180));

    // Draw pattern piece label
    textPainter.text = TextSpan(
      text: 'Front Panel',
      style: TextStyle(
        color: AppTheme.lightTheme.primaryColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - 40, center.dy));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
