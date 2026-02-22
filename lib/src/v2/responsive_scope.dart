import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'breakpoints.dart';
import 'device_type.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ResponsiveScope — carries deviceType + screenSize down the widget tree.
// ═══════════════════════════════════════════════════════════════════════════

/// InheritedWidget that carries the CURRENT (local) breakpoint state
/// down the widget tree.
///
/// Use [ResponsiveScope.of] to access the nearest scope — this
/// **respects local overrides** set via [overrideBreakpoints].
///
/// ```dart
/// final scope = ResponsiveScope.of(context);
/// // or via extension:
/// final scope = context.responsive;
///
/// if (scope.isMobile) { ... }
/// final padding = scope.value(mobile: () => 8.0, desktop: () => 24.0);
/// ```
class ResponsiveScope extends InheritedWidget {
  /// The resolved device type for this scope.
  final DeviceType currentDeviceType;

  /// The actual screen size (from [MediaQuery]).
  final Size screenSize;

  const ResponsiveScope({
    super.key,
    required this.currentDeviceType,
    required this.screenSize,
    required super.child,
  });

  /// Nearest scope — respects local overrides.
  ///
  /// Throws if no [ResponsiveScope] is found in the widget tree.
  /// Wrap your app with [ResponsiveInit] to ensure a scope is always present.
  static ResponsiveScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(
      scope != null,
      'No ResponsiveScope found. Wrap your app with ResponsiveInit.',
    );
    return scope!;
  }

  /// Returns the nearest [ResponsiveScope], or `null` if none exists.
  static ResponsiveScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ResponsiveScope>();

  @override
  bool updateShouldNotify(ResponsiveScope old) =>
      currentDeviceType != old.currentDeviceType ||
      screenSize != old.screenSize;

  // ─────────────────────────────────────────────────────────────────────────
  // Instance members — use via `context.responsive.xxx`
  // Respects local [overrideBreakpoints] automatically.
  // ─────────────────────────────────────────────────────────────────────────

  /// True when the current scope resolves to [DeviceType.mobileSmall].
  bool get isMobileSmall => currentDeviceType == DeviceType.mobileSmall;

  /// True when the current scope resolves to [DeviceType.mobile].
  bool get isMobile => currentDeviceType == DeviceType.mobile;

  /// True when the current scope resolves to [DeviceType.tabletSmall].
  bool get isTabletSmall => currentDeviceType == DeviceType.tabletSmall;

  /// True when the current scope resolves to [DeviceType.tablet].
  bool get isTablet => currentDeviceType == DeviceType.tablet;

  /// True when the current scope resolves to [DeviceType.desktop].
  bool get isDesktop => currentDeviceType == DeviceType.desktop;

  /// True when the current scope resolves to [DeviceType.desktopLarge].
  bool get isDesktopLarge => currentDeviceType == DeviceType.desktopLarge;

  /// Lazy value resolver — respects local overrides.
  ///
  /// Only the matched device type's builder is called (lazy evaluation).
  /// Fallback order mirrors the device size hierarchy: larger devices
  /// fall back towards smaller, smaller devices fall back towards larger.
  ///
  /// ```dart
  /// context.responsive.value(
  ///   mobile: () => 12.0,
  ///   desktop: () => 24.0,
  /// )
  /// context.responsive.value(
  ///   mobile: () => MobileWidget(),
  ///   desktop: () => DesktopWidget(),
  /// )
  /// ```
  T value<T>({
    T Function()? mobileSmall,
    T Function()? mobile,
    T Function()? tabletSmall,
    T Function()? tablet,
    T Function()? desktop,
    T Function()? desktopLarge,
  }) {
    assert(
      mobileSmall != null ||
          mobile != null ||
          tabletSmall != null ||
          tablet != null ||
          desktop != null ||
          desktopLarge != null,
      'ResponsiveScope.value() requires at least one of '
      'mobileSmall, mobile, tabletSmall, tablet, desktop, or desktopLarge.',
    );
    final type = currentDeviceType;
    // ignore: deprecated_member_use_from_same_package
    if (type == DeviceType.desktopLarge) {
      return (desktopLarge ??
          desktop ??
          tablet ??
          tabletSmall ??
          mobile ??
          mobileSmall)!();
    } else if (type == DeviceType.desktop) {
      return (desktop ?? tablet ?? tabletSmall ?? mobile ?? mobileSmall)!();
    } else if (type == DeviceType.tablet) {
      return (tablet ?? tabletSmall ?? mobile ?? mobileSmall)!();
      // ignore: deprecated_member_use_from_same_package
    } else if (type == DeviceType.tabletSmall || type == DeviceType.laptop) {
      return (tabletSmall ?? mobile ?? mobileSmall)!();
    } else if (type == DeviceType.mobile) {
      return (mobile ?? mobileSmall)!();
    } else {
      // DeviceType.mobileSmall or any unrecognized value
      return (mobileSmall ?? mobile)!();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Static helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Override breakpoints for a subtree.
  ///
  /// `autoScale` and `designSize` from each breakpoint are applied
  /// **automatically** — no manual wrapping needed.
  ///
  /// This is the CSS-like local override mechanism. The parent scope's
  /// `screenSize` is reused; only device-type resolution and
  /// ScreenUtil config change.
  ///
  /// ```dart
  /// ResponsiveScope.overrideBreakpoints(
  ///   breakpoints: [
  ///     Breakpoints(width: 450, deviceType: DeviceType.mobile,
  ///                 designSize: Size(375, 812), autoScale: true),
  ///     Breakpoints(width: double.infinity, deviceType: DeviceType.desktop,
  ///                 designSize: Size(1440, 900), autoScale: false),
  ///   ],
  ///   child: MyWidget(),
  /// )
  /// ```
  static Widget overrideBreakpoints({
    required List<Breakpoints> breakpoints,
    required Widget child,
  }) =>
      _ResponsiveScopeOverride(breakpoints: breakpoints, child: child);
}

// ─────────────────────────────────────────────────────────────────────────
// _ResponsiveScopeOverride — local breakpoint + autoScale + designSize,
// all resolved and applied directly. No intermediate helper class.
// ─────────────────────────────────────────────────────────────────────────

class _ResponsiveScopeOverride extends StatefulWidget {
  const _ResponsiveScopeOverride({
    required this.breakpoints,
    required this.child,
  });

  final List<Breakpoints> breakpoints;
  final Widget child;

  @override
  State<_ResponsiveScopeOverride> createState() =>
      _ResponsiveScopeOverrideState();
}

class _ResponsiveScopeOverrideState extends State<_ResponsiveScopeOverride> {
  late ResponsiveBreakpointConfig _localConfig;

  @override
  void initState() {
    super.initState();
    _localConfig = ResponsiveBreakpointConfig.fromList(widget.breakpoints);
  }

  @override
  void didUpdateWidget(_ResponsiveScopeOverride oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.breakpoints, oldWidget.breakpoints)) {
      _localConfig = ResponsiveBreakpointConfig.fromList(widget.breakpoints);
    }
  }

  @override
  Widget build(BuildContext context) {
    final parent = ResponsiveScope.of(context);
    final localDeviceType = _localConfig.resolveDeviceType(
      parent.screenSize.width,
    );
    final localBreakpoint = _localConfig[localDeviceType];
    final autoScale = localBreakpoint?.autoScale ?? true;

    // Local designSize used when autoScale:true — gives correct scale ratio.
    // When autoScale:false, designSize irrelevant → use screenSize (ratio=1.0).
    final designSize = autoScale
        ? (localBreakpoint?.designSize ??
            Size(ScreenUtil().screenWidth, ScreenUtil().screenHeight))
        : Size(ScreenUtil().screenWidth, ScreenUtil().screenHeight);

    // ScreenUtilInit is ALWAYS present in tree (stable structure — no state loss).
    // key: ValueKey((autoScale, designSize)) forces it to recreate ONLY when
    // autoScale or designSize changes. widget.child state is preserved. ✅
    //
    // WHY ScreenUtilInit (not a custom InheritedWidget)?
    //   .w / .h / .sp are on `num` — no BuildContext → can't read InheritedWidget.
    //   ScreenUtilInit is the only way to control ScreenUtil scale for a subtree.
    return ScreenUtilInit(
      key: ValueKey('$autoScale-${designSize.width}-${designSize.height}'),
      designSize: designSize,
      enableScaleWH: () => autoScale,
      enableScaleText: () => autoScale,
      useInheritedMediaQuery: true,
      builder: (_, __) => ResponsiveScope(
        currentDeviceType: localDeviceType,
        screenSize: parent.screenSize,
        child: widget.child,
      ),
    );
  }
}
