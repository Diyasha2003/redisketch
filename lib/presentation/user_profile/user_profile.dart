import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/measurement_edit_modal.dart';
import './widgets/measurement_sets_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isDarkMode = false;
  bool _isEnglish = true;
  bool _notificationsEnabled = true;
  String? _profileImageUrl;
  String _defaultMeasurementSetId = '1';

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Amara Perera",
    "email": "amara.perera@email.com",
    "memberSince": "January 2023",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    "appVersion": "1.2.0",
  };

  List<MeasurementSet> _measurementSets = [
    MeasurementSet(
      id: '1',
      name: 'Default Measurements',
      createdDate: '15 Dec 2024',
      measurements: {
        'chest': 92.0,
        'waist': 78.0,
        'hips': 98.0,
        'shoulder': 46.0,
        'sleeve': 72.0,
        'length': 85.0,
        'neck': 38.0,
        'inseam': 82.0,
      },
    ),
    MeasurementSet(
      id: '2',
      name: 'Formal Wear',
      createdDate: '10 Dec 2024',
      measurements: {
        'chest': 90.0,
        'waist': 76.0,
        'hips': 96.0,
        'shoulder': 45.0,
        'sleeve': 70.0,
        'length': 88.0,
        'neck': 37.0,
        'inseam': 80.0,
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _profileImageUrl = _userData["profileImage"] as String?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshProfile,
          color: AppTheme.accent,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Profile Header
                ProfileHeaderWidget(
                  userName: _userData["name"] as String,
                  memberSince: _userData["memberSince"] as String,
                  profileImageUrl: _profileImageUrl,
                  onEditProfile: _editProfilePicture,
                ),

                SizedBox(height: 2.h),

                // Account Section
                SettingsSectionWidget(
                  title: 'Account',
                  items: [
                    SettingsItem(
                      title: 'Personal Information',
                      subtitle: 'Name, email, and contact details',
                      iconName: 'person_outline',
                      onTap: () => _showPersonalInfoDialog(),
                    ),
                    SettingsItem(
                      title: 'Email Address',
                      subtitle: _userData["email"] as String,
                      iconName: 'email',
                      onTap: () => _showEmailChangeDialog(),
                    ),
                    SettingsItem(
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      iconName: 'lock_outline',
                      onTap: () => _showPasswordChangeDialog(),
                    ),
                  ],
                ),

                // Measurement Sets
                MeasurementSetsWidget(
                  measurementSets: _measurementSets,
                  defaultSetId: _defaultMeasurementSetId,
                  onSetDefault: _setDefaultMeasurementSet,
                  onEditSet: _editMeasurementSet,
                  onDeleteSet: _deleteMeasurementSet,
                  onAddNew: _addNewMeasurementSet,
                ),

                // Preferences Section
                SettingsSectionWidget(
                  title: 'Preferences',
                  items: [
                    SettingsItem(
                      title: 'Language',
                      subtitle: _isEnglish ? 'English' : 'සිංහල',
                      iconName: 'language',
                      hasDisclosure: false,
                      trailing: Switch(
                        value: _isEnglish,
                        onChanged: _toggleLanguage,
                        activeColor: AppTheme.accent,
                      ),
                    ),
                    SettingsItem(
                      title: 'Theme',
                      subtitle: _isDarkMode ? 'Dark Mode' : 'Light Mode',
                      iconName: _isDarkMode ? 'dark_mode' : 'light_mode',
                      hasDisclosure: false,
                      trailing: Switch(
                        value: _isDarkMode,
                        onChanged: _toggleTheme,
                        activeColor: AppTheme.accent,
                      ),
                    ),
                    SettingsItem(
                      title: 'Notifications',
                      subtitle: 'Push notifications and alerts',
                      iconName: 'notifications_outlined',
                      hasDisclosure: false,
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: _toggleNotifications,
                        activeColor: AppTheme.accent,
                      ),
                    ),
                  ],
                ),

                // App Information Section
                SettingsSectionWidget(
                  title: 'App Information',
                  items: [
                    SettingsItem(
                      title: 'App Version',
                      subtitle: 'Version ${_userData["appVersion"]}',
                      iconName: 'info_outline',
                      hasDisclosure: false,
                    ),
                    SettingsItem(
                      title: 'Help & Documentation',
                      subtitle: 'User guides and tutorials',
                      iconName: 'help_outline',
                      onTap: () => _showHelpDialog(),
                    ),
                    SettingsItem(
                      title: 'Send Feedback',
                      subtitle: 'Share your thoughts with us',
                      iconName: 'feedback',
                      onTap: () => _showFeedbackDialog(),
                    ),
                    SettingsItem(
                      title: 'Export Data',
                      subtitle: 'Download your designs and measurements',
                      iconName: 'download',
                      onTap: () => _exportUserData(),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _showLogoutDialog,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.alert,
                      side: BorderSide(color: AppTheme.alert),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'logout',
                          color: AppTheme.alert,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Logout',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.alert,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        // Refresh profile data
      });
    }
  }

  Future<void> _editProfilePicture() async {
    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      final storageStatus = await Permission.storage.request();

      if (!cameraStatus.isGranted && !storageStatus.isGranted) {
        _showPermissionDialog();
        return;
      }

      final result = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildImageSourceBottomSheet(),
      );

      if (result != null) {
        final XFile? image = await _imagePicker.pickImage(
          source: result,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 80,
        );

        if (image != null) {
          final croppedFile = await ImageCropper().cropImage(
            sourcePath: image.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Crop Profile Picture',
                toolbarColor: AppTheme.lightTheme.colorScheme.primary,
                toolbarWidgetColor: AppTheme.lightTheme.colorScheme.surface,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true,
              ),
              IOSUiSettings(
                title: 'Crop Profile Picture',
                aspectRatioLockEnabled: true,
                resetAspectRatioEnabled: false,
              ),
            ],
          );

          if (croppedFile != null) {
            setState(() {
              _profileImageUrl = croppedFile.path;
            });
          }
        }
      }
    } catch (e) {
      _showErrorDialog('Failed to update profile picture. Please try again.');
    }
  }

  Widget _buildImageSourceBottomSheet() {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Select Photo Source',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            title: Text('Camera'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: CustomIconWidget(
              iconName: 'photo_library',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            title: Text('Gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _toggleLanguage(bool value) {
    setState(() {
      _isEnglish = value;
    });
    // Implement language switching logic
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    // Implement theme switching logic
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    // Implement notification settings logic
  }

  void _setDefaultMeasurementSet(String setId) {
    setState(() {
      _defaultMeasurementSetId = setId;
    });
  }

  void _editMeasurementSet(String setId) {
    final set = _measurementSets.firstWhere((s) => s.id == setId);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MeasurementEditModal(
        setName: set.name,
        initialMeasurements: set.measurements,
        onSave: (name, measurements) {
          setState(() {
            final index = _measurementSets.indexWhere((s) => s.id == setId);
            if (index != -1) {
              _measurementSets[index] = MeasurementSet(
                id: setId,
                name: name,
                createdDate: set.createdDate,
                measurements: measurements,
              );
            }
          });
        },
      ),
    );
  }

  void _deleteMeasurementSet(String setId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Measurement Set'),
        content: Text(
            'Are you sure you want to delete this measurement set? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _measurementSets.removeWhere((s) => s.id == setId);
                if (_defaultMeasurementSetId == setId &&
                    _measurementSets.isNotEmpty) {
                  _defaultMeasurementSetId = _measurementSets.first.id;
                }
              });
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.alert),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewMeasurementSet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MeasurementEditModal(
        onSave: (name, measurements) {
          setState(() {
            final newId = DateTime.now().millisecondsSinceEpoch.toString();
            _measurementSets.add(
              MeasurementSet(
                id: newId,
                name: name,
                createdDate: '05 Sep 2025',
                measurements: measurements,
              ),
            );
          });
        },
      ),
    );
  }

  void _showPersonalInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Personal Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_userData["name"]}'),
            SizedBox(height: 1.h),
            Text('Email: ${_userData["email"]}'),
            SizedBox(height: 1.h),
            Text('Member Since: ${_userData["memberSince"]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEmailChangeDialog() {
    final emailController =
        TextEditingController(text: _userData["email"] as String);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Email'),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter new email address',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement email change logic
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement password change logic
              Navigator.pop(context);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & Documentation'),
        content: Text(
            'Access user guides, tutorials, and frequently asked questions to get the most out of RediSketch.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    final feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Feedback'),
        content: TextField(
          controller: feedbackController,
          decoration: InputDecoration(
            hintText: 'Share your thoughts, suggestions, or report issues...',
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement feedback submission logic
              Navigator.pop(context);
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void _exportUserData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Data'),
        content: Text(
            'Your designs, measurements, and preferences will be exported as a downloadable file.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement data export logic
              Navigator.pop(context);
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text(
            'Are you sure you want to logout? You will need to sign in again to access your account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppTheme.alert),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            'Camera and storage permissions are required to update your profile picture.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
