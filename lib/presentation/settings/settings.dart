import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/language_toggle_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/storage_info_widget.dart';
import './widgets/theme_selector_widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _currentLanguage = 'en';
  String _currentTheme = 'light';
  String _measurementUnit = 'metric';
  bool _designCompletionNotifications = true;
  bool _sharingActivityNotifications = false;
  bool _appUpdateNotifications = true;
  bool _dataSharing = false;
  bool _analyticsOptOut = true;
  String _aiSuggestionFrequency = 'medium';

  final List<Map<String, dynamic>> _mockSettings = [
    {
      "cacheSize": "24.5 MB",
      "patternCount": 12,
      "appVersion": "1.2.3",
      "buildNumber": "45",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondary,
      appBar: AppBar(
        title: Text(
          _currentLanguage == 'si' ? 'සැකසුම්' : 'Settings',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.surface,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.surface,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // General Settings Section
              SettingsSectionWidget(
                title: _currentLanguage == 'si' ? 'සාමාන්‍ය' : 'General',
                children: [
                  LanguageToggleWidget(
                    currentLanguage: _currentLanguage,
                    onLanguageChanged: _handleLanguageChange,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 1,
                    color: AppTheme.border.withValues(alpha: 0.3),
                  ),
                  ThemeSelectorWidget(
                    currentTheme: _currentTheme,
                    onThemeChanged: _handleThemeChange,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 1,
                    color: AppTheme.border.withValues(alpha: 0.3),
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'මිනුම් ඒකක'
                        : 'Measurement Units',
                    subtitle: _measurementUnit == 'metric'
                        ? (_currentLanguage == 'si'
                            ? 'මෙට්‍රික් (සෙ.මී., කි.ග්‍රෑ.)'
                            : 'Metric (cm, kg)')
                        : (_currentLanguage == 'si'
                            ? 'ඉම්පීරියල් (අඟල්, පවුම්)'
                            : 'Imperial (inches, lbs)'),
                    leading: CustomIconWidget(
                      iconName: 'straighten',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: _showMeasurementUnitDialog,
                    showDivider: false,
                  ),
                ],
              ),

              // Design Preferences Section
              SettingsSectionWidget(
                title: _currentLanguage == 'si'
                    ? 'නිර්මාණ මනාපයන්'
                    : 'Design Preferences',
                children: [
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'පෙරනිමි රෙදිපිළි වර්ග'
                        : 'Default Fabric Types',
                    subtitle: _currentLanguage == 'si'
                        ? 'කපු, සිල්ක්, ලිනන්'
                        : 'Cotton, Silk, Linen',
                    leading: CustomIconWidget(
                      iconName: 'texture',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: () => _showToast(_currentLanguage == 'si'
                        ? 'රෙදිපිළි වර්ග සැකසීම'
                        : 'Fabric types configuration'),
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'වර්ණ පැලට් මනාපයන්'
                        : 'Color Palette Preferences',
                    subtitle: _currentLanguage == 'si'
                        ? 'උණුසුම් ටෝන්, ස්වභාවික වර්ණ'
                        : 'Warm tones, Natural colors',
                    leading: CustomIconWidget(
                      iconName: 'color_lens',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: () => _showToast(_currentLanguage == 'si'
                        ? 'වර්ණ මනාපයන් සැකසීම'
                        : 'Color preferences configuration'),
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'AI යෝජනා සංඛ්‍යාතය'
                        : 'AI Suggestion Frequency',
                    subtitle: _aiSuggestionFrequency == 'high'
                        ? (_currentLanguage == 'si' ? 'ඉහළ' : 'High')
                        : _aiSuggestionFrequency == 'medium'
                            ? (_currentLanguage == 'si' ? 'මධ්‍යම' : 'Medium')
                            : (_currentLanguage == 'si' ? 'අඩු' : 'Low'),
                    leading: CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: _showAISuggestionDialog,
                    showDivider: false,
                  ),
                ],
              ),

              // Notifications Section
              SettingsSectionWidget(
                title:
                    _currentLanguage == 'si' ? 'දැනුම්දීම්' : 'Notifications',
                children: [
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'නිර්මාණ සම්පූර්ණ කිරීම'
                        : 'Design Completion',
                    subtitle: _currentLanguage == 'si'
                        ? 'ඔබේ නිර්මාණ සම්පූර්ණ වූ විට දැනුම් දෙන්න'
                        : 'Notify when your designs are completed',
                    leading: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _designCompletionNotifications,
                      onChanged: (value) {
                        setState(() {
                          _designCompletionNotifications = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _designCompletionNotifications =
                            !_designCompletionNotifications;
                      });
                    },
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'බෙදාගැනීමේ ක්‍රියාකාරකම්'
                        : 'Sharing Activity',
                    subtitle: _currentLanguage == 'si'
                        ? 'ඔබේ නිර්මාණ බෙදාගන්නා විට දැනුම් දෙන්න'
                        : 'Notify about sharing activity',
                    leading: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _sharingActivityNotifications,
                      onChanged: (value) {
                        setState(() {
                          _sharingActivityNotifications = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _sharingActivityNotifications =
                            !_sharingActivityNotifications;
                      });
                    },
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'යෙදුම් යාවත්කාලීන'
                        : 'App Updates',
                    subtitle: _currentLanguage == 'si'
                        ? 'නව යාවත්කාලීන ගැන දැනුම් දෙන්න'
                        : 'Notify about new updates',
                    leading: CustomIconWidget(
                      iconName: 'system_update',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _appUpdateNotifications,
                      onChanged: (value) {
                        setState(() {
                          _appUpdateNotifications = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _appUpdateNotifications = !_appUpdateNotifications;
                      });
                    },
                    showDivider: false,
                  ),
                ],
              ),

              // Privacy Settings Section
              SettingsSectionWidget(
                title: _currentLanguage == 'si' ? 'පෞද්ගලිකත්වය' : 'Privacy',
                children: [
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'දත්ත බෙදාගැනීම'
                        : 'Data Sharing',
                    subtitle: _currentLanguage == 'si'
                        ? 'නිර්මාණ දත්ත බෙදාගැනීමට ඉඩ දෙන්න'
                        : 'Allow sharing design data for improvements',
                    leading: CustomIconWidget(
                      iconName: 'security',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _dataSharing,
                      onChanged: (value) {
                        setState(() {
                          _dataSharing = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _dataSharing = !_dataSharing;
                      });
                    },
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'විශ්ලේෂණ ඉවත්වීම'
                        : 'Analytics Opt-out',
                    subtitle: _currentLanguage == 'si'
                        ? 'විශ්ලේෂණ දත්ත එකතු කිරීමෙන් ඉවත්වන්න'
                        : 'Opt out of analytics data collection',
                    leading: CustomIconWidget(
                      iconName: 'analytics',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    trailing: Switch(
                      value: _analyticsOptOut,
                      onChanged: (value) {
                        setState(() {
                          _analyticsOptOut = value;
                        });
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _analyticsOptOut = !_analyticsOptOut;
                      });
                    },
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'ගිණුම මකන්න'
                        : 'Delete Account',
                    subtitle: _currentLanguage == 'si'
                        ? 'ඔබේ ගිණුම සහ සියලුම දත්ත ස්ථිරවම මකන්න'
                        : 'Permanently delete your account and all data',
                    leading: CustomIconWidget(
                      iconName: 'delete_forever',
                      color: AppTheme.alert,
                      size: 24,
                    ),
                    onTap: _showDeleteAccountDialog,
                    isDestructive: true,
                    showDivider: false,
                  ),
                ],
              ),

              // Storage Management Section
              SettingsSectionWidget(
                title: _currentLanguage == 'si'
                    ? 'ගබඩා කළමනාකරණය'
                    : 'Storage Management',
                children: [
                  StorageInfoWidget(
                    cacheSize: (_mockSettings[0]["cacheSize"] as String),
                    patternCount: (_mockSettings[0]["patternCount"] as int),
                    onClearCache: _showClearCacheDialog,
                  ),
                ],
              ),

              // Help & Support Section
              SettingsSectionWidget(
                title: _currentLanguage == 'si'
                    ? 'උදව් සහ සහාය'
                    : 'Help & Support',
                children: [
                  SettingsItemWidget(
                    title:
                        _currentLanguage == 'si' ? 'නිතර අසන ප්‍රශ්න' : 'FAQ',
                    subtitle: _currentLanguage == 'si'
                        ? 'සාමාන්‍ය ප්‍රශ්න සහ පිළිතුරු'
                        : 'Common questions and answers',
                    leading: CustomIconWidget(
                      iconName: 'help',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: () => _showToast(_currentLanguage == 'si'
                        ? 'FAQ විවෘත කරමින්...'
                        : 'Opening FAQ...'),
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'අප හා සම්බන්ධ වන්න'
                        : 'Contact Us',
                    subtitle: _currentLanguage == 'si'
                        ? 'සහාය සඳහා අප හා සම්බන්ධ වන්න'
                        : 'Get in touch for support',
                    leading: CustomIconWidget(
                      iconName: 'contact_support',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: () => _showToast(_currentLanguage == 'si'
                        ? 'සම්බන්ධතා පිටුව විවෘත කරමින්...'
                        : 'Opening contact page...'),
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'නිර්දේශන නැවත ධාවනය'
                        : 'Replay Tutorial',
                    subtitle: _currentLanguage == 'si'
                        ? 'යෙදුම් නිර්දේශන නැවත බලන්න'
                        : 'Watch app tutorials again',
                    leading: CustomIconWidget(
                      iconName: 'play_circle',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: () => _showToast(_currentLanguage == 'si'
                        ? 'නිර්දේශන ආරම්භ කරමින්...'
                        : 'Starting tutorial...'),
                    showDivider: false,
                  ),
                ],
              ),

              // About Section
              SettingsSectionWidget(
                title: _currentLanguage == 'si' ? 'පිළිබඳව' : 'About',
                children: [
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'යෙදුම් අනුවාදය'
                        : 'App Version',
                    subtitle:
                        '${_mockSettings[0]["appVersion"]} (${_mockSettings[0]["buildNumber"]})',
                    leading: CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    trailing: const SizedBox(),
                    onTap: null,
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'සේවා නියමයන්'
                        : 'Terms of Service',
                    leading: CustomIconWidget(
                      iconName: 'description',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: () => _showToast(_currentLanguage == 'si'
                        ? 'සේවා නියමයන් විවෘත කරමින්...'
                        : 'Opening terms of service...'),
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'පෞද්ගලිකත්ව ප්‍රතිපත්තිය'
                        : 'Privacy Policy',
                    leading: CustomIconWidget(
                      iconName: 'privacy_tip',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: () => _showToast(_currentLanguage == 'si'
                        ? 'පෞද්ගලිකත්ව ප්‍රතිපත්තිය විවෘත කරමින්...'
                        : 'Opening privacy policy...'),
                  ),
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'විවෘත මූලාශ්‍ර බලපත්‍ර'
                        : 'Open Source Licenses',
                    leading: CustomIconWidget(
                      iconName: 'code',
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    onTap: () => _showToast(_currentLanguage == 'si'
                        ? 'බලපත්‍ර විවෘත කරමින්...'
                        : 'Opening licenses...'),
                    showDivider: false,
                  ),
                ],
              ),

              // Reset to Defaults Section
              SettingsSectionWidget(
                title: _currentLanguage == 'si' ? 'යළි පිහිටුවීම' : 'Reset',
                children: [
                  SettingsItemWidget(
                    title: _currentLanguage == 'si'
                        ? 'පෙරනිමි වලට යළි පිහිටුවන්න'
                        : 'Reset to Defaults',
                    subtitle: _currentLanguage == 'si'
                        ? 'සියලුම සැකසුම් පෙරනිමි වලට යළි පිහිටුවන්න'
                        : 'Reset all settings to default values',
                    leading: CustomIconWidget(
                      iconName: 'restore',
                      color: AppTheme.alert,
                      size: 24,
                    ),
                    onTap: _showResetDialog,
                    isDestructive: true,
                    showDivider: false,
                  ),
                ],
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLanguageChange(String language) {
    setState(() {
      _currentLanguage = language;
    });
    _showToast(_currentLanguage == 'si'
        ? 'භාෂාව වෙනස් කරන ලදී'
        : 'Language changed successfully');
  }

  void _handleThemeChange(String theme) {
    setState(() {
      _currentTheme = theme;
    });
    _showToast(_currentLanguage == 'si'
        ? 'තේමාව වෙනස් කරන ලදී'
        : 'Theme changed successfully');
  }

  void _showMeasurementUnitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _currentLanguage == 'si'
                ? 'මිනුම් ඒකක තෝරන්න'
                : 'Select Measurement Unit',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(_currentLanguage == 'si'
                    ? 'මෙට්‍රික් (සෙ.මී., කි.ග්‍රෑ.)'
                    : 'Metric (cm, kg)'),
                value: 'metric',
                groupValue: _measurementUnit,
                onChanged: (value) {
                  setState(() {
                    _measurementUnit = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text(_currentLanguage == 'si'
                    ? 'ඉම්පීරියල් (අඟල්, පවුම්)'
                    : 'Imperial (inches, lbs)'),
                value: 'imperial',
                groupValue: _measurementUnit,
                onChanged: (value) {
                  setState(() {
                    _measurementUnit = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAISuggestionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _currentLanguage == 'si'
                ? 'AI යෝජනා සංඛ්‍යාතය'
                : 'AI Suggestion Frequency',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(_currentLanguage == 'si' ? 'ඉහළ' : 'High'),
                subtitle: Text(_currentLanguage == 'si'
                    ? 'නිතර යෝජනා'
                    : 'Frequent suggestions'),
                value: 'high',
                groupValue: _aiSuggestionFrequency,
                onChanged: (value) {
                  setState(() {
                    _aiSuggestionFrequency = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text(_currentLanguage == 'si' ? 'මධ්‍යම' : 'Medium'),
                subtitle: Text(_currentLanguage == 'si'
                    ? 'සමතුලිත යෝජනා'
                    : 'Balanced suggestions'),
                value: 'medium',
                groupValue: _aiSuggestionFrequency,
                onChanged: (value) {
                  setState(() {
                    _aiSuggestionFrequency = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text(_currentLanguage == 'si' ? 'අඩු' : 'Low'),
                subtitle: Text(_currentLanguage == 'si'
                    ? 'අවම යෝජනා'
                    : 'Minimal suggestions'),
                value: 'low',
                groupValue: _aiSuggestionFrequency,
                onChanged: (value) {
                  setState(() {
                    _aiSuggestionFrequency = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _currentLanguage == 'si' ? 'කැෂ් මකන්න' : 'Clear Cache',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Text(
            _currentLanguage == 'si'
                ? 'ඔබට කැෂ් දත්ත මකා දැමීමට අවශ්‍යද? මෙය ආපසු හැරවිය නොහැක.'
                : 'Are you sure you want to clear cache data? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                _currentLanguage == 'si' ? 'අවලංගු කරන්න' : 'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showToast(_currentLanguage == 'si'
                    ? 'කැෂ් මකා දමන ලදී'
                    : 'Cache cleared successfully');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.alert,
                foregroundColor: AppTheme.surface,
              ),
              child: Text(_currentLanguage == 'si' ? 'මකන්න' : 'Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _currentLanguage == 'si' ? 'ගිණුම මකන්න' : 'Delete Account',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.alert,
            ),
          ),
          content: Text(
            _currentLanguage == 'si'
                ? 'ඔබට ඔබේ ගිණුම ස්ථිරවම මකා දැමීමට අවශ්‍යද? මෙය ආපසු හැරවිය නොහැකි ක්‍රියාවකි සහ ඔබේ සියලුම දත්ත මකා දමනු ලැබේ.'
                : 'Are you sure you want to permanently delete your account? This is an irreversible action and all your data will be deleted.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                _currentLanguage == 'si' ? 'අවලංගු කරන්න' : 'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showToast(_currentLanguage == 'si'
                    ? 'ගිණුම මකා දැමීමේ ක්‍රියාවලිය ආරම්භ කරන ලදී'
                    : 'Account deletion process initiated');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.alert,
                foregroundColor: AppTheme.surface,
              ),
              child: Text(_currentLanguage == 'si' ? 'මකන්න' : 'Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _currentLanguage == 'si'
                ? 'පෙරනිමි වලට යළි පිහිටුවන්න'
                : 'Reset to Defaults',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.alert,
            ),
          ),
          content: Text(
            _currentLanguage == 'si'
                ? 'ඔබට සියලුම සැකසුම් පෙරනිමි වලට යළි පිහිටුවීමට අවශ්‍යද? මෙය ඔබේ සියලුම කස්ටම් සැකසුම් මකා දමනු ලැබේ.'
                : 'Are you sure you want to reset all settings to defaults? This will remove all your custom configurations.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                _currentLanguage == 'si' ? 'අවලංගු කරන්න' : 'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetToDefaults();
                _showToast(_currentLanguage == 'si'
                    ? 'සැකසුම් පෙරනිමි වලට යළි පිහිටුවන ලදී'
                    : 'Settings reset to defaults');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.alert,
                foregroundColor: AppTheme.surface,
              ),
              child:
                  Text(_currentLanguage == 'si' ? 'යළි පිහිටුවන්න' : 'Reset'),
            ),
          ],
        );
      },
    );
  }

  void _resetToDefaults() {
    setState(() {
      _currentLanguage = 'en';
      _currentTheme = 'light';
      _measurementUnit = 'metric';
      _designCompletionNotifications = true;
      _sharingActivityNotifications = false;
      _appUpdateNotifications = true;
      _dataSharing = false;
      _analyticsOptOut = true;
      _aiSuggestionFrequency = 'medium';
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.textPrimary.withValues(alpha: 0.9),
      textColor: AppTheme.surface,
      fontSize: 14.0,
    );
  }
}
