import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/enums.dart';

/// Sample trail-cam card for the cameras shell (fixture labels only).
class SampleCameraCard {
  const SampleCameraCard({
    required this.id,
    required this.brand,
    required this.label,
    required this.seasonPhase,
    this.eventCount = 0,
  });

  final String id;
  final String brand; // moultrie | tactacam
  final String label;
  final SeasonPhase seasonPhase;
  final int eventCount;
}

/// Demo cards derived from fixture folder labels (not live cameras).
List<SampleCameraCard> sampleCameraCards() => const [
      SampleCameraCard(
        id: 'moultrie-cam_north',
        brand: 'moultrie',
        label: 'cam_north',
        seasonPhase: SeasonPhase.preRut,
        eventCount: 3,
      ),
      SampleCameraCard(
        id: 'tactacam-Kingstarnes1',
        brand: 'tactacam',
        label: 'Kingstarnes1',
        seasonPhase: SeasonPhase.preRut,
        eventCount: 5,
      ),
      SampleCameraCard(
        id: 'tactacam-KingStarnes2',
        brand: 'tactacam',
        label: 'KingStarnes2',
        seasonPhase: SeasonPhase.earlySeason,
        eventCount: 2,
      ),
      SampleCameraCard(
        id: 'moultrie-cam_north-peak',
        brand: 'moultrie',
        label: 'cam_north',
        seasonPhase: SeasonPhase.peakRut,
        eventCount: 1,
      ),
    ];

/// Cameras shell — grid of sample trail-cam cards with optional season filter.
class CamerasPage extends StatefulWidget {
  const CamerasPage({super.key});

  @override
  State<CamerasPage> createState() => _CamerasPageState();
}

class _CamerasPageState extends State<CamerasPage> {
  SeasonPhase? _filter; // null = all

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context).activeSeasonStore;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final cards = sampleCameraCards().where((c) {
          if (_filter == null) return true;
          return c.seasonPhase == _filter;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Row(
                children: [
                  Text(
                    'Season: ${store.phase.exportName}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  Text(
                    'filter cards',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('all'),
                    selected: _filter == null,
                    onSelected: (_) => setState(() => _filter = null),
                  ),
                  const SizedBox(width: 6),
                  for (final p in SeasonPhase.values) ...[
                    FilterChip(
                      label: Text(p.exportName),
                      selected: _filter == p,
                      onSelected: (_) => setState(() => _filter = p),
                    ),
                    const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: cards.isEmpty
                  ? const Center(child: Text('No cameras for this season'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.15,
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, i) =>
                          _CameraCardWidget(card: cards[i]),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _CameraCardWidget extends StatelessWidget {
  const _CameraCardWidget({required this.card});

  final SampleCameraCard card;

  @override
  Widget build(BuildContext context) {
    final brandColor = card.brand == 'moultrie'
        ? const Color(0xFF66BB6A)
        : const Color(0xFFFFA726);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_camera, color: brandColor, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    card.label,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              card.brand,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: brandColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              '${card.seasonPhase.exportName} · ${card.eventCount} events',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
