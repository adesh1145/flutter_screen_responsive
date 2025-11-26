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
  responsive: ^0.0.1
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
import 'package:responsive/responsive.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveInit(
      breakpoints: const [
        Breakpoints(
          width: 600, // up to 600 -> mobile
          deviceType: DeviceType.mobile,
          designSize: Size(375, 812),
          autoScale: true,
        ),
        Breakpoints(
          width: 1024, // 601..1024 -> tablet
          deviceType: DeviceType.tablet,
          designSize: Size(834, 1194),
          autoScale: true,
        ),
        Breakpoints(
          width: double.infinity, // 1025+ -> desktop
          deviceType: DeviceType.desktop,
          designSize: Size(1440, 1024),
          autoScale: false, // often prefer fixed pixels on desktop
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
        mobile: (_) => const _MobileView(),
        tablet: (_) => const _TabletView(),
        desktop: (_) => const _DesktopView(),
      ),
    );
  }
}
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
final device = ResponsiveUtils.getDeviceType; // DeviceType.mobile/tablet/desktop
final isTab = ResponsiveUtils.isTablet(MediaQuery.of(context).size.width);
final shouldScale = ResponsiveUtils.isNeedScreenUtil; // from active breakpoint
```

---

## API overview

- `Breakpoints` – describes width threshold, `DeviceType`, optional `designSize`, and `autoScale`.
- `DeviceType` – enum of `mobile`, `tablet`, `desktop`.
- `ResponsiveInit` – registers breakpoints and configures ScreenUtil; rebuilds when device type changes.
- `Responsive` – picks the proper builder (`mobile`/`tablet`/`desktop`) for the current width.
- `ResponsiveUtils` – helpers to read/compute active device type and decide if scaling is needed.
- `SizeExtension` – `.w`, `.h`, `.r`, `.sp`, `.spMin`, `.spMax`, and spacing getters.

---

## Notes

- Depends on `flutter_screenutil: ^5.9.3` (min Dart 2.17, Flutter 3.10).
- Put `ResponsiveInit` above your `MaterialApp`/`CupertinoApp` so ScreenUtil and MediaQuery are available.
- Provide breakpoints for all three device types to avoid nulls.

---

## License & contributing

MIT-style license (see `LICENSE`). PRs and issues are welcome.
