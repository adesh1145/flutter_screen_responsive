/// Public API exports for the `flutter_screen_responsive` package.
///
/// Import `package:flutter_screen_responsive/flutter_screen_responsive.dart`
/// to access the v2 InheritedWidget-based responsive system:
///
/// - [ResponsiveInit] — top-level widget to configure breakpoints & ScreenUtil
/// - [ResponsiveScope] — InheritedWidget carrying device type & screen size;
///   supports local overrides via [ResponsiveScope.overrideBreakpoints]
/// - [Breakpoints], [DeviceType], [ResponsiveBreakpointConfig]
/// - [SizeExtension] with `.w`, `.h`, `.sp`, spacing helpers, etc.
/// - `context.responsive` accessor via [ResponsiveScopeExtension]
///
/// For the deprecated v1 API, import:
/// ```dart
/// import 'package:flutter_screen_responsive/flutter_screen_responsive_legacy.dart';
/// ```
library flutter_screen_responsive;

// ── v2: InheritedWidget-based API (recommended) ──────────────────────────
export 'src/v2/breakpoints.dart';
export 'src/v2/device_type.dart';
export 'src/v2/responsive_scope.dart';
export 'src/v2/init.dart';
export 'src/v2/extension.dart';

