import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmace_emp/frontend/screens/auth/sign_up_screen.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/auth/splash_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop Screen Size & Window Configuration
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(450, 780),
      minimumSize: Size(380, 500),
      center: true,
      title: 'Pharmase Employee',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmase Employee',

      // Light Theme
      theme: AppTheme.lightTheme,

      // Dark Theme
      darkTheme: AppTheme.darkTheme,

      // Theme Mode (Light / Dark / System)
      themeMode: _themeMode,

      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),

      home: PharmaceEmpApp(
        currentThemeMode: _themeMode,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}

class PharmaceEmpApp extends StatefulWidget {
  const PharmaceEmpApp({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<PharmaceEmpApp> createState() => _PharmaceEmpAppState();
}

enum _AppView { splash, dashboard, signup }

class _PharmaceEmpAppState extends State<PharmaceEmpApp> {
  _AppView _view = _AppView.splash;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (_view) {
        _AppView.splash => SplashScreen(
            key: const ValueKey('splash'),
            onFinished: () {
              if (!mounted) return;
              setState(() {
                _view = _AppView.signup;
              });
            },
          ),
        _AppView.dashboard => _buildMainScaffold(),
      _AppView.signup => SignUpScreen(),
      },
    );
  }

  /// Main Scaffold hosting the Bottom Navigation Bar and Fragment Screens
  Widget _buildMainScaffold() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color unselectedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextTertiary;

    // ============================================================
    // PLACE FOR FUTURE FRAGMENT SCREENS
    // (Replace these placeholder widgets with your actual fragment screen widgets)
    // ============================================================
    final List<Widget> fragmentScreens = [
      // 0: Home Fragment
      _buildFragmentSlot(
        title: 'Home Fragment',
        subtitle: 'Shift Overview & Dashboard',
        icon: Icons.home_rounded,
        description:
            'Future place for Home screen, active shift notices, and quick actions.',
      ),

      // 1: Sales / Billing Fragment
      _buildFragmentSlot(
        title: 'Sales Fragment',
        subtitle: 'Point of Sale & Billing',
        icon: Icons.point_of_sale_rounded,
        description:
            'Future place for billing counter, cart items, and payment receipts.',
      ),

      // 2: Inventory Fragment
      _buildFragmentSlot(
        title: 'Inventory Fragment',
        subtitle: 'Stock & Medicine Lookup',
        icon: Icons.inventory_2_rounded,
        description:
            'Future place for medicine stock levels, batch lookup, and barcode scanner.',
      ),

      // 3: Profile Fragment
      _buildProfileFragmentSlot(isDark),
    ];

    return Scaffold(
      key: const ValueKey('dashboard'),
      body: IndexedStack(
        index: _selectedIndex,
        children: fragmentScreens,
      ),

      // ============================================================
      // BOTTOM NAVIGATION BAR
      // ============================================================
      bottomNavigationBar: SizedBox(
        height: 68,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.transparent,
            overlayColor: WidgetStateProperty.resolveWith(
              (states) => Colors.transparent,
            ),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(
                  color: AppColors.primary,
                  size: 26,
                );
              }
              return IconThemeData(color: unselectedColor, size: 24);
            }),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                );
              }
              return TextStyle(
                color: unselectedColor,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.point_of_sale_outlined),
                selectedIcon: Icon(Icons.point_of_sale_rounded),
                label: 'Sales',
              ),
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2_rounded),
                label: 'Inventory',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Template placeholder for future fragment screen integration
  Widget _buildFragmentSlot({
    required String title,
    required String subtitle,
    required IconData icon,
    required String description,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(icon, size: 38, color: AppColors.primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Profile Fragment slot with Theme Mode switcher for easy dark/light mode testing
  Widget _buildProfileFragmentSlot(bool isDark) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Employee Profile',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Place for future employee profile & account settings',
                    style: textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Theme Selector card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.palette_outlined,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Theme Preference',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text('Light'),
                              icon: Icon(Icons.light_mode_outlined),
                            ),
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text('System'),
                              icon: Icon(Icons.brightness_auto_outlined),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text('Dark'),
                              icon: Icon(Icons.dark_mode_outlined),
                            ),
                          ],
                          selected: {widget.currentThemeMode},
                          onSelectionChanged: (newSelection) {
                            widget.onThemeChanged(newSelection.first);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
