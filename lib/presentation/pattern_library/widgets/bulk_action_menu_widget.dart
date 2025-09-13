import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionMenuWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback? onExportSelected;
  final VoidCallback? onDuplicateSelected;
  final VoidCallback? onDeleteSelected;
  final VoidCallback? onDeselectAll;

  const BulkActionMenuWidget({
    Key? key,
    required this.selectedCount,
    this.onExportSelected,
    this.onDuplicateSelected,
    this.onDeleteSelected,
    this.onDeselectAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: selectedCount > 0 ? 16.h : 0,
      child: selectedCount > 0
          ? Container(
              decoration: BoxDecoration(
                color: AppTheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textPrimary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    children: [
                      // Selection info
                      Row(
                        children: [
                          GestureDetector(
                            onTap: onDeselectAll,
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme.surface,
                              size: 6.w,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              '$selectedCount design${selectedCount == 1 ? '' : 's'} selected',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppTheme.surface,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          TextButton(
                            onPressed: onDeselectAll,
                            child: Text(
                              'Deselect All',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        AppTheme.surface.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            context,
                            'file_download',
                            'Export',
                            onExportSelected,
                          ),
                          _buildActionButton(
                            context,
                            'content_copy',
                            'Duplicate',
                            onDuplicateSelected,
                          ),
                          _buildActionButton(
                            context,
                            'delete',
                            'Delete',
                            onDeleteSelected,
                            isDestructive: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.alert.withValues(alpha: 0.2)
              : AppTheme.surface.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive ? AppTheme.alert : AppTheme.surface,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isDestructive ? AppTheme.alert : AppTheme.surface,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDestructive ? AppTheme.alert : AppTheme.surface,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
