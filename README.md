## flutter_screen_responsive

Build truly responsive Flutter UIs with configurable breakpoints and ScreenUtil-powered scaling. This package lets you:

- declare dedicated layouts for mobile, tablet, and desktop
- centralize breakpoint rules and design sizes
- automatically (re)configure ScreenUtil when device type changes
- use ergonomic sizing and spacing extensions like `16.w`, `14.sp`, `8.h.verticalSpace`

---

## Features

- Breakpoint-aware layout builder via `Responsive` (mobile/tablet/desktop builders)
- Top-level initializer `ResponsiveInit` that registers your `Breakpoints` and wires up `flutter_screenutil`
- Automatic ScreenUtil re-init when device type changes (keeps scaling accurate)
- Rich sizing/spacing extensions on `num`: `.w`, `.h`, `.sp`, `.spMin`, `.spMax`, `.verticalSpace`, `.horizontalSpace`, etc.
- Utilities to check the active device type (`ResponsiveUtils`)

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_screen_responsive: ^0.0.3
```

Minimum supported versions (because of `flutter_screenutil: ^5.9.3`):

```yaml
environment:
  sdk: ">=2.17.0 <4.0.0"
  flutter: ">=3.10.0"
```

Run:

```bash
flutter pub get
```

---

## Getting started

1. Define your breakpoints (width threshold, device type, design size, and whether to auto-scale).
2. Wrap your app with `ResponsiveInit` so ScreenUtil and breakpoints are available everywhere.

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
          width: 360, // <=360 -> mobileSmall
          deviceType: DeviceType.mobileSmall,
          designSize: Size(320, 568),
          autoScale: true,
        ),
        Breakpoints(
          width: 600, // 361..600 -> mobile
          deviceType: DeviceType.mobile,
          designSize: Size(375, 812),
          autoScale: true,
        ),
        Breakpoints(
          width: 900, // 601..900 -> tabletSmall
          deviceType: DeviceType.tabletSmall,
          designSize: Size(600, 960),
          autoScale: true,
        ),
        Breakpoints(
          width: 1200, // 901..1200 -> tablet
          deviceType: DeviceType.tablet,
          designSize: Size(834, 1194),
          autoScale: true,
        ),
        Breakpoints(
          width: 1600, // 1201..1600 -> desktop
          deviceType: DeviceType.desktop,
          designSize: Size(1440, 1024),
          autoScale: false,
        ),
        Breakpoints(
          width: double.infinity, // 1601+ -> desktopLarge
          deviceType: DeviceType.desktopLarge,
          designSize: Size(1920, 1080),
          autoScale: false,
        ),
      ],
      builder: (context, child) => MaterialApp(
        title: 'Responsive Demo',
        home: const HomePage(),
      ),
    );
  }
}
```

---

## Usage: choose layout per device

Render different trees for each device type with the `Responsive` widget.

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobileSmall: (_) => const _MobileSmallView(),
        mobile: (_) => const _MobileView(),
        tabletSmall: (_) => const _TabletSmallView(),
        tablet: (_) => const _TabletView(),
        desktop: (_) => const _DesktopView(),
        desktopLarge: (_) => const _DesktopLargeView(),
      ),
    );
  }
}
```

### Pick values per device at runtime

Use `ResponsiveUtils.value<T>()` to select configuration values with the same fallback order used by `Responsive` (desktopLarge → desktop → tablet → tabletSmall → mobile → mobileSmall):

```dart
final columns = ResponsiveUtils.value<int>(
  desktopLarge: 5,
  desktop: 4,
  tablet: 3,
  tabletSmall: 2,
  mobile: 2,
  mobileSmall: 1,
);

final padding = EdgeInsets.symmetric(
  horizontal: ResponsiveUtils.value<double>(
    desktop: 32,
    tablet: 24,
    mobile: 16,
    mobileSmall: 12,
  ),
);
```

---

## Sizing & spacing helpers (extensions)

Use the `SizeExtension` methods on `num` to scale values safely. Scaling only applies when the active breakpoint’s `autoScale` is true.

```dart
// Sizes
final w = 16.w;   // width based on ScreenUtil
final h = 24.h;   // height based on ScreenUtil
final r = 12.r;   // radius
final sp = 14.sp; // font size

// Minimum / Maximum font sizes
final label = 12.spMin; // never larger than 12
final title = 18.spMax; // never smaller than 18

// Spacers
16.h.verticalSpace;   // SizedBox(height: ...)
24.w.horizontalSpace; // SizedBox(width: ...)
```

---

## Utilities

```dart
final device = ResponsiveUtils.getDeviceType; // DeviceType.*
final isMobileSmall = ResponsiveUtils.isMobileSmall;
final isMobile = ResponsiveUtils.isMobile;
final isTabletSmall = ResponsiveUtils.isTabletSmall;
final isTablet = ResponsiveUtils.isTablet;
final isDesktop = ResponsiveUtils.isDesktop;
final isDesktopLarge = ResponsiveUtils.isDesktopLarge;
final shouldScale = ResponsiveUtils.isNeedScreenUtil; // from active breakpoint
```

---

## API overview

- `Breakpoints` – describes width threshold, `DeviceType`, optional `designSize`, and `autoScale`.
- `DeviceType` – defaults include `mobileSmall`, `mobile`, `tabletSmall`, `tablet`, `desktop`, `desktopLarge`.
- `ResponsiveInit` – registers breakpoints and configures ScreenUtil; rebuilds when device type changes.
- `Responsive` – picks the proper builder for the current width (supports all device types above).
- `ResponsiveUtils` – helpers to read/compute active device type, `.value<T>()` to pick values by device, and `isNeedScreenUtil`.
- `SizeExtension` – `.w`, `.h`, `.r`, `.sp`, `.spMin`, `.spMax`, and spacing getters.
- Widgets: `RPadding`, `RSizedBox`.

---

## Notes

- Depends on `flutter_screenutil: ^5.9.3` (min Dart 2.17, Flutter 3.10).
- Put `ResponsiveInit` above your `MaterialApp`/`CupertinoApp` so ScreenUtil and MediaQuery are available.
- Provide breakpoints for all three device types to avoid nulls.

---

## License & contributing

MIT-style license (see `LICENSE`). PRs and issues are welcome.
