import 'dart:ui';

import 'device_type.dart';

/// Defines a responsive breakpoint rule.
///
/// Each breakpoint specifies a maximum [width] threshold, the associated
/// [deviceType], an optional [designSize] for ScreenUtil scaling, and
/// whether [autoScale] is enabled.
///
/// Example:
/// ```dart
/// Breakpoints(
///   width: 450,
///   deviceType: DeviceType.mobile,
///   designSize: Size(375, 812),
///   autoScale: true,
/// )
/// ```
class Breakpoints {
  /// Maximum width (in logical pixels) for which this breakpoint applies.
  /// If the current screen width is ≤ this value, the associated
  /// [deviceType] is selected.
  final double width;

  /// The device classification that this breakpoint represents.
  final DeviceType deviceType;

  /// Optional design canvas size used to configure ScreenUtil for scaling.
  final Size? designSize;

  /// When true, enables text and width/height scaling for this breakpoint.
  /// When false, sizes are treated as raw logical pixels.
  final bool autoScale;

  const Breakpoints({
    required this.width,
    required this.deviceType,
    this.designSize,
    this.autoScale = true,
  });

  @override
  String toString() {
    return 'Breakpoints(width: $width, deviceType: $deviceType, '
        'designSize: $designSize, autoScale: $autoScale)';
  }
}

/// Holds a complete breakpoint configuration (global or local override).
///
/// Works like CSS `@media` breakpoints — define once globally in
/// [ResponsiveInit], override locally with [ResponsiveScope.overrideBreakpoints].
class ResponsiveBreakpointConfig {
  /// Map of [DeviceType] → [Breakpoints] rule.
  final Map<DeviceType, Breakpoints> breakpoints;

  const ResponsiveBreakpointConfig(this.breakpoints);

  /// Create config from a list of breakpoints (same format as [ResponsiveInit]).
  factory ResponsiveBreakpointConfig.fromList(List<Breakpoints> list) {
    return ResponsiveBreakpointConfig({
      for (final bp in list) bp.deviceType: bp,
    });
  }

  /// Resolve which [DeviceType] a given screen [width] falls into.
  ///
  /// Sorts breakpoints by width ascending and returns the first whose
  /// threshold is ≥ the given width. If no threshold matches, returns
  /// the device type of the last (largest) breakpoint.
  DeviceType resolveDeviceType(double width) {
    final sorted = breakpoints.values.toList()
      ..sort((a, b) => a.width.compareTo(b.width));

    for (final bp in sorted) {
      if (width <= bp.width) return bp.deviceType;
    }
    return sorted.last.deviceType;
  }

  /// Get the design size for a given device type.
  Size? getDesignSize(DeviceType type) => breakpoints[type]?.designSize;

  /// Whether auto-scaling is enabled for a given device type.
  bool isAutoScale(DeviceType type) => breakpoints[type]?.autoScale ?? true;

  /// Get the [Breakpoints] entry for a given device type.
  Breakpoints? operator [](DeviceType type) => breakpoints[type];
}
