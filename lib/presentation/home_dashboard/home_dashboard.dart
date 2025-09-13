import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_suggestions_widget.dart';
import './widgets/create_design_hero_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/quick_start_widget.dart';
import './widgets/recent_designs_widget.dart';
import './widgets/statistics_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  bool isEnglish = true;

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Amara Silva",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
  };

  // Mock recent designs data
  final List<Map<String, dynamic>> recentDesigns = [
    {
      "id": "1",
      "title": "Summer Dress",
      "type": "Dress",
      "thumbnail":
          "https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=300&h=200&fit=crop",
      "createdAt": "2025-01-02",
    },
    {
      "id": "2",
      "title": "Casual Shirt",
      "type": "Shirt",
      "thumbnail":
          "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=300&h=200&fit=crop",
      "createdAt": "2025-01-01",
    },
    {
      "id": "3",
      "title": "Evening Saree Jacket",
      "type": "Saree Jacket",
      "thumbnail":
          "https://images.unsplash.com/photo-1583391733956-6c78276477e2?w=300&h=200&fit=crop",
      "createdAt": "2024-12-30",
    },
  ];

  // Mock AI suggestions data
  final List<Map<String, dynamic>> aiSuggestions = [
    {
      "id": "1",
      "title": "Autumn Vibes",
      "fabric": "Cotton Blend",
      "colors": ["#D2691E", "#8B4513", "#CD853F"],
    },
    {
      "id": "2",
      "title": "Ocean Breeze",
      "fabric": "Linen",
      "colors": ["#4682B4", "#87CEEB", "#B0E0E6"],
    },
    {
      "id": "3",
      "title": "Sunset Glow",
      "fabric": "Silk",
      "colors": ["#FF6347", "#FF7F50", "#FFA07A"],
    },
  ];

  // Mock statistics data
  final Map<String, dynamic> statistics = {
    "totalDesigns": 12,
    "completedPatterns": 8,
    "sharedDesigns": 5,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshDashboard,
          color: AppTheme.accent,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingHeaderWidget(
                  userName: userData["name"] as String,
                  userAvatar: userData["avatar"] as String,
                  onLanguageToggle: _toggleLanguage,
                  onProfileTap: _navigateToProfile,
                  isEnglish: isEnglish,
                ),
                CreateDesignHeroWidget(
                  onCreateDesign: _navigateToDesignCustomization,
                  isEnglish: isEnglish,
                ),
                RecentDesignsWidget(
                  recentDesigns: recentDesigns,
                  isEnglish: isEnglish,
                  onEdit: _editDesign,
                  onDuplicate: _duplicateDesign,
                  onShare: _shareDesign,
                ),
                SizedBox(height: 2.h),
                QuickStartWidget(
                  isEnglish: isEnglish,
                  onGarmentSelect: _selectGarmentType,
                ),
                SizedBox(height: 2.h),
                AiSuggestionsWidget(
                  suggestions: aiSuggestions,
                  isEnglish: isEnglish,
                  onSuggestionTap: _applySuggestion,
                ),
                StatisticsWidget(
                  statistics: statistics,
                  isEnglish: isEnglish,
                ),
                SizedBox(height: 10.h), // Bottom padding for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToDesignCustomization,
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.surface,
        icon: CustomIconWidget(
          iconName: 'add',
          size: 6.w,
          color: AppTheme.surface,
        ),
        label: Text(
          isEnglish ? 'Create' : 'නිර්මාණය',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.surface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _refreshDashboard() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would refresh data from API
    setState(() {
      // Refresh logic here
    });
  }

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
    });
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/user-profile');
  }

  void _navigateToDesignCustomization() {
    Navigator.pushNamed(context, '/design-customization');
  }

  void _editDesign(String designId) {
    Navigator.pushNamed(
      context,
      '/design-customization',
      arguments: {'designId': designId, 'mode': 'edit'},
    );
  }

  void _duplicateDesign(String designId) {
    Navigator.pushNamed(
      context,
      '/design-customization',
      arguments: {'designId': designId, 'mode': 'duplicate'},
    );
  }

  void _shareDesign(String designId) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEnglish
              ? 'Design shared successfully!'
              : 'නිර්මාණය සාර්ථකව බෙදාගන්නා ලදී!',
        ),
        backgroundColor: AppTheme.accent,
      ),
    );
  }

  void _selectGarmentType(String garmentType) {
    Navigator.pushNamed(
      context,
      '/design-customization',
      arguments: {'garmentType': garmentType},
    );
  }

  void _applySuggestion(String suggestionId) {
    final suggestion = aiSuggestions.firstWhere(
      (s) => (s["id"] as String) == suggestionId,
      orElse: () => <String, dynamic>{},
    );

    if (suggestion.isNotEmpty) {
      Navigator.pushNamed(
        context,
        '/design-customization',
        arguments: {'suggestion': suggestion},
      );
    }
  }
}
