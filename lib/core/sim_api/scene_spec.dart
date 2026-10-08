import 'package:flutter/widgets.dart';

import 'scene_context.dart';

/// A const description of a simulator scene. [build] is called inside
/// `SceneScope` + `TargetScope`; the scene reports user actions to [ctx].
abstract class SceneSpec {
  const SceneSpec();

  Widget build(BuildContext context, SceneContext ctx);
}
