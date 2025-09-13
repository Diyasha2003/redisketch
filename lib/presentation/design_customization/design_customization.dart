import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_suggestion_chip_widget.dart';
import './widgets/customization_tabs_widget.dart';
import './widgets/fabric_selection_widget.dart';
import './widgets/garment_preview_widget.dart';
import './widgets/measurement_input_widget.dart';

class DesignCustomization extends StatefulWidget {
  const DesignCustomization({Key? key}) : super(key: key);

  @override
  State<DesignCustomization> createState() => _DesignCustomizationState();
}

class _DesignCustomizationState extends State<DesignCustomization>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Design state
  String selectedGarment = 'Shirt';
  Map<String, dynamic> customizations = {
    'sleeve': 'long',
    'neckline': 'round',
    'hem': 'straight',
    'fit': 'regular',
    'length': 50.0,
    'ease': 2.0,
  };

  Map<String, dynamic>? selectedFabric;
  Map<String, dynamic> measurements = {
    'sizeMode': 'Standard',
    'standardSize': 'M',
    'chest': 36.0,
    'waist': 30.0,
    'hip': 38.0,
    'shoulder': 16.0,
    'length': 26.0,
  };

  bool hasUnsavedChanges = false;
  List<Map<String, dynamic>> undoStack = [];
  List<Map<String, dynamic>> redoStack = [];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabAnimationController.forward();
    _saveToUndoStack();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _saveToUndoStack() {
    undoStack.add({
      'customizations': Map<String, dynamic>.from(customizations),
      'selectedFabric': selectedFabric != null
          ? Map<String, dynamic>.from(selectedFabric!)
          : null,
      'measurements': Map<String, dynamic>.from(measurements),
    });
    if (undoStack.length > 10) {
      undoStack.removeAt(0);
    }
    redoStack.clear();
  }

  void _undo() {
    if (undoStack.length > 1) {
      final currentState = undoStack.removeLast();
      redoStack.add(currentState);

      final previousState = undoStack.last;
      setState(() {
        customizations =
            Map<String, dynamic>.from(previousState['customizations']);
        selectedFabric = previousState['selectedFabric'] != null
            ? Map<String, dynamic>.from(previousState['selectedFabric'])
            : null;
        measurements = Map<String, dynamic>.from(previousState['measurements']);
        hasUnsavedChanges = true;
      });
    }
  }

  void _redo() {
    if (redoStack.isNotEmpty) {
      final nextState = redoStack.removeLast();
      undoStack.add(nextState);

      setState(() {
        customizations = Map<String, dynamic>.from(nextState['customizations']);
        selectedFabric = nextState['selectedFabric'] != null
            ? Map<String, dynamic>.from(nextState['selectedFabric'])
            : null;
        measurements = Map<String, dynamic>.from(nextState['measurements']);
        hasUnsavedChanges = true;
      });
    }
  }

  void _onCustomizationChanged(String key, dynamic value) {
    setState(() {
      customizations[key] = value;
      hasUnsavedChanges = true;
    });
    _saveToUndoStack();
  }

  void _onFabricSelected(Map<String, dynamic> fabric) {
    setState(() {
      selectedFabric = fabric;
      hasUnsavedChanges = true;
    });
    _saveToUndoStack();
  }

  void _onMeasurementsChanged(Map<String, dynamic> newMeasurements) {
    setState(() {
      measurements = newMeasurements;
      hasUnsavedChanges = true;
    });
    _saveToUndoStack();
  }

  void _onAiSuggestionApplied(Map<String, dynamic> suggestions) {
    setState(() {
      customizations.addAll(suggestions);
      hasUnsavedChanges = true;
    });
    _saveToUndoStack();
  }

  void _showFabricSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FabricSelectionWidget(
        onFabricSelected: _onFabricSelected,
        selectedFabric: selectedFabric,
      ),
    );
  }

  void _showMeasurementInput() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MeasurementInputWidget(
        onMeasurementsChanged: _onMeasurementsChanged,
        currentMeasurements: measurements,
      ),
    );
  }

  void _previewFullDesign() {
    Navigator.pushNamed(context, '/pattern-preview');
  }

  Future<bool> _onWillPop() async {
    if (hasUnsavedChanges) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Unsaved Changes'),
              content: Text(
                  'You have unsaved changes. Do you want to save before leaving?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Discard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Auto-save logic here
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Design Customization'),
          leading: GestureDetector(
            onTap: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          ),
          actions: [
            // Undo button
            GestureDetector(
              onTap: undoStack.length > 1 ? _undo : null,
              child: Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: undoStack.length > 1
                      ? AppTheme.lightTheme.colorScheme.surface
                      : AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'undo',
                  color: undoStack.length > 1
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
            ),

            // Redo button
            GestureDetector(
              onTap: redoStack.isNotEmpty ? _redo : null,
              child: Container(
                margin: EdgeInsets.only(right: 16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: redoStack.isNotEmpty
                      ? AppTheme.lightTheme.colorScheme.surface
                      : AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: CustomIconWidget(
                  iconName: 'redo',
                  color: redoStack.isNotEmpty
                      ? AppTheme.lightTheme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Garment preview section (40% of screen)
            Container(
              height: 40.h,
              padding: EdgeInsets.all(16),
              child: GarmentPreviewWidget(
                selectedGarment: selectedGarment,
                customizations: customizations,
                onZoomIn: () {},
                onZoomOut: () {},
              ),
            ),

            // AI Suggestion chip
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AiSuggestionChipWidget(
                garmentType: selectedGarment,
                currentCustomizations: customizations,
                onSuggestionApplied: _onAiSuggestionApplied,
              ),
            ),

            // Customization controls section (remaining space)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomizationTabsWidget(
                  onCustomizationChanged: _onCustomizationChanged,
                  currentCustomizations: customizations,
                ),
              ),
            ),

            // Bottom action buttons
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Fabric selection button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showFabricSelection,
                      icon: CustomIconWidget(
                        iconName: 'palette',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text(
                        selectedFabric != null
                            ? selectedFabric!['name'] as String
                            : 'Select Fabric',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  // Measurements button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showMeasurementInput,
                      icon: CustomIconWidget(
                        iconName: 'straighten',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                      label: Text(
                        measurements['sizeMode'] == 'Standard'
                            ? 'Size ${measurements['standardSize']}'
                            : 'Custom',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: AnimatedBuilder(
          animation: _fabAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _fabAnimation.value,
              child: FloatingActionButton.extended(
                onPressed: _previewFullDesign,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                icon: CustomIconWidget(
                  iconName: 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 24,
                ),
                label: Text(
                  'Preview Full Design',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
