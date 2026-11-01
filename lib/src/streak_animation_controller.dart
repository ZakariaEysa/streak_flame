import 'package:flutter/foundation.dart';

/// Optional replay and pause controls, independent of app state management.
///
/// Own and dispose this controller in the calling widget. One controller can
/// coordinate multiple flames. Commands affect currently attached widgets.
class StreakAnimationController extends ChangeNotifier {
  int _replayRevision = 0;
  bool _isPaused = false;

  /// Monotonically increasing replay request identifier.
  int get replayRevision => _replayRevision;

  /// Whether all motion is explicitly paused.
  bool get isPaused => _isPaused;

  /// Restarts the old-to-new celebration immediately and resumes motion.
  void replay() {
    _replayRevision++;
    _isPaused = false;
    notifyListeners();
  }

  /// Pauses motion without completing the transition.
  void pause() {
    if (_isPaused) return;
    _isPaused = true;
    notifyListeners();
  }

  /// Resumes a paused transition and idle animation.
  void resume() {
    if (!_isPaused) return;
    _isPaused = false;
    notifyListeners();
  }
}
