import 'package:flutter/material.dart';
import 'package:flutter_screen_responsive/flutter_screen_responsive.dart';

void main() => runApp(const ResponsiveExampleApp());

/// Demo application showcasing the v2 InheritedWidget-based responsive API.
///
/// Features demonstrated:
/// - `ResponsiveInit` for root breakpoint setup
/// - `context.responsive` for device type queries
/// - `scope.value()` for per-device value resolution
/// - `ResponsiveScope.overrideBreakpoints()` for local overrides
/// - `.w`, `.h`, `.sp`, spacing extensions
class ResponsiveExampleApp extends StatelessWidget {
  const ResponsiveExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveInit(
      breakpoints: _exampleBreakpoints,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Responsive Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const ResponsiveDashboard(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Breakpoint configuration
// ─────────────────────────────────────────────────────────────────────────

const List<Breakpoints> _exampleBreakpoints = [
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
];

// ─────────────────────────────────────────────────────────────────────────
// Main dashboard — uses global breakpoints
// ─────────────────────────────────────────────────────────────────────────

class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Dashboard'),
        centerTitle: false,
        actions: [
          // Navigate to a screen that overrides breakpoints locally
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OverrideExampleScreen()),
            ),
            icon: const Icon(Icons.tune, color: Colors.white),
            label: const Text(
              'Override Demo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _DashboardLayout(
        columns: scope.value(
          mobileSmall: () => 1,
          mobile: () => 1,
          tabletSmall: () => 2,
          tablet: () => 3,
          desktop: () => 4,
          desktopLarge: () => 6,
        ),
      ),
    );
  }
}

class _DashboardLayout extends StatelessWidget {
  const _DashboardLayout({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) {
    final scope = context.responsive;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Viewing on ${scope.currentDeviceType.name.toUpperCase()}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              12.h.verticalSpace,
              Text(
                'Screen: ${scope.screenSize.width.toInt()} × '
                '${scope.screenSize.height.toInt()}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                    ),
              ),
              24.h.verticalSpace,
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: scope.value(
                      mobile: () => 1.2,
                      desktop: () => 1.4,
                    ),
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) =>
                      _DashboardCard(_cards[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Override example — demonstrates ResponsiveScope.overrideBreakpoints()
// ─────────────────────────────────────────────────────────────────────────

/// This screen wraps its content with [ResponsiveScope.overrideBreakpoints],
/// using different breakpoints than the root. This shows the CSS-like
/// override feature.
class OverrideExampleScreen extends StatelessWidget {
  const OverrideExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Override Demo')),
      body: ResponsiveScope.overrideBreakpoints(
        breakpoints: const [
          // Use only 2 breakpoints: mobile + desktop
          // Mobile up to 800px, desktop for everything larger
          Breakpoints(
            width: 800,
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
        child: Builder(
          builder: (context) {
            final scope = context.responsive;
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      scope.isMobile ? Icons.phone_android : Icons.desktop_mac,
                      size: 64.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    24.h.verticalSpace,
                    Text(
                      'Local device type: ${scope.currentDeviceType.name}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    12.h.verticalSpace,
                    Text(
                      'This screen uses DIFFERENT breakpoints.\n'
                      'Mobile ≤ 800px, Desktop > 800px.\n'
                      'The parent dashboard uses 6 breakpoints.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Dashboard card widget
// ─────────────────────────────────────────────────────────────────────────

class _DashboardCard extends StatelessWidget {
  const _DashboardCard(this.card);

  final _InfoCard card;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(card.icon, size: 32.sp, color: card.color),
            12.h.verticalSpace,
            Text(
              card.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            8.h.verticalSpace,
            Text(
              card.subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.spMin,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const Spacer(),
            Text(
              card.value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 28.spMax,
                    fontWeight: FontWeight.bold,
                    color: card.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Data
// ─────────────────────────────────────────────────────────────────────────

class _InfoCard {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final Color color;
}

const List<_InfoCard> _cards = [
  _InfoCard(
    icon: Icons.bar_chart_rounded,
    title: 'Sales',
    subtitle: 'This quarter vs previous quarter',
    value: '+18%',
    color: Colors.teal,
  ),
  _InfoCard(
    icon: Icons.shopping_cart_outlined,
    title: 'Orders',
    subtitle: 'Completed purchases today',
    value: '264',
    color: Colors.indigo,
  ),
  _InfoCard(
    icon: Icons.person_outline,
    title: 'Active users',
    subtitle: 'Currently browsing sessions',
    value: '1,482',
    color: Colors.deepOrange,
  ),
  _InfoCard(
    icon: Icons.support_agent_outlined,
    title: 'Support tickets',
    subtitle: 'Awaiting response right now',
    value: '34',
    color: Colors.purple,
  ),
  _InfoCard(
    icon: Icons.thumb_up_alt_outlined,
    title: 'Feedback',
    subtitle: 'Positive ratings this week',
    value: '92%',
    color: Colors.green,
  ),
  _InfoCard(
    icon: Icons.schedule_outlined,
    title: 'Avg. session',
    subtitle: 'Minutes per user session',
    value: '7m 12s',
    color: Colors.blueGrey,
  ),
];
