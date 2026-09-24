import 'camera_adapter.dart';
import 'brands/moultrie/moultrie_adapter.dart';
import 'brands/tactacam/tactacam_adapter.dart';

/// Factory registry so the app can select a brand adapter without secrets.
///
/// v1 registers [MoultrieAdapter] and [TactacamAdapter]. Callers pass
/// [CameraCredentials] at connect time — nothing sensitive is stored here.
class CameraAdapterRegistry {
  CameraAdapterRegistry({
    Map<String, CameraAdapter Function()>? factories,
  }) : _factories = Map<String, CameraAdapter Function()>.of(
          factories ?? const {},
        );

  final Map<String, CameraAdapter Function()> _factories;

  /// Default product registry: Moultrie + Tactacam.
  factory CameraAdapterRegistry.defaults() {
    return CameraAdapterRegistry(
      factories: {
        MoultrieAdapter.brandIdValue: MoultrieAdapter.new,
        TactacamAdapter.brandIdValue: TactacamAdapter.new,
      },
    );
  }

  Iterable<String> get registeredBrandIds => _factories.keys;

  bool isRegistered(String brandId) => _factories.containsKey(brandId);

  void register(String brandId, CameraAdapter Function() factory) {
    _factories[brandId] = factory;
  }

  /// Creates a fresh adapter instance for [brandId], or `null` if unknown.
  CameraAdapter? create(String brandId) {
    final factory = _factories[brandId];
    return factory?.call();
  }

  /// Like [create] but throws if the brand is not registered.
  CameraAdapter require(String brandId) {
    final adapter = create(brandId);
    if (adapter == null) {
      throw StateError('No camera adapter registered for brandId "$brandId"');
    }
    return adapter;
  }
}
