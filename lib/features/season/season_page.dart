import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/enums.dart';

/// Season shell — hunter-set phase picker + Save via ActiveSeasonStore.
class SeasonPage extends StatefulWidget {
  const SeasonPage({super.key});

  @override
  State<SeasonPage> createState() => _SeasonPageState();
}

class _SeasonPageState extends State<SeasonPage> {
  SeasonPhase? _draft;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context).activeSeasonStore;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final selected = _draft ?? store.phase;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Active season',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'You set the season. Cameras and pins stamp this value at '
              'create time — it is not inferred from photos or dates.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 20),
            for (final phase in SeasonPhase.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: selected == phase
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  selected: selected == phase,
                  selectedTileColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.15),
                  leading: Icon(
                    selected == phase
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: selected == phase
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text(_label(phase)),
                  subtitle: Text(phase.exportName),
                  onTap: () => setState(() => _draft = phase),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      setState(() => _saving = true);
                      store.setPhase(selected);
                      await store.save();
                      if (!mounted) return;
                      setState(() {
                        _draft = null;
                        _saving = false;
                      });
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Saved season: ${selected.exportName}',
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving…' : 'Save season'),
            ),
          ],
        );
      },
    );
  }

  String _label(SeasonPhase p) => switch (p) {
        SeasonPhase.earlySeason => 'Early season',
        SeasonPhase.preRut => 'Pre-rut',
        SeasonPhase.peakRut => 'Peak rut',
        SeasonPhase.lateSeason => 'Late season',
      };
}
