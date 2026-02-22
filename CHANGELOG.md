## 1.0.0

**Breaking:** Complete architecture rewrite — InheritedWidget-based `ResponsiveScope`.

### New features
- **`ResponsiveScope` (InheritedWidget):** Carries device type and screen size down the widget tree.
- **Local breakpoint overrides:** `ResponsiveScope.overrideBreakpoints()` lets you override breakpoints, scaling, and design sizes for any subtree — like CSS `@media` overrides.
- **`context.responsive` accessor:** Access the nearest scope from any widget via `BuildContext`.
- **Lazy `value<T>()` resolver:** Only the matched device type's builder gets called.
- **New file structure:** All new code in `lib/src/v2/`, old code moved to `lib/src/v1/`.

### Deprecated
- **All v1 APIs marked `@Deprecated`:** `ResponsiveUtils`, `Responsive` widget, `RPadding`, `RSizedBox`, old `SizeExtension`, old `ResponsiveInit`.
- **Legacy import available:** `import 'package:flutter_screen_responsive/flutter_screen_responsive_legacy.dart';`

### Migration
- `ResponsiveUtils.isMobile` → `context.responsive.isMobile`
- `ResponsiveUtils.value<T>(mobile: x)` → `context.responsive.value(mobile: () => x)`
- `Responsive(mobile: (c) => widget)` → `context.responsive.value(mobile: () => widget)`

---

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
