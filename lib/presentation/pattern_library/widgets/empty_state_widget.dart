import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onCreateDesign;

  const EmptyStateWidget({
    Key? key,
    this.onCreateDesign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background pattern
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: AppTheme.highlight.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Main icon
                  CustomIconWidget(
                    iconName: 'design_services',
                    color: AppTheme.primary,
                    size: 15.w,
                  ),
                  // Decorative elements
                  Positioned(
                    top: 8.w,
                    right: 8.w,
                    child: Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.w,
                    left: 6.w,
                    child: Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: AppTheme.highlight,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12.w,
                    left: 10.w,
                    child: Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: AppTheme.alert.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.h),
            // Title
            Text(
              'No Designs Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Description
            Text(
              'Start creating your first sewing pattern design. Your saved patterns will appear here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCreateDesign,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.surface,
                  size: 5.w,
                ),
                label: Text(
                  'Create Your First Design',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.surface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            // Secondary action
            TextButton.icon(
              onPressed: () {
                // Navigate to tutorials or help
              },
              icon: CustomIconWidget(
                iconName: 'help_outline',
                color: AppTheme.accent,
                size: 4.w,
              ),
              label: Text(
                'Learn How to Get Started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
