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
  final Widget Function(BoxConstraints constraints)? mobile;

  /// Builder for medium screens (tablets/foldables).
  final Widget Function(BoxConstraints constraints)? tablet;

  /// Builder for large screens (desktop/web).
  final Widget Function(BoxConstraints constraints)? desktop;

  const Responsive({super.key, this.mobile, this.tablet, this.desktop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final deviceType = ResponsiveUtils.setDeviceType(width);

        switch (deviceType) {
          case DeviceType.desktop:
            return desktop?.call(constraints) ?? const SizedBox.shrink();
          case DeviceType.tablet:
            return tablet?.call(constraints) ??
                desktop?.call(constraints) ??
                const SizedBox.shrink();
          default:
            return mobile?.call(constraints) ??
                tablet?.call(constraints) ??
                desktop?.call(constraints) ??
                const SizedBox.shrink();
        }
      },
    );
  }
}
