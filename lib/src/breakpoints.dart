import 'dart:ui';

import 'device_type.dart';

/// Breakpoints describe a device width threshold with its target [DeviceType],
/// optional design [Size], and whether automatic scaling is enabled.
///
/// These are consumed by `ResponsiveInit` and `ResponsiveUtils` to determine
/// which layout and scaling configuration should apply.
class Breakpoints {
  /// Maximum width (in logical pixels) for which this breakpoint applies.
  /// If the current screen width is less than or equal to this value, the
  /// associated [deviceType] is selected.
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
    return 'Breakpoints(width: $width, deviceType: $deviceType, designSize: $designSize, autoScale: $autoScale)';
  }
}

//for tab 768 *1024

//for mobile 375*812

//for web >tab
