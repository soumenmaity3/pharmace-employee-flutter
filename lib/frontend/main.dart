import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pharmace_emp/frontend/provider/app_view_provider.dart';
import 'package:pharmace_emp/frontend/provider/employee_provider.dart';
import 'package:pharmace_emp/frontend/screens/auth/login_screen.dart';
import 'package:pharmace_emp/frontend/screens/auth/sign_up_screen.dart';
import 'package:pharmace_emp/frontend/widgets/bottom_nav/nave_item.dart';
import 'package:window_manager/window_manager.dart';

import '../backend/auth/secure_storage_service.dart';
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
      home: ProviderScope(
        child: PharmaceEmpApp(
          currentThemeMode: _themeMode,
          onThemeChanged: toggleTheme,
        ),
      ),
    );
  }
}

class PharmaceEmpApp extends ConsumerStatefulWidget {
  const PharmaceEmpApp({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  ConsumerState<PharmaceEmpApp> createState() => _PharmaceEmpAppState();
}

class _PharmaceEmpAppState extends ConsumerState<PharmaceEmpApp> {
  int _selectedIndex = 0;

  static Future<bool> _isTokenExpired() async {
    final token = await SecureStorageService.getToken();
    if (token == null || token.isEmpty) {
      return true;
    }
    try {
      return JwtDecoder.isExpired(token);
    } catch (_) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (ref.watch(appViewProvider)) {
        AppView.splash => SplashScreen(
          key: const ValueKey('splash'),
          onFinished: () async {
            final isExpired = await _isTokenExpired();
            if (isExpired) {
              if (!mounted) return;
              setState(() {
                _selectedIndex = 0;
              });
              ref.read(appViewProvider.notifier).state = AppView.login;
              return;
            }
            if (!mounted) return;
            setState(() {
              ref.read(appViewProvider.notifier).state = AppView.dashboard;
            });
          },
        ),

        AppView.login => LoginScreen(
          onCreateAccount: () {},
          onSignUp: () {
            ref.read(appViewProvider.notifier).state = AppView.signup;
          },
          onLogin: () {
            setState(() {
              _selectedIndex = 0;
            });
            ref.read(appViewProvider.notifier).state = AppView.dashboard;
          },
        ),
        AppView.signup => SignUpScreen(
          onSignIn: () {
            ref.read(appViewProvider.notifier).state = AppView.login;
          },
        ),
        AppView.dashboard => _buildMainScaffold(),
      },
    );
  }

  UserRole _roleFromString(String? role) {
    switch (role?.trim().toLowerCase()) {
      case 'manager':
        return UserRole.manager;
      case 'pharmacist':
        return UserRole.pharmacist;
      case 'cashier':
        return UserRole.cashier;
      case 'staff':
        return UserRole.staff;
      default:
        return UserRole.manager; // Change to your preferred fallback.
    }
  }

  /// Main Scaffold hosting the Bottom Navigation Bar and Fragment Screens
  // Widget _buildMainScaffold() {
  //   final bool isDark = Theme.of(context).brightness == Brightness.dark;
  //   final Color unselectedColor = isDark
  //       ? AppColors.darkTextSecondary
  //       : AppColors.lightTextTertiary;
  //   final List<Widget> fragmentScreens = [
  //     ManHomeScreen(),
  //     SalesScreen(),
  //     ManInventoryScreen(),
  //     ManTeamScreen(),
  //     ProfileScreen(),
  //   ];
  //
  //   return Scaffold(
  //     key: const ValueKey('dashboard'),
  //     body: IndexedStack(index: _selectedIndex, children: fragmentScreens),
  //     bottomNavigationBar: SizedBox(
  //       height: 68,
  //       child: NavigationBarTheme(
  //         data: NavigationBarThemeData(
  //           indicatorColor: Colors.transparent,
  //           overlayColor: WidgetStateProperty.resolveWith(
  //             (states) => Colors.transparent,
  //           ),
  //           iconTheme: WidgetStateProperty.resolveWith((states) {
  //             if (states.contains(WidgetState.selected)) {
  //               return const IconThemeData(color: AppColors.primary, size: 26);
  //             }
  //             return IconThemeData(color: unselectedColor, size: 24);
  //           }),
  //           labelTextStyle: WidgetStateProperty.resolveWith((states) {
  //             if (states.contains(WidgetState.selected)) {
  //               return const TextStyle(
  //                 color: AppColors.primary,
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w600,
  //               );
  //             }
  //             return TextStyle(
  //               color: unselectedColor,
  //               fontSize: 12,
  //               fontWeight: FontWeight.normal,
  //             );
  //           }),
  //         ),
  //         child: NavigationBar(
  //           selectedIndex: _selectedIndex,
  //           onDestinationSelected: (index) {
  //             setState(() {
  //               _selectedIndex = index;
  //             });
  //           },
  //           destinations: const [
  //             NavigationDestination(
  //               icon: Icon(Icons.home_outlined),
  //               selectedIcon: Icon(Icons.home_rounded),
  //               label: 'Home',
  //             ),
  //             NavigationDestination(
  //               icon: Icon(Icons.point_of_sale_outlined),
  //               selectedIcon: Icon(Icons.point_of_sale_rounded),
  //               label: 'Sales',
  //             ),
  //             NavigationDestination(
  //               icon: FaIcon(FontAwesomeIcons.barsStaggered),
  //               selectedIcon: FaIcon(FontAwesomeIcons.barsStaggered),
  //               label: 'Inventory',
  //             ),
  //             NavigationDestination(
  //               icon: Icon(Icons.people_alt_outlined),
  //               selectedIcon: Icon(Icons.people_alt),
  //               label: 'Employees',
  //             ),
  //             NavigationDestination(
  //               icon: Icon(Icons.person_outline_rounded),
  //               selectedIcon: Icon(Icons.person_rounded),
  //               label: 'Profile',
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildMainScaffold() {
    final employeeState = ref.watch(employeeProvider);

    return employeeState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => const Scaffold(
        body: Center(child: Text('Unable to load employee profile.')),
      ),
      data: (employee) {
        if (employee?.body == null) {
          return const Scaffold(
            body: Center(child: Text('Employee profile not found.')),
          );
        }

        final role = _roleFromString(employee!.body!.role);
        final items = navItemsForRole(role,ref,context);

        // Keep the selected index within the available destinations.
        final selectedIndex = _selectedIndex < items.length
            ? _selectedIndex
            : 0;

        return Scaffold(
          key: const ValueKey('dashboard'),

          // Keep destination screens alive while switching tabs.
          body: IndexedStack(
            index: selectedIndex,
            children: items.map((item) => item.screen).toList(),
          ),

          bottomNavigationBar: _buildCustomBottomNav(items, selectedIndex),
        );
      },
    );
  }

  Widget _buildCustomBottomNav(List<NavItem> items, int selectedIndex) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final unselectedColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextTertiary;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.08),
              blurRadius: 18,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == selectedIndex;

            final itemColor = isSelected ? AppColors.primary : unselectedColor;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconTheme(
                        data: IconThemeData(color: itemColor, size: 24),
                        child: isSelected
                            ? (item.selectedIcon ?? item.icon)
                            : item.icon,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: itemColor,
                          fontSize: 10.5,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
