import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CustomizationTabsWidget extends StatefulWidget {
  final Function(String, dynamic) onCustomizationChanged;
  final Map<String, dynamic> currentCustomizations;

  const CustomizationTabsWidget({
    Key? key,
    required this.onCustomizationChanged,
    required this.currentCustomizations,
  }) : super(key: key);

  @override
  State<CustomizationTabsWidget> createState() =>
      _CustomizationTabsWidgetState();
}

class _CustomizationTabsWidgetState extends State<CustomizationTabsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Sleeve', 'Neckline', 'Hem', 'Fit'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tab Bar
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
              labelColor: AppTheme.lightTheme.colorScheme.primary,
              unselectedLabelColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              indicatorColor: AppTheme.lightTheme.colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: AppTheme.lightTheme.textTheme.labelLarge,
              unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
              dividerColor: Colors.transparent,
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSleeveTab(),
                _buildNecklineTab(),
                _buildHemTab(),
                _buildFitTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleeveTab() {
    final sleeveOptions = ['Long', 'Short', 'Sleeveless', '3/4 Length'];
    final currentSleeve = widget.currentCustomizations['sleeve'] ?? 'Long';

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleeve Style',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: sleeveOptions.length,
              itemBuilder: (context, index) {
                final option = sleeveOptions[index];
                final isSelected =
                    currentSleeve.toLowerCase() == option.toLowerCase();

                return GestureDetector(
                  onTap: () {
                    widget.onCustomizationChanged(
                        'sleeve', option.toLowerCase());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primaryContainer
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
                        option,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNecklineTab() {
    final necklineOptions = ['Round', 'V-Neck', 'Square', 'Boat', 'High Neck'];
    final currentNeckline = widget.currentCustomizations['neckline'] ?? 'Round';

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Neckline Style',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: necklineOptions.length,
              itemBuilder: (context, index) {
                final option = necklineOptions[index];
                final isSelected =
                    currentNeckline.toLowerCase() == option.toLowerCase();

                return GestureDetector(
                  onTap: () {
                    widget.onCustomizationChanged(
                        'neckline', option.toLowerCase());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primaryContainer
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
                        option,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHemTab() {
    final hemOptions = ['Straight', 'Curved', 'Asymmetric', 'High-Low'];
    final currentHem = widget.currentCustomizations['hem'] ?? 'Straight';

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hem Style',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: hemOptions.length,
                    itemBuilder: (context, index) {
                      final option = hemOptions[index];
                      final isSelected =
                          currentHem.toLowerCase() == option.toLowerCase();

                      return GestureDetector(
                        onTap: () {
                          widget.onCustomizationChanged(
                              'hem', option.toLowerCase());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme
                                    .lightTheme.colorScheme.primaryContainer
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
                              option,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                // Length slider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Length: ${(widget.currentCustomizations['length'] ?? 50.0).toInt()}%',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    Slider(
                      value: (widget.currentCustomizations['length'] ?? 50.0)
                          .toDouble(),
                      min: 20.0,
                      max: 100.0,
                      divisions: 80,
                      onChanged: (value) {
                        widget.onCustomizationChanged('length', value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFitTab() {
    final fitOptions = ['Slim', 'Regular', 'Loose', 'Oversized'];
    final currentFit = widget.currentCustomizations['fit'] ?? 'Regular';

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fit Style',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: fitOptions.length,
                    itemBuilder: (context, index) {
                      final option = fitOptions[index];
                      final isSelected =
                          currentFit.toLowerCase() == option.toLowerCase();

                      return GestureDetector(
                        onTap: () {
                          widget.onCustomizationChanged(
                              'fit', option.toLowerCase());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme
                                    .lightTheme.colorScheme.primaryContainer
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
                              option,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                // Ease slider
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ease: ${(widget.currentCustomizations['ease'] ?? 2.0).toInt()} inches',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    Slider(
                      value: (widget.currentCustomizations['ease'] ?? 2.0)
                          .toDouble(),
                      min: 0.0,
                      max: 6.0,
                      divisions: 12,
                      onChanged: (value) {
                        widget.onCustomizationChanged('ease', value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
