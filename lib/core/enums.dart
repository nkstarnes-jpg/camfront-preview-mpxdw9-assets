/// Active deer-season phase set by the hunter (not inferred).
enum SeasonPhase {
  earlySeason,
  preRut,
  peakRut,
  lateSeason;

  /// Wire / Sign Reader export name (`early_season`, …).
  String get exportName => switch (this) {
        SeasonPhase.earlySeason => 'early_season',
        SeasonPhase.preRut => 'pre_rut',
        SeasonPhase.peakRut => 'peak_rut',
        SeasonPhase.lateSeason => 'late_season',
      };

  static SeasonPhase? tryParseExport(String raw) {
    switch (raw) {
      case 'early_season':
        return SeasonPhase.earlySeason;
      case 'pre_rut':
        return SeasonPhase.preRut;
      case 'peak_rut':
        return SeasonPhase.peakRut;
      case 'late_season':
        return SeasonPhase.lateSeason;
      default:
        return null;
    }
  }
}

/// Hunter-placed sign / structure pin kinds.
enum PinType {
  blind,
  stand,
  tracks,
  stride,
  rub,
  scrape,
  bedding,
  scat,
  pinchPoint,
  funnel;

  /// Structure pins editable on Scout; all others are sign / label types.
  bool get isStructurePin =>
      this == PinType.blind || this == PinType.stand;

  /// Sign / hunter-label types (includes pinch_point / funnel — not analytics).
  bool get isSignPin => !isStructurePin;

  String get exportName => switch (this) {
        PinType.blind => 'blind',
        PinType.stand => 'stand',
        PinType.tracks => 'tracks',
        PinType.stride => 'stride',
        PinType.rub => 'rub',
        PinType.scrape => 'scrape',
        PinType.bedding => 'bedding',
        PinType.scat => 'scat',
        PinType.pinchPoint => 'pinch_point',
        PinType.funnel => 'funnel',
      };
}

/// Paid plan tier. Trial is an overlay on Sanctuary-level access — not a Plan.
enum Plan {
  scout,
  stand,
  sanctuary,
}
