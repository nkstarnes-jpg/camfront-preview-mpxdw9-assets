/// Abstract parcel / ownership lookup. v1: all plans gated off ([Entitlements.parcelData]).
/// Implementations must not invent owner names or private parcel polygons for UI.
abstract class ParcelProvider {
  /// Returns parcel metadata for a point, or null if unavailable / unsupported.
  Future<ParcelLookupResult?> lookup({
    required double latitude,
    required double longitude,
  });
}

/// Minimal parcel result stub — intentionally no owner name field in v1 API surface.
class ParcelLookupResult {
  const ParcelLookupResult({
    this.parcelId,
    this.label,
  });

  final String? parcelId;
  final String? label;
}

/// No-op provider: always returns null. Safe default until a real source exists.
class NoopParcelProvider implements ParcelProvider {
  const NoopParcelProvider();

  @override
  Future<ParcelLookupResult?> lookup({
    required double latitude,
    required double longitude,
  }) async =>
      null;
}
