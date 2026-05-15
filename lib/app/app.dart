import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:odo/app/router.dart';
import 'package:odo/app/theme.dart';
import 'package:odo/features/settings/presentation/theme_provider.dart';

class OdoApp extends ConsumerWidget {
  const OdoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    return MaterialApp.router(
      title: 'OdO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromOdoTheme(activeTheme),
      routerConfig: router,
    );
  }
}
