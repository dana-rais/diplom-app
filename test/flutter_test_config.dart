import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled Noto Sans (same files as pubspec) so widget tests render
/// real glyphs, including Kazakh letters.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final loader = FontLoader('NotoSans');
  for (final w in const ['Regular', 'Medium', 'Bold']) {
    loader.addFont(
      File('assets/fonts/NotoSans-$w.ttf')
          .readAsBytes()
          .then((Uint8List b) => ByteData.view(b.buffer)),
    );
  }
  await loader.load();
  await testMain();
}
