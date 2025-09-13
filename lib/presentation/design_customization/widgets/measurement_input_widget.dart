import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MeasurementInputWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onMeasurementsChanged;
  final Map<String, dynamic> currentMeasurements;

  const MeasurementInputWidget({
    Key? key,
    required this.onMeasurementsChanged,
    required this.currentMeasurements,
  }) : super(key: key);

  @override
  State<MeasurementInputWidget> createState() => _MeasurementInputWidgetState();
}

class _MeasurementInputWidgetState extends State<MeasurementInputWidget> {
  String selectedSizeMode = 'Standard'; // Standard or Custom
  String selectedStandardSize = 'M';

  final List<String> standardSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  final Map<String, Map<String, double>> standardMeasurements = {
    'XS': {'chest': 32, 'waist': 26, 'hip': 34, 'shoulder': 14, 'length': 24},
    'S': {'chest': 34, 'waist': 28, 'hip': 36, 'shoulder': 15, 'length': 25},
    'M': {'chest': 36, 'waist': 30, 'hip': 38, 'shoulder': 16, 'length': 26},
    'L': {'chest': 38, 'waist': 32, 'hip': 40, 'shoulder': 17, 'length': 27},
    'XL': {'chest': 40, 'waist': 34, 'hip': 42, 'shoulder': 18, 'length': 28},
    'XXL': {'chest': 42, 'waist': 36, 'hip': 44, 'shoulder': 19, 'length': 29},
  };

  @override
  void initState() {
    super.initState();
    selectedStandardSize = widget.currentMeasurements['standardSize'] ?? 'M';
    selectedSizeMode = widget.currentMeasurements['sizeMode'] ?? 'Standard';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Measurements',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Size mode toggle
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSizeMode = 'Standard';
                      });
                      _updateMeasurements();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedSizeMode == 'Standard'
                            ? AppTheme.lightTheme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Standard Sizes',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: selectedSizeMode == 'Standard'
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSizeMode = 'Custom';
                      });
                      _updateMeasurements();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedSizeMode == 'Custom'
                            ? AppTheme.lightTheme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Custom',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: selectedSizeMode == 'Custom'
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Content based on selected mode
          Expanded(
            child: selectedSizeMode == 'Standard'
                ? _buildStandardSizeContent()
                : _buildCustomSizeContent(),
          ),

          // Apply button
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                _updateMeasurements();
                Navigator.pop(context);
              },
              child: Text('Apply Measurements'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardSizeContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Size',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 16),

          // Size buttons
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: standardSizes.map((size) {
              final isSelected = selectedStandardSize == size;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedStandardSize = size;
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 24),

          // Size chart
          Text(
            'Size Chart (inches)',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 16),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primaryContainer,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text('Size',
                                style:
                                    AppTheme.lightTheme.textTheme.labelLarge)),
                        Expanded(
                            child: Text('Chest',
                                style:
                                    AppTheme.lightTheme.textTheme.labelLarge)),
                        Expanded(
                            child: Text('Waist',
                                style:
                                    AppTheme.lightTheme.textTheme.labelLarge)),
                        Expanded(
                            child: Text('Hip',
                                style:
                                    AppTheme.lightTheme.textTheme.labelLarge)),
                      ],
                    ),
                  ),

                  // Size data
                  Expanded(
                    child: ListView.builder(
                      itemCount: standardSizes.length,
                      itemBuilder: (context, index) {
                        final size = standardSizes[index];
                        final measurements = standardMeasurements[size]!;
                        final isSelected = selectedStandardSize == size;

                        return Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme
                                    .lightTheme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.3)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  size,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${measurements['chest']?.toInt()}"',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${measurements['waist']?.toInt()}"',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${measurements['hip']?.toInt()}"',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSizeContent() {
    final measurements = ['chest', 'waist', 'hip', 'shoulder', 'length'];
    final measurementLabels = {
      'chest': 'Chest/Bust',
      'waist': 'Waist',
      'hip': 'Hip',
      'shoulder': 'Shoulder Width',
      'length': 'Length',
    };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Measurements (inches)',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final measurement = measurements[index];
                final label = measurementLabels[measurement]!;
                final currentValue = widget.currentMeasurements[measurement] ??
                    standardMeasurements['M']![measurement]!;

                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: AppTheme.lightTheme.textTheme.bodyLarge,
                          ),
                          Text(
                            '${currentValue.toInt()}"',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Slider(
                        value: currentValue,
                        min: _getMinValue(measurement),
                        max: _getMaxValue(measurement),
                        divisions: (_getMaxValue(measurement) -
                                _getMinValue(measurement))
                            .toInt(),
                        onChanged: (value) {
                          setState(() {
                            widget.currentMeasurements[measurement] = value;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getMinValue(String measurement) {
    switch (measurement) {
      case 'chest':
        return 28.0;
      case 'waist':
        return 22.0;
      case 'hip':
        return 30.0;
      case 'shoulder':
        return 12.0;
      case 'length':
        return 20.0;
      default:
        return 20.0;
    }
  }

  double _getMaxValue(String measurement) {
    switch (measurement) {
      case 'chest':
        return 50.0;
      case 'waist':
        return 45.0;
      case 'hip':
        return 55.0;
      case 'shoulder':
        return 25.0;
      case 'length':
        return 35.0;
      default:
        return 40.0;
    }
  }

  void _updateMeasurements() {
    final measurements = Map<String, dynamic>.from(widget.currentMeasurements);
    measurements['sizeMode'] = selectedSizeMode;

    if (selectedSizeMode == 'Standard') {
      measurements['standardSize'] = selectedStandardSize;
      final standardMeasurement = standardMeasurements[selectedStandardSize]!;
      measurements.addAll(standardMeasurement);
    }

    widget.onMeasurementsChanged(measurements);
  }
}
