import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MeasurementSetsWidget extends StatelessWidget {
  final List<MeasurementSet> measurementSets;
  final String? defaultSetId;
  final Function(String setId) onSetDefault;
  final Function(String setId) onEditSet;
  final Function(String setId) onDeleteSet;
  final VoidCallback onAddNew;

  const MeasurementSetsWidget({
    Key? key,
    required this.measurementSets,
    this.defaultSetId,
    required this.onSetDefault,
    required this.onEditSet,
    required this.onDeleteSet,
    required this.onAddNew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Measurement Sets',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onAddNew,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.lightTheme.colorScheme.surface,
                      size: 4.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          measurementSets.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  child: Center(
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'straighten',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 12.w,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'No measurement sets saved',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Add your first measurement set',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: measurementSets.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    indent: 4.w,
                    endIndent: 4.w,
                  ),
                  itemBuilder: (context, index) {
                    final set = measurementSets[index];
                    final isDefault = set.id == defaultSetId;

                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Row(
                        children: [
                          Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: isDefault
                                  ? AppTheme.accent.withValues(alpha: 0.2)
                                  : AppTheme
                                      .lightTheme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'straighten',
                              color: isDefault
                                  ? AppTheme.accent
                                  : AppTheme.lightTheme.colorScheme.primary,
                              size: 5.w,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      set.name,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (isDefault) ...[
                                      SizedBox(width: 2.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                          color: AppTheme.accent,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Default',
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: AppTheme
                                                .lightTheme.colorScheme.surface,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Created ${set.createdDate}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'default':
                                  onSetDefault(set.id);
                                  break;
                                case 'edit':
                                  onEditSet(set.id);
                                  break;
                                case 'delete':
                                  onDeleteSet(set.id);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              if (!isDefault)
                                PopupMenuItem(
                                  value: 'default',
                                  child: Row(
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'star',
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        size: 4.w,
                                      ),
                                      SizedBox(width: 2.w),
                                      Text('Set as Default'),
                                    ],
                                  ),
                                ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'edit',
                                      color: AppTheme
                                          .lightTheme.colorScheme.onSurface,
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'delete',
                                      color: AppTheme.alert,
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: AppTheme.alert),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            child: CustomIconWidget(
                              iconName: 'more_vert',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 5.w,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class MeasurementSet {
  final String id;
  final String name;
  final String createdDate;
  final Map<String, double> measurements;

  MeasurementSet({
    required this.id,
    required this.name,
    required this.createdDate,
    required this.measurements,
  });
}
