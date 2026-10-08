import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

/// Code points covered by the font's cmap (formats 4 and 12).
Set<int> _cmapCodepoints(Uint8List bytes) {
  final d = ByteData.sublistView(bytes);
  final numTables = d.getUint16(4);
  int? cmapOffset;
  for (var i = 0; i < numTables; i++) {
    final rec = 12 + i * 16;
    final tag = String.fromCharCodes(bytes.sublist(rec, rec + 4));
    if (tag == 'cmap') cmapOffset = d.getUint32(rec + 8);
  }
  if (cmapOffset == null) throw StateError('no cmap table');
  final out = <int>{};
  final subtables = d.getUint16(cmapOffset + 2);
  for (var i = 0; i < subtables; i++) {
    final off = cmapOffset + d.getUint32(cmapOffset + 4 + i * 8 + 4);
    final format = d.getUint16(off);
    if (format == 4) {
      final segX2 = d.getUint16(off + 6);
      final ends = off + 14;
      final starts = ends + segX2 + 2;
      for (var s = 0; s < segX2 ~/ 2; s++) {
        final end = d.getUint16(ends + s * 2);
        final start = d.getUint16(starts + s * 2);
        for (var c = start; c <= end && c != 0xFFFF; c++) {
          out.add(c);
        }
      }
    } else if (format == 12) {
      final groups = d.getUint32(off + 12);
      for (var g = 0; g < groups; g++) {
        final start = d.getUint32(off + 16 + g * 12);
        final end = d.getUint32(off + 20 + g * 12);
        for (var c = start; c <= end; c++) {
          out.add(c);
        }
      }
    }
  }
  return out;
}

void main() {
  const kazakh = 'ӘҒҚҢӨҰҮҺІ әғқңөұүһі';
  const basics =
      'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя0123456789₸«»—·';

  for (final w in ['Regular', 'Medium', 'Bold']) {
    test('NotoSans-$w covers Kazakh Cyrillic, Russian and chrome symbols', () {
      final file = File('assets/fonts/NotoSans-$w.ttf');
      expect(file.existsSync(), isTrue);
      final cps = _cmapCodepoints(file.readAsBytesSync());
      for (final r in (kazakh + basics).runes) {
        if (r == 0x20) continue;
        expect(
          cps.contains(r),
          isTrue,
          reason:
              'U+${r.toRadixString(16)} (${String.fromCharCode(r)}) missing in $w',
        );
      }
    });
  }

  test('font license is bundled', () {
    expect(
      File('assets/fonts/OFL.txt').readAsStringSync(),
      contains('SIL OPEN FONT LICENSE'),
    );
  });
}
