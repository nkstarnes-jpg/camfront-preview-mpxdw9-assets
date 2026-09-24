import '../core/enums.dart';
import '../data/adapters/cameras/camera_adapter_registry.dart';
import '../data/adapters/maps/parcel_provider.dart';
import '../services/active_season_store.dart';
import '../services/entitlements.dart';
import '../services/iap_placeholder.dart';
import '../services/ingest/camera_event_ingest.dart';
import '../services/ingest/pin_ingest.dart';
import '../services/sign_reader_mapper.dart';
import '../services/trial_service.dart';

/// Lightweight DI placeholder (no Riverpod/GetIt required for scaffold).
class AppDependencies {
  AppDependencies({
    required this.entitlements,
    required this.parcelProvider,
    required this.trialService,
    required this.iap,
    required this.activeSeasonStore,
    required this.cameraEventIngest,
    required this.pinIngest,
    required this.cameraAdapters,
    this.signReaderMapper = const SignReaderMapper(),
  });

  final Entitlements entitlements;
  final ParcelProvider parcelProvider;
  final TrialService trialService;
  final IapPlaceholder iap;
  final ActiveSeasonStore activeSeasonStore;
  final CameraEventIngestService cameraEventIngest;
  final PinIngestService pinIngest;
  final CameraAdapterRegistry cameraAdapters;
  final SignReaderMapper signReaderMapper;

  factory AppDependencies.defaults({
    Plan plan = Plan.scout,
    bool trialActive = false,
    SeasonPhase initialSeason = SeasonPhase.preRut,
  }) {
    final seasonStore = ActiveSeasonStore(initialPhase: initialSeason);
    return AppDependencies(
      entitlements: Entitlements(plan: plan, trialActive: trialActive),
      parcelProvider: const NoopParcelProvider(),
      trialService: const TrialService(),
      iap: const IapPlaceholder(),
      activeSeasonStore: seasonStore,
      cameraEventIngest: CameraEventIngestService(seasonStore),
      pinIngest: PinIngestService(seasonStore),
      cameraAdapters: CameraAdapterRegistry.defaults(),
    );
  }
}
