import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import './widgets/fabric_roll_animation.dart';
import './widgets/material_estimation_sheet.dart';
import './widgets/pattern_display_widget.dart';
import './widgets/pattern_preview_header.dart';
import './widgets/pattern_zoom_controls.dart';

class PatternPreview extends StatefulWidget {
  const PatternPreview({Key? key}) : super(key: key);

  @override
  State<PatternPreview> createState() => _PatternPreviewState();
}

class _PatternPreviewState extends State<PatternPreview>
    with TickerProviderStateMixin {
  late AnimationController _sheetController;
  late Animation<double> _sheetAnimation;

  double _currentZoom = 1.0;
  bool _isSheetExpanded = false;
  bool _isExporting = false;
  bool _isSaving = false;
  String _designTitle = "Summer Casual Shirt";

  // Mock design data
  final Map<String, dynamic> _designData = {
    "id": "design_001",
    "garmentType": "Shirt",
    "size": "M",
    "fit": "Regular",
    "sleeveType": "Long Sleeve",
    "neckline": "Collar",
    "hemStyle": "Straight",
    "fabric": {
      "type": "Cotton",
      "color": "Light Blue",
      "pattern": "Solid",
      "texture": "Smooth"
    },
    "measurements": {
      "chest": 40.0,
      "waist": 36.0,
      "shoulder": 18.0,
      "sleeve_length": 25.0,
      "body_length": 28.0
    },
    "createdDate": "2025-01-05",
    "lastModified": "2025-01-05 12:02:05"
  };

  @override
  void initState() {
    super.initState();

    _sheetController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _sheetAnimation = Tween<double>(
      begin: 0.3,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _toggleSheet() {
    setState(() {
      _isSheetExpanded = !_isSheetExpanded;
    });

    if (_isSheetExpanded) {
      _sheetController.forward();
    } else {
      _sheetController.reverse();
    }
  }

  void _onBack() {
    if (_isSheetExpanded) {
      _toggleSheet();
      return;
    }

    _showSaveConfirmationDialog();
  }

  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Save Changes?',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Do you want to save your design before leaving?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(
                    context, '/design-customization');
              },
              child: Text(
                'Discard',
                style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveToLibrary().then((_) {
                  Navigator.pushReplacementNamed(context, '/pattern-library');
                });
              },
              child: Text(
                'Save',
                style:
                    TextStyle(color: AppTheme.lightTheme.colorScheme.secondary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onShare() async {
    try {
      final designSummary = _generateDesignSummary();

      if (kIsWeb) {
        // Web sharing using clipboard
        await Clipboard.setData(ClipboardData(text: designSummary));
        _showSuccessMessage('Design details copied to clipboard!');
      } else {
        // Mobile sharing using share_plus
        await Share.share(
          designSummary,
          subject: 'Check out my ${_designData['garmentType']} design!',
        );
      }
    } catch (e) {
      _showErrorMessage('Failed to share design. Please try again.');
    }
  }

  String _generateDesignSummary() {
    return '''
🧵 RediSketch Design: $_designTitle

📏 Details:
• Type: ${_designData['garmentType']}
• Size: ${_designData['size']}
• Fit: ${_designData['fit']}
• Sleeve: ${_designData['sleeveType']}
• Neckline: ${_designData['neckline']}

📐 Measurements:
• Chest: ${_designData['measurements']['chest']}"
• Waist: ${_designData['measurements']['waist']}"
• Length: ${_designData['measurements']['body_length']}"

🧶 Fabric: ${_designData['fabric']['type']} - ${_designData['fabric']['color']}

Created with RediSketch - Your Digital Sewing Companion
    ''';
  }

  Future<void> _onExport() async {
    setState(() {
      _isExporting = true;
    });

    try {
      await Future.delayed(
          const Duration(seconds: 2)); // Simulate PDF generation

      final pdfContent = _generatePDFContent();
      await _downloadFile(
          pdfContent, '${_designTitle.replaceAll(' ', '_')}_pattern.pdf');

      // Haptic feedback
      HapticFeedback.lightImpact();
      _showSuccessMessage('Pattern exported successfully!');
    } catch (e) {
      _showErrorMessage('Failed to export pattern. Please try again.');
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  String _generatePDFContent() {
    return '''
REDISKETCH PATTERN EXPORT
========================

Design: $_designTitle
Date: ${DateTime.now().toString().split(' ')[0]}

GARMENT DETAILS:
- Type: ${_designData['garmentType']}
- Size: ${_designData['size']}
- Fit: ${_designData['fit']}
- Sleeve Type: ${_designData['sleeveType']}
- Neckline: ${_designData['neckline']}
- Hem Style: ${_designData['hemStyle']}

MEASUREMENTS:
- Chest: ${_designData['measurements']['chest']}" / ${(_designData['measurements']['chest'] * 2.54).toStringAsFixed(1)}cm
- Waist: ${_designData['measurements']['waist']}" / ${(_designData['measurements']['waist'] * 2.54).toStringAsFixed(1)}cm
- Shoulder: ${_designData['measurements']['shoulder']}" / ${(_designData['measurements']['shoulder'] * 2.54).toStringAsFixed(1)}cm
- Sleeve Length: ${_designData['measurements']['sleeve_length']}" / ${(_designData['measurements']['sleeve_length'] * 2.54).toStringAsFixed(1)}cm
- Body Length: ${_designData['measurements']['body_length']}" / ${(_designData['measurements']['body_length'] * 2.54).toStringAsFixed(1)}cm

FABRIC REQUIREMENTS:
- Main Fabric: 2.5 yards
- Lining: 1.5 yards (optional)
- Interfacing: 0.5 yards

CUTTING INSTRUCTIONS:
1. Pre-wash and iron fabric
2. Lay fabric flat on cutting surface
3. Pin pattern pieces following grain line
4. Cut with sharp fabric scissors
5. Transfer all markings

CONSTRUCTION NOTES:
- Use 5/8" seam allowance unless otherwise noted
- Press seams as you sew
- Stay-stitch curved edges
- Interface collar and cuffs

Generated by RediSketch v1.0
© 2025 RediSketch - Digital Sewing Patterns
    ''';
  }

  Future<void> _downloadFile(String content, String filename) async {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      await file.writeAsString(content);
    }
  }

  Future<void> _saveToLibrary() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate save operation

      // In a real app, this would save to local storage or cloud
      final savedDesign = Map<String, dynamic>.from(_designData);
      savedDesign['title'] = _designTitle;
      savedDesign['savedDate'] = DateTime.now().toIso8601String();

      _showSuccessMessage('Design saved to library!');
    } catch (e) {
      _showErrorMessage('Failed to save design. Please try again.');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _onTitleChanged(String newTitle) {
    setState(() {
      _designTitle = newTitle;
    });
  }

  void _onZoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 0.25).clamp(0.5, 3.0);
    });
  }

  void _onZoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 0.25).clamp(0.5, 3.0);
    });
  }

  void _onResetZoom() {
    setState(() {
      _currentZoom = 1.0;
    });
  }

  void _onPanUpdate(double dx, double dy) {
    // Handle pan updates for pattern display
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.surface,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: AppTheme.lightTheme.colorScheme.surface,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.surface,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Header
              PatternPreviewHeader(
                designTitle: _designTitle,
                onBack: _onBack,
                onShare: _onShare,
                onExport: _onExport,
                onSave: () => _saveToLibrary(),
                onTitleChanged: _onTitleChanged,
              ),

              // Pattern Display Area
              Expanded(
                child: FabricRollAnimation(
                  shouldAnimate: true,
                  onAnimationComplete: () {
                    // Animation completed
                  },
                  child: PatternDisplayWidget(
                    designData: _designData,
                    zoom: _currentZoom,
                    onPanUpdate: _onPanUpdate,
                  ),
                ),
              ),
            ],
          ),

          // Zoom Controls
          PatternZoomControls(
            currentZoom: _currentZoom,
            onZoomIn: _onZoomIn,
            onZoomOut: _onZoomOut,
            onResetZoom: _onResetZoom,
          ),

          // Loading Overlays
          if (_isExporting)
            Container(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.8),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        offset: const Offset(0, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Generating PDF...',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Please wait while we create your pattern file',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_isSaving)
            Container(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.8),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        offset: const Offset(0, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Saving Design...',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom Sheet
          AnimatedBuilder(
            animation: _sheetAnimation,
            builder: (context, child) {
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height:
                    MediaQuery.of(context).size.height * _sheetAnimation.value,
                child: GestureDetector(
                  onTap: _toggleSheet,
                  onVerticalDragUpdate: (details) {
                    if (details.primaryDelta! < -10 && !_isSheetExpanded) {
                      _toggleSheet();
                    } else if (details.primaryDelta! > 10 && _isSheetExpanded) {
                      _toggleSheet();
                    }
                  },
                  child: MaterialEstimationSheet(
                    designData: _designData,
                    onExportPDF: _onExport,
                    onSaveToLibrary: () => _saveToLibrary(),
                    onShareDesign: _onShare,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}