import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStartWidget extends StatelessWidget {
  final bool isEnglish;
  final Function(String) onGarmentSelect;

  const QuickStartWidget({
    Key? key,
    required this.isEnglish,
    required this.onGarmentSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quickStartItems = [
      {
        "id": "shirt",
        "nameEn": "Shirt",
        "nameSi": "කමිසය",
        "icon": "checkroom",
        "color": AppTheme.accent,
      },
      {
        "id": "dress",
        "nameEn": "Dress",
        "nameSi": "ඇඳුම",
        "icon": "woman",
        "color": AppTheme.highlight,
      },
      {
        "id": "tshirt",
        "nameEn": "T-Shirt",
        "nameSi": "ටී-ෂර්ට්",
        "icon": "sports_esports",
        "color": AppTheme.alert,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            isEnglish ? 'Quick Start' : 'ඉක්මන් ආරම්භය',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            isEnglish
                ? 'Choose a garment type to start designing'
                : 'නිර්මාණය ආරම්භ කිරීමට ඇඳුම් වර්ගයක් තෝරන්න',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 15.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: quickStartItems.length,
            itemBuilder: (context, index) {
              final item = quickStartItems[index];
              return _buildQuickStartCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStartCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => onGarmentSelect(item["id"] as String),
      child: Container(
        width: 25.w,
        margin: EdgeInsets.only(right: 3.w),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (item["color"] as Color).withValues(alpha: 0.1),
                  AppTheme.surface,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: (item["color"] as Color).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: item["icon"] as String,
                    size: 8.w,
                    color: item["color"] as Color,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  isEnglish
                      ? item["nameEn"] as String
                      : item["nameSi"] as String,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
