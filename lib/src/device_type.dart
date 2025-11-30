/// Device classification used to choose layouts and scaling.
///
/// Defaults provided by this package (you can map any widths to these):
/// - `mobileSmall`: very small phones/narrow devices
/// - `mobile`: phones
/// - `tablet`: tablets/foldables
/// - `laptop`: large portable screens
/// - `desktop`: desktop/web windows
/// - `desktopLarge`: ultra-wide/large desktop/TV
enum DeviceType {
  /// Very small phones or constrained/narrow layouts.
  mobileSmall,

  /// Typical phones.
  mobile,

  /// Tablets or foldables.
  tablet,

  /// Laptops or large portable screens.
  laptop,

  /// Desktop or large browser windows.
  desktop,

  /// Ultra-wide, big-screen, or TV layouts.
  desktopLarge,
}
