import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PatternCardWidget extends StatelessWidget {
  final Map<String, dynamic> pattern;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onExport;
  final VoidCallback? onDelete;
  final bool isSelected;
  final bool showActions;

  const PatternCardWidget({
    Key? key,
    required this.pattern,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDuplicate,
    this.onExport,
    this.onDelete,
    this.isSelected = false,
    this.showActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border:
              isSelected ? Border.all(color: AppTheme.accent, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.textPrimary.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pattern thumbnail
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: AppTheme.secondary.withValues(alpha: 0.3),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: pattern['thumbnail'] != null
                          ? CustomImageWidget(
                              imageUrl: pattern['thumbnail'] as String,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.highlight.withValues(alpha: 0.3),
                                    AppTheme.accent.withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: 'design_services',
                                  color: AppTheme.primary,
                                  size: 8.w,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                // Pattern details
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pattern['title'] as String? ?? 'Untitled Design',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              pattern['garmentType'] as String? ?? 'Unknown',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(pattern['createdAt']),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.disabled,
                                    fontSize: 10.sp,
                                  ),
                            ),
                            if (pattern['syncStatus'] == 'offline')
                              CustomIconWidget(
                                iconName: 'cloud_off',
                                color: AppTheme.disabled,
                                size: 3.w,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Selection indicator
            if (isSelected)
              Positioned(
                top: 2.w,
                right: 2.w,
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.surface, width: 2),
                  ),
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: AppTheme.surface,
                    size: 3.w,
                  ),
                ),
              ),
            // Quick actions overlay
            if (showActions)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.textPrimary.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            context,
                            'edit',
                            'Edit',
                            onEdit,
                          ),
                          _buildActionButton(
                            context,
                            'content_copy',
                            'Duplicate',
                            onDuplicate,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            context,
                            'file_download',
                            'Export',
                            onExport,
                          ),
                          _buildActionButton(
                            context,
                            'delete',
                            'Delete',
                            onDelete,
                            isDestructive: true,
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

  Widget _buildActionButton(
    BuildContext context,
    String iconName,
    String label,
    VoidCallback? onPressed, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: isDestructive ? AppTheme.alert : AppTheme.surface,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: isDestructive ? AppTheme.surface : AppTheme.primary,
              size: 5.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.surface,
                  fontSize: 10.sp,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';

    try {
      DateTime dateTime;
      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return '';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return '';
    }
  }
}
