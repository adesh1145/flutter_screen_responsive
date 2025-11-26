import 'responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'breakpoints.dart' as b;

/// Top-level initializer that registers breakpoints and wires up
/// [`flutter_screenutil`](https://pub.dev/packages/flutter_screenutil).
///
/// Place `ResponsiveInit` above your `MaterialApp`/`CupertinoApp`. It:
/// - stores your `Breakpoints` by `DeviceType`
/// - detects current device type by screen width
/// - rebuilds `ScreenUtilInit` when device type changes so scale config stays in sync
class ResponsiveInit extends StatefulWidget {
  const ResponsiveInit({
    super.key,
    required this.breakpoints,
    required this.builder,
  });

  /// Ordered list of breakpoint rules. Provide at least mobile, tablet, desktop.
  final List<b.Breakpoints> breakpoints;

  /// App builder invoked inside `ScreenUtilInit`.
  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  State<ResponsiveInit> createState() => _ResponsiveInitState();
}

class _ResponsiveInitState extends State<ResponsiveInit> {
  @override
  void initState() {
    super.initState();
    ResponsiveUtils.breakpoints.addAll({
      for (final breakpoint in widget.breakpoints)
        breakpoint.deviceType: breakpoint,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final deviceType = ResponsiveUtils.setDeviceType(size.width);
        final breakpoint = ResponsiveUtils.breakpoints[deviceType];

        // Force ScreenUtilInit to rebuild when device type changes
        // This ensures scaling config updates properly
        return ScreenUtilInit(
          key: ValueKey(
            deviceType,
          ), // 🔑 Key ensures rebuild on device type change
          designSize: breakpoint?.designSize ?? const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          enableScaleText: () => breakpoint?.autoScale ?? true,
          enableScaleWH: () => breakpoint?.autoScale ?? true,
          builder: widget.builder,
        );
      },
    );
  }
}
