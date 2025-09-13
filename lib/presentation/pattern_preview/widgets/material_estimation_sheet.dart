import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MaterialEstimationSheet extends StatefulWidget {
  final Map<String, dynamic> designData;
  final VoidCallback onExportPDF;
  final VoidCallback onSaveToLibrary;
  final VoidCallback onShareDesign;

  const MaterialEstimationSheet({
    Key? key,
    required this.designData,
    required this.onExportPDF,
    required this.onSaveToLibrary,
    required this.onShareDesign,
  }) : super(key: key);

  @override
  State<MaterialEstimationSheet> createState() =>
      _MaterialEstimationSheetState();
}

class _MaterialEstimationSheetState extends State<MaterialEstimationSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
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
              children: [
                CustomIconWidget(
                  iconName: 'calculate',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Material Estimation',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: AppTheme.lightTheme.colorScheme.surface,
              unselectedLabelColor:
                  AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              tabs: const [
                Tab(text: 'Pattern Details'),
                Tab(text: 'Materials'),
                Tab(text: 'Instructions'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPatternDetailsTab(),
                _buildMaterialsTab(),
                _buildInstructionsTab(),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.05),
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    title: 'Export PDF',
                    icon: 'picture_as_pdf',
                    color: AppTheme.lightTheme.primaryColor,
                    onTap: widget.onExportPDF,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildActionButton(
                    title: 'Save to Library',
                    icon: 'bookmark_add',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    onTap: widget.onSaveToLibrary,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildActionButton(
                    title: 'Share Design',
                    icon: 'share',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    onTap: widget.onShareDesign,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatternDetailsTab() {
    final measurements =
        widget.designData['measurements'] as Map<String, dynamic>? ?? {};
    final garmentType =
        widget.designData['garmentType'] as String? ?? 'Unknown';
    final size = widget.designData['size'] as String? ?? 'M';

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard(
            title: 'Garment Information',
            children: [
              _buildDetailRow('Type', garmentType),
              _buildDetailRow('Size', size),
              _buildDetailRow(
                  'Fit', widget.designData['fit'] as String? ?? 'Regular'),
            ],
          ),
          SizedBox(height: 3.h),
          _buildDetailCard(
            title: 'Measurements',
            children: measurements.entries.map((entry) {
              return _buildDetailRow(
                entry.key.replaceAll('_', ' ').toUpperCase(),
                '${entry.value}" / ${(entry.value * 2.54).toStringAsFixed(1)}cm',
              );
            }).toList(),
          ),
          SizedBox(height: 3.h),
          _buildDetailCard(
            title: 'Design Features',
            children: [
              _buildDetailRow('Sleeve Type',
                  widget.designData['sleeveType'] as String? ?? 'Regular'),
              _buildDetailRow('Neckline',
                  widget.designData['neckline'] as String? ?? 'Round'),
              _buildDetailRow('Hem Style',
                  widget.designData['hemStyle'] as String? ?? 'Straight'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsTab() {
    final fabricData =
        widget.designData['fabric'] as Map<String, dynamic>? ?? {};
    final fabricRequirement = _calculateFabricRequirement();

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard(
            title: 'Fabric Requirements',
            children: [
              _buildDetailRow(
                  'Main Fabric', '${fabricRequirement['main']} yards'),
              _buildDetailRow(
                  'Lining (Optional)', '${fabricRequirement['lining']} yards'),
              _buildDetailRow(
                  'Interfacing', '${fabricRequirement['interfacing']} yards'),
            ],
          ),
          SizedBox(height: 3.h),
          _buildDetailCard(
            title: 'Selected Fabric',
            children: [
              _buildDetailRow(
                  'Type', fabricData['type'] as String? ?? 'Cotton'),
              _buildDetailRow(
                  'Color', fabricData['color'] as String? ?? 'Blue'),
              _buildDetailRow('Width', '45" / 114cm'),
              _buildDetailRow('Estimated Cost',
                  '\$${_calculateEstimatedCost().toStringAsFixed(2)}'),
            ],
          ),
          SizedBox(height: 3.h),
          _buildDetailCard(
            title: 'Additional Materials',
            children: [
              _buildDetailRow('Thread', '1 spool'),
              _buildDetailRow('Buttons', '6-8 pieces'),
              _buildDetailRow('Zipper (if needed)', '1 piece (22")'),
              _buildDetailRow('Elastic (if needed)', '1 yard'),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.secondary,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Total Estimated Cost',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  '\$${(_calculateEstimatedCost() + 15.99).toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Including materials and notions',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInstructionStep(
            stepNumber: 1,
            title: 'Prepare Your Fabric',
            description:
                'Pre-wash and iron your fabric. Lay it flat on a cutting surface.',
          ),
          _buildInstructionStep(
            stepNumber: 2,
            title: 'Cut Pattern Pieces',
            description:
                'Print the pattern at 100% scale. Cut out all pattern pieces following the cutting layout.',
          ),
          _buildInstructionStep(
            stepNumber: 3,
            title: 'Mark Important Points',
            description:
                'Transfer all notches, darts, and construction marks to your fabric pieces.',
          ),
          _buildInstructionStep(
            stepNumber: 4,
            title: 'Sew Darts and Seams',
            description:
                'Start with darts, then sew shoulder seams and side seams with 5/8" seam allowance.',
          ),
          _buildInstructionStep(
            stepNumber: 5,
            title: 'Attach Sleeves',
            description:
                'Set in sleeves, matching notches and easing any fullness around the sleeve cap.',
          ),
          _buildInstructionStep(
            stepNumber: 6,
            title: 'Finish Neckline',
            description:
                'Apply facing or binding to the neckline according to your chosen style.',
          ),
          _buildInstructionStep(
            stepNumber: 7,
            title: 'Hem and Finish',
            description:
                'Hem the bottom edge and sleeves. Press all seams and give a final press.',
          ),
          SizedBox(height: 4.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'lightbulb',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 32,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Pro Tip',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Always make a test garment (muslin) first to check fit before cutting your final fabric.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep({
    required int stepNumber,
    required String title,
    required String description,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                ),
                SizedBox(height: 1.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.surface,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.surface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, double> _calculateFabricRequirement() {
    final garmentType = widget.designData['garmentType'] as String? ?? 'shirt';
    final size = widget.designData['size'] as String? ?? 'M';

    // Base fabric requirements in yards
    double mainFabric = 2.5;
    double lining = 1.5;
    double interfacing = 0.5;

    // Adjust based on garment type
    switch (garmentType.toLowerCase()) {
      case 'dress':
        mainFabric = 3.5;
        lining = 2.5;
        break;
      case 'saree jacket':
        mainFabric = 2.0;
        lining = 1.5;
        break;
      case 't-shirt':
        mainFabric = 1.5;
        lining = 0.0;
        interfacing = 0.25;
        break;
    }

    // Adjust based on size
    switch (size.toUpperCase()) {
      case 'XS':
      case 'S':
        mainFabric *= 0.9;
        lining *= 0.9;
        break;
      case 'L':
        mainFabric *= 1.1;
        lining *= 1.1;
        break;
      case 'XL':
        mainFabric *= 1.2;
        lining *= 1.2;
        break;
    }

    return {
      'main': double.parse(mainFabric.toStringAsFixed(1)),
      'lining': double.parse(lining.toStringAsFixed(1)),
      'interfacing': double.parse(interfacing.toStringAsFixed(1)),
    };
  }

  double _calculateEstimatedCost() {
    final fabricRequirement = _calculateFabricRequirement();
    const double fabricPricePerYard = 12.99;

    return (fabricRequirement['main']! * fabricPricePerYard) +
        (fabricRequirement['lining']! * fabricPricePerYard * 0.8) +
        (fabricRequirement['interfacing']! * fabricPricePerYard * 0.6);
  }
}
