/// One media file discovered in a trail-cam photo dump.
class PhotoDumpEntry {
  const PhotoDumpEntry({
    required this.absolutePath,
    required this.fileName,
    this.cameraId,
    this.modifiedAt,
  });

  final String absolutePath;
  final String fileName;

  /// Optional camera identity (e.g. parent folder name).
  final String? cameraId;
  final DateTime? modifiedAt;
}

/// Abstraction over listing dump files (filesystem vs unit-test fixture).
abstract class PhotoDumpSource {
  Future<List<PhotoDumpEntry>> listEntries(String rootPath);
}
