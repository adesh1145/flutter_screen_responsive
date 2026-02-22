/// mobileSmall < mobile < tabletSmall < tablet < desktop < desktopLarge
///
/// Device type classification for responsive breakpoints.
/// Used by [ResponsiveScope] to determine which layout/scaling to apply.
enum DeviceType {
  /// Very small phones or constrained/narrow layouts.
  mobileSmall,

  /// Typical phones.
  mobile,

  /// Laptops or large portable screens.
  tabletSmall,

  /// Tablets or foldables.
  tablet,

  @Deprecated('Use [tabletSmall] instead')
  laptop,

  /// Desktop or large browser windows.
  desktop,

  /// Ultra-wide, big-screen, or TV layouts.
  desktopLarge,
}
