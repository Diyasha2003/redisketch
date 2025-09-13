import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AiSuggestionChipWidget extends StatefulWidget {
  final String garmentType;
  final Map<String, dynamic> currentCustomizations;
  final Function(Map<String, dynamic>) onSuggestionApplied;

  const AiSuggestionChipWidget({
    Key? key,
    required this.garmentType,
    required this.currentCustomizations,
    required this.onSuggestionApplied,
  }) : super(key: key);

  @override
  State<AiSuggestionChipWidget> createState() => _AiSuggestionChipWidgetState();
}

class _AiSuggestionChipWidgetState extends State<AiSuggestionChipWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isExpanded = false;

  final List<Map<String, dynamic>> aiSuggestions = [
    {
      "id": 1,
      "title": "Professional Look",
      "description": "Perfect for office wear with structured fit",
      "customizations": {
        "sleeve": "long",
        "neckline": "round",
        "fit": "regular",
        "hem": "straight",
      },
      "icon": "business_center",
      "color": "#74B49B",
    },
    {
      "id": 2,
      "title": "Casual Comfort",
      "description": "Relaxed style for everyday wear",
      "customizations": {
        "sleeve": "short",
        "neckline": "v-neck",
        "fit": "loose",
        "hem": "curved",
      },
      "icon": "weekend",
      "color": "#C9B6E4",
    },
    {
      "id": 3,
      "title": "Evening Elegance",
      "description": "Sophisticated design for special occasions",
      "customizations": {
        "sleeve": "3/4 length",
        "neckline": "boat",
        "fit": "slim",
        "hem": "asymmetric",
      },
      "icon": "star",
      "color": "#F28B82",
    },
    {
      "id": 4,
      "title": "Trendy Modern",
      "description": "Contemporary style with unique details",
      "customizations": {
        "sleeve": "sleeveless",
        "neckline": "square",
        "fit": "oversized",
        "hem": "high-low",
      },
      "icon": "trending_up",
      "color": "#74B49B",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isExpanded ? _buildExpandedView() : _buildCollapsedChip(),
    );
  }

  Widget _buildCollapsedChip() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = true;
              });
              _animationController.stop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'AI Suggestions',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  CustomIconWidget(
                    iconName: 'keyboard_arrow_up',
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandedView() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CustomIconWidget(
                    iconName: 'auto_awesome',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Design Suggestions',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Tap a suggestion to apply instantly',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = false;
                    });
                    _animationController.repeat(reverse: true);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Suggestions list
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: aiSuggestions.map((suggestion) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: _buildSuggestionCard(suggestion),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    final customizations = suggestion['customizations'] as Map<String, dynamic>;
    final isCurrentlyApplied = _isSuggestionApplied(customizations);

    return GestureDetector(
      onTap: () {
        if (!isCurrentlyApplied) {
          widget.onSuggestionApplied(customizations);
          _showAppliedFeedback(suggestion['title'] as String);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrentlyApplied
              ? AppTheme.accent.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrentlyApplied
                ? AppTheme.accent
                : AppTheme.lightTheme.colorScheme.outline,
            width: isCurrentlyApplied ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(
                    int.parse(suggestion['color'].replaceFirst('#', '0xFF'))),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: suggestion['icon'] as String,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        suggestion['title'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isCurrentlyApplied) ...[
                        SizedBox(width: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Applied',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    suggestion['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: customizations.entries.map((entry) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            if (!isCurrentlyApplied)
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  bool _isSuggestionApplied(Map<String, dynamic> suggestionCustomizations) {
    return suggestionCustomizations.entries.every((entry) {
      final currentValue = widget.currentCustomizations[entry.key];
      return currentValue?.toString().toLowerCase() ==
          entry.value.toString().toLowerCase();
    });
  }

  void _showAppliedFeedback(String suggestionTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text('$suggestionTitle applied successfully!'),
          ],
        ),
        backgroundColor: AppTheme.accent,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
