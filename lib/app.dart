import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_strings.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'services/service_locator.dart';

/// Widget raiz do Jô Modas: tema + navegação + título. Sem regra de negócio.
class JoModasApp extends StatefulWidget {
  const JoModasApp({super.key});

  @override
  State<JoModasApp> createState() => _JoModasAppState();
}

class _JoModasAppState extends State<JoModasApp> {
  late final GoRouter _router = AppRouter.create(
    initialLocation: authService.isSignedIn
        ? AppRoutes.homePath
        : AppRoutes.signInPath,
    refreshListenable: authService,
    isSignedIn: () => authService.isSignedIn,
    isAdmin: () => authService.isAdmin,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
