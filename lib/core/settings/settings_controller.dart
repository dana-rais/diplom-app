import 'package:flutter/foundation.dart';

import 'app_settings.dart';
import 'settings_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._repository, {AppSettings? initial})
    : _value = initial ?? _repository.load();

  final SettingsRepository _repository;
  AppSettings _value;

  AppSettings get value => _value;

  /// Applies [f], notifies immediately (live preview), then persists.
  Future<void> update(AppSettings Function(AppSettings) f) {
    final next = f(_value);
    if (next == _value) return Future.value();
    _value = next;
    notifyListeners();
    return _repository.save(next);
  }
}
