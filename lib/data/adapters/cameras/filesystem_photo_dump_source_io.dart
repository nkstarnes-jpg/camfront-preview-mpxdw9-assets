import 'dart:io';

import 'photo_dump_models.dart';

/// Recursive filesystem scan for common trail-cam media extensions.
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
    final root = Directory(rootPath);
    if (!await root.exists()) {
      return const [];
    }

    final out = <PhotoDumpEntry>[];
    await for (final entity in root.list(recursive: true, followLinks: false)) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.isNotEmpty
          ? entity.uri.pathSegments.last
          : entity.path.split(Platform.pathSeparator).last;
      final ext = extensionOf(name);
      if (!mediaExtensions.contains(ext)) continue;

      DateTime? modified;
      try {
        modified = (await entity.stat()).modified;
      } on FileSystemException {
        modified = null;
      }

      out.add(
        PhotoDumpEntry(
          absolutePath: entity.path,
          fileName: name,
          cameraId: cameraIdFromPath(root.path, entity.path),
          modifiedAt: modified,
        ),
      );
    }
    return out;
  }

  static String extensionOf(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0) return '';
    return fileName.substring(dot).toLowerCase();
  }

  /// Immediate subdirectory under [rootPath] becomes cameraId when present.
  static String? cameraIdFromPath(String rootPath, String filePath) {
    final rootUri = Directory(rootPath).absolute.uri;
    final fileUri = File(filePath).absolute.uri;
    final rootSegs = rootUri.pathSegments.where((s) => s.isNotEmpty).toList();
    final fileSegs = fileUri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (fileSegs.length <= rootSegs.length + 1) {
      return null;
    }
    return fileSegs[rootSegs.length];
  }
}
