import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

enum TargetShape { circle, roundedRect }

class _Registration {
  _Registration(this.key, this.shape);

  final GlobalKey key;
  TargetShape shape;

  bool get mounted => key.currentContext?.mounted ?? false;
}

/// Where each `SimTarget` currently is. NOT a ChangeNotifier: (un)registering
/// only touches a map; [revision] is bumped from one coalesced post-frame
/// callback so listeners never run during build.
class TargetRegistry {
  final Map<String, List<_Registration>> _regs = {};
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);
  bool _bumpQueued = false;
  bool _disposed = false;

  ValueListenable<int> get revision => _revision;

  void register(String id, GlobalKey key, TargetShape shape) {
    final list = _regs.putIfAbsent(id, () => []);
    final i = list.indexWhere((r) => identical(r.key, key));
    if (i >= 0) {
      list[i].shape = shape;
    } else {
      list.add(_Registration(key, shape));
    }
    _queueBump();
  }

  /// Removes only the registration made with exactly this [key].
  void unregister(String id, GlobalKey key) {
    final list = _regs[id];
    if (list == null) return;
    final before = list.length;
    list.removeWhere((r) => identical(r.key, key));
    if (list.isEmpty) _regs.remove(id);
    if (list.length != before) _queueBump();
  }

  bool isMounted(String id) => _newestMounted(id) != null;

  /// Rect of the newest mounted registration in [ancestor] coordinates, or
  /// null if there is none or it is not laid out yet.
  Rect? rectOf(String id, RenderBox ancestor) {
    final reg = _newestMounted(id);
    if (reg == null) return null;
    final ro = reg.key.currentContext?.findRenderObject();
    if (ro is! RenderBox || !ro.attached || !ro.hasSize) return null;
    if (!ancestor.attached || !ancestor.hasSize) return null;
    try {
      final topLeft = ro.localToGlobal(Offset.zero, ancestor: ancestor);
      return topLeft & ro.size;
    } catch (_) {
      return null;
    }
  }

  TargetShape shapeOf(String id) =>
      (_newestMounted(id) ?? _regs[id]?.lastOrNull)?.shape ??
      TargetShape.roundedRect;

  /// Ids with more than one mounted key (forbidden; see `expectUniqueTargets`).
  List<String> debugDuplicateIds() => [
    for (final e in _regs.entries)
      if (e.value.where((r) => r.mounted).length > 1) e.key,
  ];

  _Registration? _newestMounted(String id) {
    final list = _regs[id];
    if (list == null) return null;
    for (var i = list.length - 1; i >= 0; i--) {
      if (list[i].mounted) return list[i];
    }
    return null;
  }

  void _queueBump() {
    if (_bumpQueued || _disposed) return;
    _bumpQueued = true;
    final binding = SchedulerBinding.instance;
    binding.addPostFrameCallback((_) {
      _bumpQueued = false;
      if (!_disposed) _revision.value++;
    });
    // Make sure the callback runs even if no frame is pending (e.g. after an
    // unregister that happened while unmounting the last widget).
    binding.scheduleFrame();
  }

  void dispose() {
    _disposed = true;
    _revision.dispose();
  }
}

class TargetScope extends InheritedWidget {
  const TargetScope({super.key, required this.registry, required super.child});

  final TargetRegistry registry;

  static TargetRegistry of(BuildContext c) {
    final s = c.getInheritedWidgetOfExactType<TargetScope>();
    assert(s != null, 'No TargetScope above this context');
    return s!.registry;
  }

  /// Null when there is no scope (e.g. a scene widget previewed on its own).
  static TargetRegistry? maybeOf(BuildContext c) =>
      c.getInheritedWidgetOfExactType<TargetScope>()?.registry;

  @override
  bool updateShouldNotify(TargetScope old) => registry != old.registry;
}
