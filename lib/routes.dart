import 'package:flutter/material.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/device/device_detail_screen.dart';
import 'screens/device/add_device_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'models/device.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String auth = '/auth';
  static const String dashboard = '/dashboard';
  static const String deviceDetail = '/device-detail';
  static const String addDevice = '/add-device';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case deviceDetail:
        final device = settings.arguments as Device;
        return MaterialPageRoute(
          builder: (_) => DeviceDetailScreen(device: device),
        );
      case addDevice:
        return MaterialPageRoute(builder: (_) => const AddDeviceScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 