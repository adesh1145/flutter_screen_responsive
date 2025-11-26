import 'breakpoints.dart';
import 'device_type.dart';

/// Utilities for managing breakpoint configuration and deriving the active
/// [DeviceType] from a screen width.
///
/// Populated by `ResponsiveInit`, these helpers are used by widgets and
/// extensions to decide when and how to scale UI.
class ResponsiveUtils {
  /// Registry of breakpoint rules by [DeviceType].
  /// Must contain entries for at least [DeviceType.mobile], [DeviceType.tablet],
  /// and [DeviceType.desktop] before calling [setDeviceType].
  static final Map<DeviceType, Breakpoints> breakpoints = {};

  /// The most recently computed device type.
  static DeviceType currentDeviceType = DeviceType.mobile;

  /// Returns the latest computed device type.
  static DeviceType get getDeviceType => currentDeviceType;

  /// Computes and stores the [DeviceType] for a given layout width.
  ///
  /// Throws if required entries are missing from [breakpoints].
  static DeviceType setDeviceType(double width) {
    if (width <= breakpoints[DeviceType.mobile]!.width) {
      return currentDeviceType = DeviceType.mobile;
    } else if (width <= breakpoints[DeviceType.tablet]!.width) {
      return currentDeviceType = DeviceType.tablet;
    } else {
      return currentDeviceType = DeviceType.desktop;
    }
  }

  /// True if [width] maps to [DeviceType.mobile].
  static bool isMobile(double width) =>
      setDeviceType(width) == DeviceType.mobile;

  /// True if [width] maps to [DeviceType.tablet].
  static bool isTablet(double width) =>
      setDeviceType(width) == DeviceType.tablet;

  /// True if [width] maps to [DeviceType.desktop].
  static bool isDesktop(double width) =>
      setDeviceType(width) == DeviceType.desktop;

  /// Whether automatic scaling (via ScreenUtil) should be enabled for the
  /// current device type, as specified by the active [Breakpoints].
  static bool get isNeedScreenUtil {
    final currentBreakpoint = breakpoints[currentDeviceType];
    if (currentBreakpoint == null) return false;
    return currentBreakpoint.autoScale ? true : false;
  }
}
