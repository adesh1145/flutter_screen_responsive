/// mobileSmall < mobile < tabletSmall < tablet < desktop < desktopLarge
enum DeviceType {
  /// Very small phones or constrained/narrow layouts.
  mobileSmall,

  /// Typical phones.
  mobile,


  /// Laptops or large portable screens.
  tabletSmall,

  /// Tablets or foldables.
  tablet,


  @Deprecated('Use [tablestSmall] instead')
  laptop,

  /// Desktop or large browser windows.
  desktop,

  /// Ultra-wide, big-screen, or TV layouts.
  desktopLarge,
}
