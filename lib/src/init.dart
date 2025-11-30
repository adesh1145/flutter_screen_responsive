import 'responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'breakpoints.dart' as b;

/// Top-level initializer that registers breakpoints and wires up
/// [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil).
///
/// Place `ResponsiveInit` above your `MaterialApp`/`CupertinoApp`. It:
/// - registers your ordered `Breakpoints` with `ResponsiveUtils`
/// - detects the active device type by current screen width
/// - looks up the exact active breakpoint via `breakpointForWidth`
/// - re-configures `ScreenUtilInit` whenever the device type changes so
///   scaling and `designSize` always match the active breakpoint
class ResponsiveInit extends StatefulWidget {
  const ResponsiveInit({
    super.key,
    required this.breakpoints,
    required this.builder,
  });

  /// Ordered list of breakpoint rules (will be sorted ascending by `width`).
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
  @override
  void initState() {
    super.initState();
    ResponsiveUtils.registerBreakpoints(widget.breakpoints);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final deviceType = ResponsiveUtils.setDeviceType(size.width);
        // Use the exact active breakpoint to configure ScreenUtil parameters.
        final breakpoint = ResponsiveUtils.breakpointForWidth(size.width);

        // Force ScreenUtilInit to rebuild when device type changes
        // This ensures scaling config updates properly
        return ScreenUtilInit(
          key: ValueKey(
            deviceType,
          ), // 🔑 Key ensures rebuild on device type change
          designSize: breakpoint.designSize ?? const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          // Enable or disable ScreenUtil scaling from the active breakpoint.
          enableScaleText: () => breakpoint.autoScale,
          enableScaleWH: () => breakpoint.autoScale,
          builder: widget.builder,
        );
      },
    );
  }
}
