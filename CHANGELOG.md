## 0.1.0

Initial local release candidate.

- Added the MIT license, copyright 2026 ZakariaEysa.

- Selected streak_flame as the public package name and renamed the public import
  to package:streak_flame/streak_flame.dart. The red/orange default is unchanged.

- Shared unified/legacy presentation state and inherited properties, extracted
  stateless celebration content/action, and centralized configuration validation.
- Added optional card/header/text/close/action style groups with partial overrides;
  existing flat arguments and getters remain supported.
- Verified unchanged default/custom snapshots and static subtree isolation during
  idle/count ticks. No production performance improvement is claimed.

- Added StreakWidget with flame/full inline celebration display options and
  showCelebration for modal presentation; legacy entry points remain supported.
- Added optional flame outlines/effect sizing, badge shapes/borders/layout/shadows,
  and independent card/header/title/close/action styling and gradients.
- Added full-card/shape styling controls in the playground, Arabic parameter
  documentation, complete-card previews, and unified API regression tests.

- Extracted the original streak flame and dialog into a standalone Flutter package.
- Added configurable palettes, strings, number/plural formatting, and typography.
- Added independent flame/badge/effect colors, custom gradients, and palette copyWith.
- Preserved palette text colors with partial typography and effect transparency.
- Added separate customizable increase/restart messages and an explicit reset override.
- Added automatic count updates, replay, pause, resume, and timing controls.
- Added reduced-motion support, app lifecycle handling, cancellable delays,
  stable semantics, and responsive layouts.
- Moved idle animation to direct canvas repaint notifications.
- Added an independent playground with editable counts/messages, live timing/size/effect controls, RTL, and text-scale testing.
- Added web and native host files, portable ZIP tooling, VS Code launch/tasks, and playground interaction tests.

Not published.
