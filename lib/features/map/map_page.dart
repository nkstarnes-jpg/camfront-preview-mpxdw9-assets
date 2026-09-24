import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/enums.dart';
import 'map_constants.dart';
import 'topo_painter.dart';

/// Map shell — topo canvas, sample camera/pin markers, season badge.
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context).activeSeasonStore;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return Column(
          children: [
            _SeasonBadgeBar(phase: store.phase),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(
                    painter: const TopoPainter(publicLandTint: true),
                    child: const SizedBox.expand(),
                  ),
                  ..._sampleMarkers(context),
                  const Positioned(
                    left: 8,
                    right: 8,
                    bottom: 8,
                    child: _DisclaimerBanner(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _sampleMarkers(BuildContext context) {
    const cameras = <_MapMarkerSpec>[
      _MapMarkerSpec(dx: 0.32, dy: 0.38, kind: _MarkerKind.camera, label: 'cam_north'),
      _MapMarkerSpec(dx: 0.62, dy: 0.55, kind: _MarkerKind.camera, label: 'Kingstarnes1'),
      _MapMarkerSpec(dx: 0.72, dy: 0.28, kind: _MarkerKind.camera, label: 'KingStarnes2'),
    ];
    const pins = <_MapMarkerSpec>[
      _MapMarkerSpec(dx: 0.45, dy: 0.48, kind: _MarkerKind.pin, label: 'stand', pinType: PinType.stand),
      _MapMarkerSpec(dx: 0.55, dy: 0.62, kind: _MarkerKind.pin, label: 'blind', pinType: PinType.blind),
      _MapMarkerSpec(dx: 0.38, dy: 0.58, kind: _MarkerKind.pin, label: 'rub', pinType: PinType.rub),
      _MapMarkerSpec(dx: 0.68, dy: 0.42, kind: _MarkerKind.pin, label: 'scrape', pinType: PinType.scrape),
    ];
    return [
      for (final m in [...cameras, ...pins])
        Align(
          alignment: Alignment(m.dx * 2 - 1, m.dy * 2 - 1),
          child: _MapMarker(spec: m),
        ),
    ];
  }
}

class _SeasonBadgeBar extends StatelessWidget {
  const _SeasonBadgeBar({required this.phase});
  final SeasonPhase phase;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.eco, size: 18, color: scheme.primary),
            const SizedBox(width: 8),
            Text('Season: ${phase.exportName}', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            Text('topo · public land', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}

class _DisclaimerBanner extends StatelessWidget {
  const _DisclaimerBanner();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(MapFeatureConstants.firstUseDisclaimer, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70, fontSize: 11, height: 1.3)),
      ),
    );
  }
}

enum _MarkerKind { camera, pin }

class _MapMarkerSpec {
  const _MapMarkerSpec({required this.dx, required this.dy, required this.kind, required this.label, this.pinType});
  final double dx;
  final double dy;
  final _MarkerKind kind;
  final String label;
  final PinType? pinType;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.spec});
  final _MapMarkerSpec spec;
  @override
  Widget build(BuildContext context) {
    final isCam = spec.kind == _MarkerKind.camera;
    final color = isCam ? const Color(0xFFFFB74D) : const Color(0xFF81C784);
    final icon = isCam ? Icons.photo_camera : _pinIcon(spec.pinType);
    return Tooltip(
      message: spec.label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22, shadows: const [Shadow(blurRadius: 4, color: Colors.black54)]),
          Text(spec.label, style: const TextStyle(fontSize: 9, color: Colors.white70, shadows: [Shadow(blurRadius: 2, color: Colors.black)])),
        ],
      ),
    );
  }

  IconData _pinIcon(PinType? t) {
    return switch (t) {
      PinType.stand => Icons.airline_seat_recline_extra,
      PinType.blind => Icons.home_work_outlined,
      PinType.rub => Icons.forest,
      PinType.scrape => Icons.landscape,
      _ => Icons.place,
    };
  }
}
