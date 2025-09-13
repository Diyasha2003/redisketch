import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PatternZoomControls extends StatelessWidget {
  final double currentZoom;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetZoom;

  const PatternZoomControls({
    Key? key,
    required this.currentZoom,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetZoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4.w,
      top: 20.h,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildZoomButton(
              icon: 'add',
              onTap: onZoomIn,
              enabled: currentZoom < 3.0,
            ),
            Container(
              width: 12.w,
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            _buildZoomButton(
              icon: 'remove',
              onTap: onZoomOut,
              enabled: currentZoom > 0.5,
            ),
            Container(
              width: 12.w,
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            _buildZoomButton(
              icon: 'center_focus_strong',
              onTap: onResetZoom,
              enabled: currentZoom != 1.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomButton({
    required String icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: enabled
              ? AppTheme.lightTheme.colorScheme.surface
              : AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: enabled
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline,
            size: 24,
          ),
        ),
      ),
    );
  }
}
