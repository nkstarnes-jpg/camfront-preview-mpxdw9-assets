/// Map feature defaults and first-use copy.
///
/// Defaults: topo **on**, satellite **off**, public land **on**.
/// Location: only while map is open or during mark-this-spot — **no background GPS**.
class MapFeatureConstants {
  MapFeatureConstants._();

  static const bool defaultTopoOn = true;
  static const bool defaultSatelliteOn = false;
  static const bool defaultPublicLandOn = true;

  /// Location is session-scoped to map / mark-this-spot only.
  static const bool backgroundGpsAllowed = false;

  /// First-use disclaimer (approximate location; not a permission prompt;
  /// not a survey / legal boundary statement).
  static const String firstUseDisclaimer =
      'Map locations are approximate. This is not a land survey, property '
      'boundary, or legal description. Always verify access and boundaries '
      'on the ground and with local rules before hunting.';

  static const String locationWhileOpenNote =
      'Your location is used only while the map is open or when you mark a '
      'spot. Background GPS is not used.';
}
