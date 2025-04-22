import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Map<String, dynamic>? arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateToReplacement(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void goBack({dynamic result}) {
    navigatorKey.currentState!.pop(result);
  }

  static void goBackTo(String routeName) {
    navigatorKey.currentState!.popUntil((route) => route.settings.name == routeName);
  }
} 