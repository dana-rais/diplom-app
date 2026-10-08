import 'package:flutter/services.dart';

/// The set of bundled audio files. Only `.mp3` assets count; a missing file
/// simply means «unavailable» for that voice key.
class AssetCatalog {
  AssetCatalog.fromSet(Set<String> paths) : _paths = Set.unmodifiable(paths);

  final Set<String> _paths;

  static Future<AssetCatalog> load(AssetBundle bundle) async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(bundle);
      return AssetCatalog.fromSet({
        for (final a in manifest.listAssets())
          if (a.startsWith('assets/audio/') && a.endsWith('.mp3')) a,
      });
    } catch (_) {
      return AssetCatalog.fromSet(const {});
    }
  }

  bool has(String path) => _paths.contains(path);

  Iterable<String> get paths => _paths;
}
