/// Public API exports for the `flutter_screen_responsive` package.
///
/// Import `package:flutter_screen_responsive/flutter_screen_responsive.dart` to access the core building
/// blocks:
/// - `ResponsiveInit` to configure breakpoints and ScreenUtil
/// - `Responsive` to render mobile/tablet/desktop builders
/// - `Breakpoints`, `DeviceType`, and `ResponsiveUtils`
/// - `SizeExtension` with `.w`, `.h`, `.sp`, spacing helpers, etc.
library flutter_screen_responsive;

export 'src/breakpoints.dart';
export 'src/device_type.dart';
export 'src/responsive_utils.dart';
export 'src/init.dart';
export 'src/extension.dart';
export 'src/responsive_widget.dart';
