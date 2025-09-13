import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class CreateDesignHeroWidget extends StatelessWidget {
  final VoidCallback onCreateDesign;
  final bool isEnglish;

  const CreateDesignHeroWidget({
    Key? key,
    required this.onCreateDesign,
    required this.isEnglish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          height: 20.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accent.withValues(alpha: 0.1),
                AppTheme.highlight.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -5.w,
                top: -2.h,
                child: CustomIconWidget(
                  iconName: 'design_services',
                  size: 25.w,
                  color: AppTheme.accent.withValues(alpha: 0.1),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeaderSection(),
                    SizedBox(height: 2.h),
                    ElevatedButton.icon(
                      onPressed: onCreateDesign,
                      icon: CustomIconWidget(
                        iconName: 'add_circle',
                        size: 5.w,
                        color: AppTheme.surface,
                      ),
                      label: Text(
                        isEnglish ? 'Start Creating' : 'නිර්මාණය ආරම්භ කරන්න',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.surface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          // Add RediSketch logo to header
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/RediSketch-1757074391773.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Design',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Start your sewing journey with AI assistance',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}