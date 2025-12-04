## 0.0.6
- Add `DeviceType.tabletSmall` and align enum order: `mobileSmall < mobile < tabletSmall < tablet < desktop < desktopLarge`.
- Responsive: add builders `mobileSmall`, `tabletSmall`, `desktopLarge` and implement full switch-based fallbacks.
- ResponsiveUtils:
  - add `isTabletSmall` getter
  - simplify `.value<T>()` to a switch with the same fallbacks as `Responsive`
- README: update device types, examples, and add `.value<T>()` usage.
## 0.0.5
- Resolved pub points issues (analysis clean, tightened docs/metadata).

## 0.0.3
- Added additional default `DeviceType`s: `mobileSmall`, `laptop`, `desktopLarge`.
- Optimized breakpoint selection in `ResponsiveUtils`:
  - ordered breakpoint list with cached last index
  - O(1) fast path and neighbor hop, small-N scan, O(log n) fallback
  - added `breakpointForWidth(width)` to get the exact active breakpoint
- Resolved extension conflicts with `flutter_screenutil` by aliasing to `su` and hiding its extension symbols.
- Documentation: improved docs in `src/extension.dart`, `src/init.dart`, and `src/device_type.dart`.
- New adaptive widgets added: `RPadding`, `RSizedBox`.

## 0.0.2
- Updated README.md documentation
