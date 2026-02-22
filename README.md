# flutter_screen_responsive

Build truly responsive Flutter UIs with configurable breakpoints, **InheritedWidget-based scope**, and ScreenUtil-powered scaling. This package lets you:

- define breakpoints for mobile, tablet, desktop (and more)
- **override breakpoints locally** in any subtree — like CSS `@media` overrides
- automatically (re)configure ScreenUtil when device type changes
- use ergonomic sizing/spacing extensions like `16.w`, `14.sp`, `8.h.verticalSpace`
- access the current scope via `context.responsive`

---

## What's new in v1.0.0

> **Breaking:** The entire API has been rebuilt on `InheritedWidget` (`ResponsiveScope`). The old v1 API (`ResponsiveUtils`, `Responsive` widget) is moved to a separate legacy import and marked `@Deprecated`. See [Migration from v0.x](#migration-from-v0x).

**Key improvement:** You can now **override breakpoints, scaling, and design sizes for specific screens or subtrees** — something impossible with the old global-state approach.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_screen_responsive: ^1.0.0
```

```bash
flutter pub get
```

---

## Getting started

### 1. Define breakpoints & wrap your app

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screen_responsive/flutter_screen_responsive.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveInit(
      breakpoints: const [
        Breakpoints(
          width: 360,
          deviceType: DeviceType.mobileSmall,
          designSize: Size(320, 568),
        ),
        Breakpoints(
          width: 600,
          deviceType: DeviceType.mobile,
          designSize: Size(375, 812),
        ),
        Breakpoints(
          width: 900,
          deviceType: DeviceType.tabletSmall,
          designSize: Size(600, 960),
        ),
        Breakpoints(
          width: 1200,
          deviceType: DeviceType.tablet,
          designSize: Size(834, 1194),
        ),
        Breakpoints(
          width: 1600,
          deviceType: DeviceType.desktop,
          designSize: Size(1440, 1024),
          autoScale: false,
        ),
        Breakpoints(
          width: double.infinity,
          deviceType: DeviceType.desktopLarge,
          designSize: Size(1920, 1080),
          autoScale: false,
        ),
      ],
      builder: (context, child) => MaterialApp(
        title: 'My App',
        home: const HomePage(),
      ),
    );
  }
}
```

### 2. Use `context.responsive` anywhere

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = context.responsive;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(scope.value(
          mobile: () => 16.0,
          tablet: () => 24.0,
          desktop: () => 32.0,
        )),
        child: Text(
          'Device: ${scope.currentDeviceType.name}',
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
    );
  }
}
```

---

## Local breakpoint overrides (CSS-like)

The **killer feature** — override breakpoints for a specific subtree:

```dart
// Root defines default breakpoints via ResponsiveInit.
// A specific screen can override them:
ResponsiveScope.overrideBreakpoints(
  breakpoints: [
    Breakpoints(
      width: 600,
      deviceType: DeviceType.mobile,
      designSize: Size(375, 812),
      autoScale: true,
    ),
    Breakpoints(
      width: double.infinity,
      deviceType: DeviceType.desktop,
      designSize: Size(1440, 900),
      autoScale: false,
    ),
  ],
  child: MySpecificScreen(),
)
```

Inside `MySpecificScreen`, `context.responsive` uses the **local** breakpoints — not the global ones. `.w`, `.h`, `.sp` extensions automatically use the local `ScreenUtil` config. This is similar to how CSS works — define defaults at root, override at any level.

---

## Pick values per device

Use the lazy `scope.value<T>()` resolver — only the matched device type's builder runs:

```dart
final columns = context.responsive.value(
  mobileSmall: () => 1,
  mobile: () => 2,
  tabletSmall: () => 2,
  tablet: () => 3,
  desktop: () => 4,
  desktopLarge: () => 6,
);
```

Fallback order: `desktopLarge → desktop → tablet → tabletSmall → mobile → mobileSmall`. You only need to provide the values that differ.

---

## Device type checks

```dart
final scope = context.responsive;

if (scope.isMobile) { ... }
if (scope.isTablet) { ... }
if (scope.isDesktop) { ... }
if (scope.isMobileSmall) { ... }
if (scope.isTabletSmall) { ... }
if (scope.isDesktopLarge) { ... }

// Access directly
scope.currentDeviceType  // DeviceType.mobile, etc.
scope.screenSize         // Size from MediaQuery
```

---

## Sizing & spacing extensions

```dart
// Sizes (scaled by ScreenUtil based on active breakpoint)
final w = 16.w;    // width
final h = 24.h;    // height
final r = 12.r;    // radius
final sp = 14.sp;  // font size

// Clamped font sizes
final label = 12.spMin;  // never larger than 12
final title = 18.spMax;  // never smaller than 18

// Spacers
16.h.verticalSpace;    // SizedBox(height: ...)
24.w.horizontalSpace;  // SizedBox(width: ...)

// Screen fractions
0.5.sw  // 50% of screen width
0.3.sh  // 30% of screen height
```

---

## API overview

| Class / Extension | Description |
|---|---|
| `ResponsiveInit` | Top-level widget — configures breakpoints + ScreenUtil + ResponsiveScope |
| `ResponsiveScope` | InheritedWidget carrying device type & screen size; supports `.overrideBreakpoints()` |
| `Breakpoints` | Width threshold + DeviceType + optional designSize + autoScale flag |
| `DeviceType` | Enum: `mobileSmall`, `mobile`, `tabletSmall`, `tablet`, `desktop`, `desktopLarge` |
| `ResponsiveBreakpointConfig` | Breakpoint map with `resolveDeviceType(width)` resolver |
| `SizeExtension` | `.w`, `.h`, `.r`, `.sp`, `.spMin`, `.spMax`, spacing getters on `num` |
| `ResponsiveScopeExtension` | `context.responsive` accessor |

---

## Migration from v0.x

| v0.x (deprecated) | v1.0 (new) |
|---|---|
| `ResponsiveUtils.isMobile` | `context.responsive.isMobile` |
| `ResponsiveUtils.value<T>(mobile: x)` | `context.responsive.value(mobile: () => x)` |
| `ResponsiveUtils.getDeviceType` | `context.responsive.currentDeviceType` |
| `Responsive(mobile: (c) => ...)` | `context.responsive.value(mobile: () => ...)` |

The deprecated v1 API is still available via:

```dart
import 'package:flutter_screen_responsive/flutter_screen_responsive_legacy.dart';
```

---

## Notes

- Depends on `flutter_screenutil: ^5.9.3` (min Dart 2.17, Flutter 3.10).
- Place `ResponsiveInit` above your `MaterialApp`/`CupertinoApp`.
- Provide breakpoints sorted by ascending width; the last one typically uses `double.infinity`.

---

## License & contributing

MIT license (see `LICENSE`). PRs and issues are welcome.
