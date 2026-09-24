/// Opaque credentials for a trail-camera brand connection.
/// Brand-specific fields live in maps until brand adapters are named.
class CameraCredentials {
  const CameraCredentials({
    required this.brandId,
    this.username,
    this.token,
    this.extra = const {},
  });

  final String brandId;
  final String? username;
  final String? token;
  final Map<String, String> extra;
}
