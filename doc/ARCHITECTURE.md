# Package structure

The public entry point is lib/streak_flame.dart. Existing constructors,
named arguments, count behavior and default appearance remain supported.

| Component | Responsibility |
| --- | --- |
| StreakWidget | Select presentation and coordinate completed/replayed title state |
| StreakCelebrationDialog | Compatibility subtype using the same presentation state; supplies dialog layout and default dismissal |
| BigStreakFlameWidget | Own/dispose idle and transition controllers, delayed starts and lifecycle handling |
| StreakFlamePainter | Render flame layers, halo and bounded particles from direct animation notifications |
| StreakBadge | Render the count transition; listens only through the renderer's finite transition |
| StreakCelebrationContent | Compose header, flame, messages and action without subscribing to animation ticks |
| StreakCelebrationAction | Resolve optional default button styling and render the host-owned action |
| StreakCelebrationFrame | Card shape, decoration, constraints and scrolling |
| StreakCelebrationDialogFrame / showStreakCelebrationRoute | Modal layout and route/accessibility behavior |
| validateStreakConfiguration | Shared validation for direct/inline/modal entry points |

The compatibility dialog inherits the unified presentation's properties/state;
it no longer declares a second copy of those properties or forwards them through
another StreakWidget. Its constructor retains size 215 and its show method retains
the legacy route-content type. Named popup signatures still forward explicit
arguments so existing callers remain source-compatible.

Styles use optional value groups:
- StreakCardStyle: card decoration, padding, margins and modal insets.
- StreakHeaderStyle: header pill appearance and visibility.
- StreakCloseStyle: close control appearance and visibility.
- StreakTextStyle: title/subtitle typography, alignment and spacing.
- StreakActionStyle: continue control appearance, spacing and visibility.

All existing flat StreakCelebrationStyle parameters and read properties remain
available. A supplied non-null grouped property overrides its matching flat
property; an omitted/null property falls back to the flat setting/default.
These getters read stored values directly; they do not build maps or allocate
resolved style objects during build/paint. TextStyle and ButtonStyle precedence
remains unchanged. Caller-owned lists and gradients must remain immutable.

No app services, persistence/state-management dependencies, images, additional
animation controllers, repaint boundaries, or rendering layers were introduced.
The refactor preserves the painter, badge rendering and external controller
source and the renderer's motion state machine.

See [CUSTOMIZATION](CUSTOMIZATION.md) for usage,
[PERFORMANCE](PERFORMANCE.md) for test evidence and profiling limits, and
[VALIDATION](VALIDATION.md) for executed checks.
