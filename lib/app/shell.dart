import 'package:flutter/material.dart';

import '../features/alerts/alerts_page.dart';
import '../features/cameras/cameras_page.dart';
import '../features/map/map_page.dart';
import '../features/season/season_page.dart';
import 'app_scope.dart';
import 'di.dart';
import 'routing.dart';

/// Bottom-nav shell: Map | Cameras | Season | Alerts.
class CamfrontShell extends StatefulWidget {
  const CamfrontShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  static int indexForRoute(String? name) {
    switch (name) {
      case AppRouter.map:
      case AppRouter.home:
      case null:
        return 0;
      case AppRouter.cameras:
        return 1;
      case AppRouter.season:
        return 2;
      case AppRouter.alerts:
        return 3;
      default:
        return 0;
    }
  }

  @override
  State<CamfrontShell> createState() => _CamfrontShellState();
}

class _CamfrontShellState extends State<CamfrontShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camfront'),
        actions: [
          _PlanChip(dependencies: deps),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          MapPage(),
          CamerasPage(),
          SeasonPage(),
          AlertsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera_outlined),
            activeIcon: Icon(Icons.photo_camera),
            label: 'Cameras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.eco_outlined),
            activeIcon: Icon(Icons.eco),
            label: 'Season',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}

class _PlanChip extends StatelessWidget {
  const _PlanChip({required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final e = dependencies.entitlements;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Chip(
          visualDensity: VisualDensity.compact,
          label: Text(
            '${e.plan.name} · ${e.forecastDays}d',
            style: const TextStyle(fontSize: 12),
          ),
          avatar: const Icon(Icons.workspace_premium_outlined, size: 16),
        ),
      ),
    );
  }
}
