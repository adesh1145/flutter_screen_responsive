
import 'package:flutter/material.dart';
import 'responsive_utils.dart';
import 'device_type.dart';

/// Layout builder that chooses the appropriate UI for the active [DeviceType].
///
/// It evaluates the current width via [ResponsiveUtils.setDeviceType] and then
/// calls one of the provided builders. Fallback order when a builder is null:
/// `mobile -> tablet -> desktop`.

class Responsive extends StatelessWidget {
  /// Builder for small screens (phones).
  final Widget Function(BoxConstraints constraints)? mobileSmall;
  final Widget Function(BoxConstraints constraints)? mobile;

  /// Builder for medium screens (tablets/foldables).
  final Widget Function(BoxConstraints constraints)? tabletSmall;
  final Widget Function(BoxConstraints constraints)? tablet;

  /// Builder for large screens (desktop/web).
  final Widget Function(BoxConstraints constraints)? desktop;
  final Widget Function(BoxConstraints constraints)? desktopLarge;

  const Responsive(
      {super.key,
      this.mobileSmall,
      this.mobile,
      this.tabletSmall,
      this.tablet,
      this.desktop,
      this.desktopLarge});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType;

        switch (deviceType) {
          case DeviceType.desktopLarge:
            return desktopLarge?.call(constraints) ??
                desktop?.call(constraints) ??
                tablet?.call(constraints) ??
                tabletSmall?.call(constraints) ??
                mobile?.call(constraints) ??
                mobileSmall?.call(constraints) ??
                const SizedBox.shrink();
          case DeviceType.desktop:
            return desktop?.call(constraints) ??
                tablet?.call(constraints) ??
                tabletSmall?.call(constraints) ??
                mobile?.call(constraints) ??
                mobileSmall?.call(constraints) ??
                const SizedBox.shrink();

          case DeviceType.tablet:
            return tablet?.call(constraints) ??
                tabletSmall?.call(constraints) ??
                mobile?.call(constraints) ??
                mobileSmall?.call(constraints) ??
                const SizedBox.shrink();
          case DeviceType.tabletSmall:
            return tabletSmall?.call(constraints) ??
                mobile?.call(constraints) ??
                mobileSmall?.call(constraints) ??
                const SizedBox.shrink();

          case DeviceType.mobile:
            return mobile?.call(constraints) ??
                mobileSmall?.call(constraints) ??
                const SizedBox.shrink();
          default:
            return mobileSmall?.call(constraints) ?? const SizedBox.shrink();
        }
      },
    );
  }
}
