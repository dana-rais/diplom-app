import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadam/core/sim_api/sim_target.dart';
import 'package:kadam/core/sim_api/target_registry.dart';

Widget _host(TargetRegistry r, List<Widget> children) => Directionality(
  textDirection: TextDirection.ltr,
  child: TargetScope(
    registry: r,
    child: Align(
      alignment: Alignment.topLeft,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    ),
  ),
);

Widget _box(String id, {Key? key, double size = 40, TargetShape? shape}) =>
    SimTarget(
      key: key,
      id: id,
      shape: shape ?? TargetShape.roundedRect,
      child: SizedBox(width: size, height: size),
    );

void main() {
  late TargetRegistry registry;
  setUp(() => registry = TargetRegistry());
  tearDown(() => registry.dispose());

  testWidgets(
    'register/unregister never notify synchronously; revision is bumped after the frame, coalesced',
    (tester) async {
      final seen = <int>[];
      registry.revision.addListener(() => seen.add(registry.revision.value));

      await tester.pumpWidget(_host(registry, [_box('a'), _box('b')]));
      // Registration happened during build; nothing was notified yet or during build.
      await tester.pump();
      expect(seen, [1]); // two registrations -> ONE bump

      await tester.pumpWidget(_host(registry, [_box('a')]));
      await tester.pump();
      expect(seen, [1, 2]); // unregister b -> one more bump

      expect(registry.isMounted('a'), isTrue);
      expect(registry.isMounted('b'), isFalse);
    },
  );

  testWidgets(
    'direct register outside a frame is not synchronous and still gets a frame (A5)',
    (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(key: key),
        ),
      );
      await tester.pump();
      var notified = 0;
      registry.revision.addListener(() => notified++);
      expect(tester.binding.hasScheduledFrame, isFalse);

      registry.register('x', key, TargetShape.circle);
      expect(notified, 0, reason: 'must not notify synchronously');
      expect(
        tester.binding.hasScheduledFrame,
        isTrue,
        reason: 'scheduleFrame() was called',
      );

      await tester.pump();
      expect(notified, 1);
      expect(registry.shapeOf('x'), TargetShape.circle);

      registry.unregister('x', key);
      expect(notified, 1);
      await tester.pump();
      expect(notified, 2);
    },
  );

  testWidgets(
    'unregistering a stale key does not remove a newer registration',
    (tester) async {
      final k1 = GlobalKey(), k2 = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              SizedBox(key: k1, height: 10),
              SizedBox(key: k2, height: 20),
            ],
          ),
        ),
      );
      registry.register('a', k1, TargetShape.roundedRect);
      registry.register('a', k2, TargetShape.circle);
      expect(registry.shapeOf('a'), TargetShape.circle);
      registry.unregister('a', k1);
      expect(registry.isMounted('a'), isTrue);
      expect(registry.shapeOf('a'), TargetShape.circle);
      final root = tester.renderObject<RenderBox>(find.byType(Column));
      expect(registry.rectOf('a', root)!.height, 20);
      registry.unregister('a', k2);
      expect(registry.isMounted('a'), isFalse);
      expect(registry.rectOf('a', root), isNull);
      await tester.pump();
    },
  );

  testWidgets('debugDuplicateIds reports ids with more than one mounted key', (
    tester,
  ) async {
    await tester.pumpWidget(_host(registry, [_box('a'), _box('a'), _box('b')]));
    expect(registry.debugDuplicateIds(), ['a']);
    await tester.pumpWidget(_host(registry, [_box('a'), _box('b')]));
    expect(registry.debugDuplicateIds(), isEmpty);
  });

  testWidgets(
    'replacing a SimTarget with the same id keeps the new one registered',
    (tester) async {
      await tester.pumpWidget(
        _host(registry, [_box('a', key: const ValueKey(1))]),
      );
      await tester.pumpWidget(
        _host(registry, [_box('a', key: const ValueKey(2))]),
      );
      expect(registry.isMounted('a'), isTrue);
      expect(registry.debugDuplicateIds(), isEmpty);
      await tester.pump();
    },
  );

  testWidgets(
    'rectOf is relative to the ancestor; shapeOf follows the widget',
    (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: TargetScope(
            registry: registry,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: Container(
                  key: const ValueKey('anchor'),
                  child: _box('t', size: 64, shape: TargetShape.circle),
                ),
              ),
            ),
          ),
        ),
      );
      final anchor = tester.renderObject<RenderBox>(
        find.byKey(const ValueKey('anchor')),
      );
      expect(registry.rectOf('t', anchor), const Rect.fromLTWH(0, 0, 64, 64));
      final root = tester.renderObject<RenderBox>(find.byType(Align));
      expect(registry.rectOf('t', root), const Rect.fromLTWH(30, 50, 64, 64));
      expect(registry.shapeOf('t'), TargetShape.circle);
      expect(registry.shapeOf('unknown'), TargetShape.roundedRect);
      expect(registry.rectOf('unknown', root), isNull);
    },
  );

  testWidgets('changing the id re-registers', (tester) async {
    await tester.pumpWidget(
      _host(registry, [_box('a', key: const ValueKey('w'))]),
    );
    await tester.pumpWidget(
      _host(registry, [_box('b', key: const ValueKey('w'))]),
    );
    expect(registry.isMounted('a'), isFalse);
    expect(registry.isMounted('b'), isTrue);
    await tester.pump();
  });

  testWidgets('SimTarget without a TargetScope just renders its child', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.ltr, child: _box('a')),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('unmounting after the registry was disposed does not throw', (
    tester,
  ) async {
    final local = TargetRegistry();
    await tester.pumpWidget(_host(local, [_box('a')]));
    local.dispose();
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
