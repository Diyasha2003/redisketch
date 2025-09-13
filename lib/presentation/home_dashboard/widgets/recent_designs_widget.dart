import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentDesignsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentDesigns;
  final bool isEnglish;
  final Function(String) onEdit;
  final Function(String) onDuplicate;
  final Function(String) onShare;

  const RecentDesignsWidget({
    Key? key,
    required this.recentDesigns,
    required this.isEnglish,
    required this.onEdit,
    required this.onDuplicate,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentDesigns.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEnglish ? 'Recent Designs' : 'මෑත නිර්මාණ',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/pattern-library'),
                child: Text(
                  isEnglish ? 'View All' : 'සියල්ල බලන්න',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: recentDesigns.length,
            itemBuilder: (context, index) {
              final design = recentDesigns[index];
              return _buildDesignCard(design, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesignCard(Map<String, dynamic> design, BuildContext context) {
    return Container(
      width: 45.w,
      margin: EdgeInsets.only(right: 3.w),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: AppTheme.secondary,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: CustomImageWidget(
                    imageUrl: design["thumbnail"] as String,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      design["title"] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      design["type"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(
                          icon: 'edit',
                          onTap: () => onEdit(design["id"] as String),
                        ),
                        _buildActionButton(
                          icon: 'content_copy',
                          onTap: () => onDuplicate(design["id"] as String),
                        ),
                        _buildActionButton(
                          icon: 'share',
                          onTap: () => onShare(design["id"] as String),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          size: 4.w,
          color: AppTheme.accent,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'design_services',
            size: 15.w,
            color: AppTheme.disabled,
          ),
          SizedBox(height: 2.h),
          Text(
            isEnglish ? 'No designs yet' : 'තවම නිර්මාණ නැත',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            isEnglish
                ? 'Create your first design to get started'
                : 'ආරම්භ කිරීමට ඔබේ පළමු නිර්මාණය සාදන්න',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.disabled,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
