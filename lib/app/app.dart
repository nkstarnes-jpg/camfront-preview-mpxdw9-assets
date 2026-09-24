import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'di.dart';
import 'routing.dart';
import 'shell.dart';
import 'theme.dart';

/// Root widget / bootstrap.
class HuntingApp extends StatelessWidget {
  const HuntingApp({super.key, this.dependencies});

  final AppDependencies? dependencies;

  @override
  Widget build(BuildContext context) {
    final deps = dependencies ?? AppDependencies.defaults();
    return AppScope(
      dependencies: deps,
      child: MaterialApp(
        title: 'Camfront',
        theme: CamfrontTheme.dark(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const CamfrontShell(),
      ),
    );
  }
}
