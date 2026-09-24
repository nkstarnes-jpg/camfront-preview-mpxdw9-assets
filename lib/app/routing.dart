import 'package:flutter/material.dart';

import 'shell.dart';

/// Named routes for Camfront shells.
class AppRouter {
  AppRouter._();

  static const String home = '/';
  static const String map = '/map';
  static const String cameras = '/cameras';
  static const String pins = '/pins';
  static const String entitlements = '/entitlements';
  static const String season = '/season';
  static const String alerts = '/alerts';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name;
    switch (name) {
      case home:
      case map:
      case cameras:
      case season:
      case alerts:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => CamfrontShell(
            initialIndex: CamfrontShell.indexForRoute(name),
          ),
        );
      case pins:
      case entitlements:
        // Kept as constants; shells not built yet — land on home shell.
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CamfrontShell(),
        );
      default:
        return null;
    }
  }
}
