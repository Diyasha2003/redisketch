import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool showDivider;

  const SettingsItemWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                leading != null
                    ? Container(
                        margin: EdgeInsets.only(right: 3.w),
                        child: leading,
                      )
                    : const SizedBox(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: isDestructive
                              ? AppTheme.alert
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 0.5.h),
                              child: Text(
                                subtitle!,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                trailing != null
                    ? Container(
                        margin: EdgeInsets.only(left: 2.w),
                        child: trailing,
                      )
                    : CustomIconWidget(
                        iconName: 'chevron_right',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
              ],
            ),
          ),
        ),
        showDivider
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                height: 1,
                color: AppTheme.border.withValues(alpha: 0.3),
              )
            : const SizedBox(),
      ],
    );
  }
}
