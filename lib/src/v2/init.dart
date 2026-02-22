import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'breakpoints.dart' as b;
import 'responsive_scope.dart';

/// Top-level initializer that registers breakpoints and wires up
/// [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil).
///
/// Place `ResponsiveInit` above your `MaterialApp`/`CupertinoApp`. It:
/// - resolves the active device type from the current screen width
/// - configures `ScreenUtilInit` with the matched breakpoint's `designSize`
///   and `autoScale` settings
/// - provides a [ResponsiveScope] to the entire widget subtree
///
/// Unlike the old global-state approach, this widget uses [InheritedWidget]
/// (`ResponsiveScope`), allowing any child to override breakpoints locally
/// via [ResponsiveScope.overrideBreakpoints].
///
/// ```dart
/// ResponsiveInit(
///   breakpoints: [
///     Breakpoints(width: 450, deviceType: DeviceType.mobile,
///                 designSize: Size(375, 812)),
///     Breakpoints(width: 800, deviceType: DeviceType.tablet,
///                 designSize: Size(768, 1024)),
///     Breakpoints(width: double.infinity, deviceType: DeviceType.desktop,
///                 designSize: Size(1440, 900), autoScale: false),
///   ],
///   builder: (context, child) => MaterialApp(home: HomeScreen()),
/// )
/// ```
class ResponsiveInit extends StatefulWidget {
  const ResponsiveInit({
    super.key,
    required this.breakpoints,
    required this.builder,
  });

  /// Ordered list of breakpoint rules.
  ///
  /// Provide at least mobile/tablet/desktop. The last rule commonly uses
  /// `double.infinity` to cover all larger widths. Each rule may also
  /// specify a `designSize` and whether auto scaling (`autoScale`) is enabled.
  final List<b.Breakpoints> breakpoints;

  /// App builder invoked inside `ScreenUtilInit`.
  ///
  /// This builder runs within a `ScreenUtilInit` configured for the currently
  /// matched breakpoint. The widget is keyed by the active `DeviceType` to
  /// force rebuilds when the device type changes.
  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  State<ResponsiveInit> createState() => _ResponsiveInitState();
}

class _ResponsiveInitState extends State<ResponsiveInit> {
  late final b.ResponsiveBreakpointConfig _config;

  @override
  void initState() {
    super.initState();
    _config = b.ResponsiveBreakpointConfig.fromList(widget.breakpoints);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // Use MediaQuery for actual screen size (NOT LayoutBuilder!)
        final size = MediaQuery.sizeOf(context);

        // Resolve device type using config
        final deviceType = _config.resolveDeviceType(size.width);
        final breakpoint = _config[deviceType];

        // Wrap with ResponsiveScope first, then ScreenUtilInit.
        // ResponsiveScope provides device type and screen size to the tree.
        // ScreenUtilInit handles the actual scaling configuration.
        return ResponsiveScope(
          currentDeviceType: deviceType,
          screenSize: size,
          child: ScreenUtilInit(
            key: ValueKey(deviceType),
            designSize: breakpoint?.designSize ?? const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            enableScaleText: () => breakpoint?.autoScale ?? true,
            enableScaleWH: () => breakpoint?.autoScale ?? true,
            useInheritedMediaQuery: true,
            ensureScreenSize: true,
            builder: widget.builder,
          ),
        );
      },
    );
  }
}
