import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GarmentPreviewWidget extends StatefulWidget {
  final String selectedGarment;
  final Map<String, dynamic> customizations;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;

  const GarmentPreviewWidget({
    Key? key,
    required this.selectedGarment,
    required this.customizations,
    this.onZoomIn,
    this.onZoomOut,
  }) : super(key: key);

  @override
  State<GarmentPreviewWidget> createState() => _GarmentPreviewWidgetState();
}

class _GarmentPreviewWidgetState extends State<GarmentPreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  double _currentScale = 1.0;
  Offset _currentOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerUpdateAnimation() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  void didUpdateWidget(GarmentPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.customizations != widget.customizations) {
      _triggerUpdateAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background grid pattern
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                image: DecorationImage(
                  image: NetworkImage(
                    'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHZpZXdCb3g9IjAgMCAyMCAyMCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGRlZnM+CjxwYXR0ZXJuIGlkPSJncmlkIiB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHBhdHRlcm5Vbml0cz0idXNlclNwYWNlT25Vc2UiPgo8cGF0aCBkPSJNIDIwIDAgTCAwIDAgMCAyMCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjRTVENUM4IiBzdHJva2Utd2lkdGg9IjAuNSIvPgo8L3BhdHRlcm4+CjwvZGVmcz4KPHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0idXJsKCNncmlkKSIgLz4KPHN2Zz4K',
                  ),
                  repeat: ImageRepeat.repeat,
                  opacity: 0.3,
                ),
              ),
            ),

            // Garment preview
            Center(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _currentScale * _scaleAnimation.value,
                    child: Transform.translate(
                      offset: _currentOffset,
                      child: GestureDetector(
                        onScaleStart: (details) {
                          setState(() {});
                        },
                        onScaleUpdate: (details) {
                          setState(() {
                            _currentScale =
                                (_currentScale * details.scale).clamp(0.8, 2.0);
                            _currentOffset += details.focalPointDelta;
                          });
                        },
                        child: CustomPaint(
                          size: Size(25.w, 30.h),
                          painter: GarmentPainter(
                            garmentType: widget.selectedGarment,
                            customizations: widget.customizations,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Zoom controls
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  _buildZoomButton(
                    icon: 'zoom_in',
                    onTap: () {
                      setState(() {
                        _currentScale = (_currentScale * 1.2).clamp(0.8, 2.0);
                      });
                      widget.onZoomIn?.call();
                    },
                  ),
                  SizedBox(height: 8),
                  _buildZoomButton(
                    icon: 'zoom_out',
                    onTap: () {
                      setState(() {
                        _currentScale = (_currentScale / 1.2).clamp(0.8, 2.0);
                      });
                      widget.onZoomOut?.call();
                    },
                  ),
                  SizedBox(height: 8),
                  _buildZoomButton(
                    icon: 'center_focus_strong',
                    onTap: () {
                      setState(() {
                        _currentScale = 1.0;
                        _currentOffset = Offset.zero;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Garment info overlay
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.selectedGarment.toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class GarmentPainter extends CustomPainter {
  final String garmentType;
  final Map<String, dynamic> customizations;

  GarmentPainter({
    required this.garmentType,
    required this.customizations,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = AppTheme.highlight.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    switch (garmentType.toLowerCase()) {
      case 'shirt':
        _drawShirt(canvas, size, paint, fillPaint);
        break;
      case 'dress':
        _drawDress(canvas, size, paint, fillPaint);
        break;
      case 'saree jacket':
        _drawSareeJacket(canvas, size, paint, fillPaint);
        break;
      case 't-shirt':
        _drawTShirt(canvas, size, paint, fillPaint);
        break;
      default:
        _drawShirt(canvas, size, paint, fillPaint);
    }
  }

  void _drawShirt(
      Canvas canvas, Size size, Paint strokePaint, Paint fillPaint) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Shirt body
    path.moveTo(centerX - 60, centerY - 80);
    path.lineTo(centerX + 60, centerY - 80);
    path.lineTo(centerX + 60, centerY + 80);
    path.lineTo(centerX - 60, centerY + 80);
    path.close();

    // Sleeves based on customization
    final sleeveType = customizations['sleeve'] ?? 'long';
    if (sleeveType == 'long') {
      // Long sleeves
      path.moveTo(centerX - 60, centerY - 60);
      path.lineTo(centerX - 100, centerY - 40);
      path.lineTo(centerX - 100, centerY + 20);
      path.lineTo(centerX - 60, centerY + 40);

      path.moveTo(centerX + 60, centerY - 60);
      path.lineTo(centerX + 100, centerY - 40);
      path.lineTo(centerX + 100, centerY + 20);
      path.lineTo(centerX + 60, centerY + 40);
    } else if (sleeveType == 'short') {
      // Short sleeves
      path.moveTo(centerX - 60, centerY - 60);
      path.lineTo(centerX - 80, centerY - 50);
      path.lineTo(centerX - 80, centerY - 20);
      path.lineTo(centerX - 60, centerY - 10);

      path.moveTo(centerX + 60, centerY - 60);
      path.lineTo(centerX + 80, centerY - 50);
      path.lineTo(centerX + 80, centerY - 20);
      path.lineTo(centerX + 60, centerY - 10);
    }

    // Neckline based on customization
    final necklineType = customizations['neckline'] ?? 'round';
    if (necklineType == 'v-neck') {
      path.moveTo(centerX - 20, centerY - 80);
      path.lineTo(centerX, centerY - 60);
      path.lineTo(centerX + 20, centerY - 80);
    } else if (necklineType == 'round') {
      path.addOval(Rect.fromCenter(
        center: Offset(centerX, centerY - 70),
        width: 40,
        height: 20,
      ));
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawDress(
      Canvas canvas, Size size, Paint strokePaint, Paint fillPaint) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Dress body (A-line shape)
    path.moveTo(centerX - 50, centerY - 80);
    path.lineTo(centerX + 50, centerY - 80);
    path.lineTo(centerX + 80, centerY + 80);
    path.lineTo(centerX - 80, centerY + 80);
    path.close();

    // Sleeves
    final sleeveType = customizations['sleeve'] ?? 'short';
    if (sleeveType == 'sleeveless') {
      // No sleeves - just armholes
    } else if (sleeveType == 'short') {
      path.moveTo(centerX - 50, centerY - 60);
      path.lineTo(centerX - 70, centerY - 50);
      path.lineTo(centerX - 70, centerY - 20);
      path.lineTo(centerX - 50, centerY - 10);

      path.moveTo(centerX + 50, centerY - 60);
      path.lineTo(centerX + 70, centerY - 50);
      path.lineTo(centerX + 70, centerY - 20);
      path.lineTo(centerX + 50, centerY - 10);
    }

    // Neckline
    final necklineType = customizations['neckline'] ?? 'round';
    if (necklineType == 'square') {
      path.addRect(Rect.fromCenter(
        center: Offset(centerX, centerY - 70),
        width: 30,
        height: 15,
      ));
    } else {
      path.addOval(Rect.fromCenter(
        center: Offset(centerX, centerY - 70),
        width: 30,
        height: 15,
      ));
    }

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawSareeJacket(
      Canvas canvas, Size size, Paint strokePaint, Paint fillPaint) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Jacket body (cropped)
    path.moveTo(centerX - 60, centerY - 80);
    path.lineTo(centerX + 60, centerY - 80);
    path.lineTo(centerX + 60, centerY + 20);
    path.lineTo(centerX - 60, centerY + 20);
    path.close();

    // Traditional sleeves
    path.moveTo(centerX - 60, centerY - 60);
    path.lineTo(centerX - 90, centerY - 50);
    path.lineTo(centerX - 90, centerY + 10);
    path.lineTo(centerX - 60, centerY + 20);

    path.moveTo(centerX + 60, centerY - 60);
    path.lineTo(centerX + 90, centerY - 50);
    path.lineTo(centerX + 90, centerY + 10);
    path.lineTo(centerX + 60, centerY + 20);

    // Traditional neckline
    path.moveTo(centerX - 25, centerY - 80);
    path.quadraticBezierTo(centerX, centerY - 60, centerX + 25, centerY - 80);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawTShirt(
      Canvas canvas, Size size, Paint strokePaint, Paint fillPaint) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // T-shirt body
    path.moveTo(centerX - 55, centerY - 75);
    path.lineTo(centerX + 55, centerY - 75);
    path.lineTo(centerX + 55, centerY + 75);
    path.lineTo(centerX - 55, centerY + 75);
    path.close();

    // Short sleeves
    path.moveTo(centerX - 55, centerY - 60);
    path.lineTo(centerX - 75, centerY - 50);
    path.lineTo(centerX - 75, centerY - 25);
    path.lineTo(centerX - 55, centerY - 15);

    path.moveTo(centerX + 55, centerY - 60);
    path.lineTo(centerX + 75, centerY - 50);
    path.lineTo(centerX + 75, centerY - 25);
    path.lineTo(centerX + 55, centerY - 15);

    // Round neckline
    path.addOval(Rect.fromCenter(
      center: Offset(centerX, centerY - 65),
      width: 35,
      height: 20,
    ));

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
