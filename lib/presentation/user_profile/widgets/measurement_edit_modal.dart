import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MeasurementEditModal extends StatefulWidget {
  final String? setName;
  final Map<String, double>? initialMeasurements;
  final Function(String name, Map<String, double> measurements) onSave;

  const MeasurementEditModal({
    Key? key,
    this.setName,
    this.initialMeasurements,
    required this.onSave,
  }) : super(key: key);

  @override
  State<MeasurementEditModal> createState() => _MeasurementEditModalState();
}

class _MeasurementEditModalState extends State<MeasurementEditModal> {
  late TextEditingController _nameController;
  late Map<String, double> _measurements;
  final _formKey = GlobalKey<FormState>();

  final List<MeasurementField> _measurementFields = [
    MeasurementField('chest', 'Chest', 'cm', 70, 150),
    MeasurementField('waist', 'Waist', 'cm', 60, 130),
    MeasurementField('hips', 'Hips', 'cm', 70, 150),
    MeasurementField('shoulder', 'Shoulder Width', 'cm', 30, 60),
    MeasurementField('sleeve', 'Sleeve Length', 'cm', 50, 90),
    MeasurementField('length', 'Garment Length', 'cm', 40, 120),
    MeasurementField('neck', 'Neck', 'cm', 30, 50),
    MeasurementField('inseam', 'Inseam', 'cm', 60, 100),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.setName ?? '');
    _measurements = Map<String, double>.from(widget.initialMeasurements ??
        {
          'chest': 90.0,
          'waist': 80.0,
          'hips': 95.0,
          'shoulder': 45.0,
          'sleeve': 70.0,
          'length': 80.0,
          'neck': 40.0,
          'inseam': 80.0,
        });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  widget.setName != null
                      ? 'Edit Measurements'
                      : 'New Measurement Set',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _saveMeasurements,
                  child: Text(
                    'Save',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Content
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name field
                    Text(
                      'Set Name',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter measurement set name',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name for this measurement set';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Measurements
                    Text(
                      'Measurements',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    ..._measurementFields
                        .map((field) => _buildMeasurementSlider(field)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementSlider(MeasurementField field) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                field.label,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_measurements[field.key]?.toStringAsFixed(0)} ${field.unit}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.accent,
              thumbColor: AppTheme.accent,
              overlayColor: AppTheme.accent.withValues(alpha: 0.2),
              inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              trackHeight: 0.5.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.w),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 4.w),
            ),
            child: Slider(
              value: _measurements[field.key] ?? field.min,
              min: field.min,
              max: field.max,
              divisions: ((field.max - field.min) * 2).round(),
              onChanged: (value) {
                setState(() {
                  _measurements[field.key] = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${field.min.toStringAsFixed(0)} ${field.unit}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${field.max.toStringAsFixed(0)} ${field.unit}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveMeasurements() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(_nameController.text.trim(), _measurements);
      Navigator.pop(context);
    }
  }
}

class MeasurementField {
  final String key;
  final String label;
  final String unit;
  final double min;
  final double max;

  MeasurementField(this.key, this.label, this.unit, this.min, this.max);
}
