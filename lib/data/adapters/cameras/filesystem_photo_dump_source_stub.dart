import 'photo_dump_models.dart';

/// Web / non-IO stub — photo-dump filesystem import is unavailable in browsers.
class FilesystemPhotoDumpSource implements PhotoDumpSource {
  const FilesystemPhotoDumpSource();

  static const mediaExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.mp4',
    '.mov',
  };

  @override
  Future<List<PhotoDumpEntry>> listEntries(String rootPath) async {
    // Trail-cam SD-card / folder import requires dart:io.
    return const [];
  }

  static String extensionOf(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0) return '';
    return fileName.substring(dot).toLowerCase();
  }

  /// Path-segment heuristic without dart:io (web-safe).
  static String? cameraIdFromPath(String rootPath, String filePath) {
    final rootSegs = Uri.file(rootPath, windows: false)
        .pathSegments
        .where((s) => s.isNotEmpty)
        .toList();
    final fileSegs = Uri.file(filePath, windows: false)
        .pathSegments
        .where((s) => s.isNotEmpty)
        .toList();
    if (fileSegs.length <= rootSegs.length + 1) {
      return null;
    }
    return fileSegs[rootSegs.length];
  }
}
