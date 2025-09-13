import 'package:flutter/material.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/settings/settings.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/pattern_preview/pattern_preview.dart';
import '../presentation/pattern_library/pattern_library.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/design_customization/design_customization.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash';
  static const String settings = '/settings';
  static const String homeDashboard = '/home-dashboard';
  static const String patternPreview = '/pattern-preview';
  static const String patternLibrary = '/pattern-library';
  static const String userProfile = '/user-profile';
  static const String designCustomization = '/design-customization';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    settings: (context) => const Settings(),
    homeDashboard: (context) => const HomeDashboard(),
    patternPreview: (context) => const PatternPreview(),
    patternLibrary: (context) => const PatternLibrary(),
    userProfile: (context) => const UserProfile(),
    designCustomization: (context) => const DesignCustomization(),
    // TODO: Add your other routes here
  };
}
