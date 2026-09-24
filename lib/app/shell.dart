import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../services/active_season_store.dart';
import '../services/entitlements.dart';
import 'app_scope.dart';
import 'routing.dart';
import 'theme.dart';

/// Root shell: app bar + bottom nav for Map | Cameras | Season | Alerts.
class CamfrontShell extends StatefulWidget {
  const CamfrontShell({super.key});

  @override
  State<CamfrontShell> createState() => _CamfrontShellState();
}

class _CamfrontShellState extends State<CamfrontShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);
    final store = deps.seasonStore;
    final entitlements = deps.entitlements;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final phase = store.phase;
        final plan = entitlements.plan;
        final days = entitlements.forecastDays;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Camfront'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Chip(
                  label: Text(
                    '${plan.name} · ${days}d',
                    style: const TextStyle(fontSize: 12),
                  ),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          body: IndexedStack(
            index: _index,
            children: [
              for (final tab in CamfrontTab.values) tab.page,
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              for (final tab in CamfrontTab.values)
                NavigationDestination(
                  icon: Icon(tab.icon),
                  label: tab.label,
                ),
            ],
          ),
        );
      },
    );
  }
}
