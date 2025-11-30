import 'breakpoints.dart';
import 'device_type.dart';

/// Utilities for managing breakpoint configuration and deriving the active
/// [DeviceType] from a screen width.
///
/// Populated by `ResponsiveInit`, these helpers are used by widgets and
/// extensions to decide when and how to scale UI.
class ResponsiveUtils {
  /// Registry of breakpoint rules by [DeviceType].
  static final Map<DeviceType, Breakpoints> breakpoints = {};

  static List<Breakpoints> _orderedBreakpoints = [];
  static int _lastIndex = -1;

  /// The most recently computed device type.
  static DeviceType currentDeviceType = DeviceType.mobile;

  /// Returns the latest computed device type.
  static DeviceType get getDeviceType => currentDeviceType;

  /// Registers and sorts breakpoint definitions.
  static void registerBreakpoints(List<Breakpoints> entries) {
    if (entries.isEmpty) {
      throw ArgumentError('At least one breakpoint must be provided.');
    }

    _orderedBreakpoints = List<Breakpoints>.from(entries)
      ..sort((a, b) => a.width.compareTo(b.width));

    breakpoints
      ..clear()
      ..addEntries(
        _orderedBreakpoints.map(
          (breakpoint) => MapEntry(breakpoint.deviceType, breakpoint),
        ),
      );
    _lastIndex = -1; // reset cache
  }

  /// Computes and stores the [DeviceType] for a given layout width.
  ///
  /// Throws if required entries are missing from [breakpoints].
  static DeviceType setDeviceType(double width) {
    if (_orderedBreakpoints.isEmpty) {
      throw StateError('Register breakpoints before calling setDeviceType.');
    }

    // Fast path: if width is still within the cached breakpoint range, return immediately.
    if (_lastIndex >= 0 && _lastIndex < _orderedBreakpoints.length) {
      final upper = _orderedBreakpoints[_lastIndex].width;
      final lower = _lastIndex == 0
          ? double.negativeInfinity
          : _orderedBreakpoints[_lastIndex - 1].width;
      if (width <= upper && width > lower) {
        return currentDeviceType = _orderedBreakpoints[_lastIndex].deviceType;
      }

      // O(1) neighbor checks: if we've crossed at most one boundary, adjust index directly.
      if (width > upper && _lastIndex + 1 < _orderedBreakpoints.length) {
        final nextUpper = _orderedBreakpoints[_lastIndex + 1].width;
        final nextLower = upper; // boundary shared with current upper
        if (width <= nextUpper && width > nextLower) {
          _lastIndex += 1;
          return currentDeviceType = _orderedBreakpoints[_lastIndex].deviceType;
        }
      } else if (width <= lower && _lastIndex - 1 >= 0) {
        final prevUpper = _orderedBreakpoints[_lastIndex - 1].width;
        final prevLower = (_lastIndex - 1) == 0
            ? double.negativeInfinity
            : _orderedBreakpoints[_lastIndex - 2].width;
        if (width <= prevUpper && width > prevLower) {
          _lastIndex -= 1;
          return currentDeviceType = _orderedBreakpoints[_lastIndex].deviceType;
        }
      }
    }

    final len = _orderedBreakpoints.length;
    int index = len - 1;
    if (len <= 6) {
      for (var i = 0; i < len; i++) {
        if (width <= _orderedBreakpoints[i].width) {
          index = i;
          break;
        }
      }
    } else {
      index = _findBreakpointIndex(width);
    }
    _lastIndex = index; // update cache for subsequent calls
    return currentDeviceType = _orderedBreakpoints[index].deviceType;
  }

  static Breakpoints breakpointForWidth(double width) {
    // Reuse setDeviceType to benefit from O(1) cache and neighbor fast paths.
    setDeviceType(width);
    return _orderedBreakpoints[_lastIndex];
  }

  static int _findBreakpointIndex(double width) {
    var low = 0;
    var high = _orderedBreakpoints.length - 1;
    var result = high;

    while (low <= high) {
      final mid = (low + high) >> 1;
      if (width <= _orderedBreakpoints[mid].width) {
        result = mid;
        high = mid - 1;
      } else {
        low = mid + 1;
      }
    }

    return result;
  }

  /// True if [width] maps to [DeviceType.mobile].
  static bool get isMobile => currentDeviceType == DeviceType.mobile;

  /// True if [width] maps to [DeviceType.mobileSmall].
  static bool get isMobileSmall => currentDeviceType == DeviceType.mobileSmall;

  /// True if [width] maps to [DeviceType.tablet].
  static bool get isTablet => currentDeviceType == DeviceType.tablet;

  /// True if [width] maps to [DeviceType.laptop].
  static bool get isLaptop => currentDeviceType == DeviceType.laptop;

  /// True if [width] maps to [DeviceType.desktop].
  static bool get isDesktop => currentDeviceType == DeviceType.desktop;

  /// True if [width] maps to [DeviceType.desktopLarge].
  static bool get isDesktopLarge =>
      currentDeviceType == DeviceType.desktopLarge;

  /// Whether automatic scaling (via ScreenUtil) should be enabled for the
  /// current device type, as specified by the active [Breakpoints].
  static bool get isNeedScreenUtil {
    if (_lastIndex < 0 || _lastIndex >= _orderedBreakpoints.length) {
      return false;
    }
    return _orderedBreakpoints[_lastIndex].autoScale ? true : false;
  }
}
