import 'package:flutter/widgets.dart';

import 'target_registry.dart';

/// Marks an interactive scene element so the spotlight can find it.
/// At most ONE mounted [SimTarget] per id; a group (choices, keypad) is a
/// single [SimTarget] around the whole group. Without a `TargetScope` it just
/// renders [child].
class SimTarget extends StatefulWidget {
  const SimTarget({
    super.key,
    required this.id,
    required this.child,
    this.shape = TargetShape.roundedRect,
  });

  final String id;
  final Widget child;
  final TargetShape shape;

  @override
  State<SimTarget> createState() => _SimTargetState();
}

class _SimTargetState extends State<SimTarget> {
  final GlobalKey _key = GlobalKey();
  TargetRegistry? _registry;
  String? _id;

  void _sync() {
    final registry = TargetScope.maybeOf(context);
    if (registry == _registry && widget.id == _id) {
      registry?.register(widget.id, _key, widget.shape);
      return;
    }
    _registry?.unregister(_id!, _key);
    _registry = registry;
    _id = widget.id;
    registry?.register(widget.id, _key, widget.shape);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(SimTarget old) {
    super.didUpdateWidget(old);
    if (old.id != widget.id || old.shape != widget.shape) _sync();
  }

  @override
  void dispose() {
    final id = _id;
    if (id != null) _registry?.unregister(id, _key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      KeyedSubtree(key: _key, child: widget.child);
}
