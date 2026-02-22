/// Deprecated v1 API for the `flutter_screen_responsive` package.
///
/// **⚠️ This file is deprecated.** Use the v2 InheritedWidget-based API
/// from the main barrel file instead:
///
/// ```dart
/// import 'package:flutter_screen_responsive/flutter_screen_responsive.dart';
/// ```
///
/// The v1 API uses global static state (`ResponsiveUtils`) and does not
/// support local breakpoint overrides. It will be removed in a future
/// major release.
@Deprecated(
  'Use the v2 API from flutter_screen_responsive.dart instead. '
  'v1 will be removed in a future major release.',
)
library flutter_screen_responsive_legacy;

export 'src/v1/breakpoints.dart';
export 'src/v1/device_type.dart';
export 'src/v1/responsive_utils.dart';
export 'src/v1/init.dart';
export 'src/v1/extension.dart';
export 'src/v1/responsive_widget.dart';
export 'src/v1/r_padding.dart';
export 'src/v1/r_sizedbox.dart';
