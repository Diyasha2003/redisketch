import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PatternPreviewHeader extends StatefulWidget {
  final String designTitle;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onExport;
  final VoidCallback onSave;
  final Function(String) onTitleChanged;

  const PatternPreviewHeader({
    Key? key,
    required this.designTitle,
    required this.onBack,
    required this.onShare,
    required this.onExport,
    required this.onSave,
    required this.onTitleChanged,
  }) : super(key: key);

  @override
  State<PatternPreviewHeader> createState() => _PatternPreviewHeaderState();
}

class _PatternPreviewHeaderState extends State<PatternPreviewHeader> {
  bool _isEditingTitle = false;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.designTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _toggleTitleEdit() {
    setState(() {
      _isEditingTitle = !_isEditingTitle;
    });

    if (!_isEditingTitle) {
      widget.onTitleChanged(_titleController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back Button
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
                width: 10.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 24,
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Design Title (Editable)
            Expanded(
              child: _isEditingTitle
                  ? TextField(
                      controller: _titleController,
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                      ),
                      onSubmitted: (_) => _toggleTitleEdit(),
                      autofocus: true,
                    )
                  : GestureDetector(
                      onTap: _toggleTitleEdit,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.designTitle,
                                style:
                                    AppTheme.lightTheme.textTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            CustomIconWidget(
                              iconName: 'edit',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),

            SizedBox(width: 3.w),

            // Action Menu
            Row(
              children: [
                _buildActionButton(
                  icon: 'share',
                  onTap: widget.onShare,
                ),
                SizedBox(width: 2.w),
                _buildActionButton(
                  icon: 'file_download',
                  onTap: widget.onExport,
                ),
                SizedBox(width: 2.w),
                _buildActionButton(
                  icon: 'bookmark',
                  onTap: widget.onSave,
                ),
              ],
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
        width: 10.w,
        height: 5.h,
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
