## 0.0.3
- Resolved pub points issues (analysis clean, tightened docs/metadata).
- ...
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
