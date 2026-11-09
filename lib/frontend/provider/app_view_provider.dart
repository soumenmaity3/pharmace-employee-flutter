import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppView {
  splash,
  login,
  signup,
  dashboard,
}

final appViewProvider = StateProvider<AppView>((ref) => AppView.splash);
final selectedNavIndexProvider = StateProvider<int>((ref) => 0);
