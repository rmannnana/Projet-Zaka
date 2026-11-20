import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/account/presentation/account_screen.dart';
import '../features/admin/presentation/admin_dashboard_screen.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/auth/presentation/verify_phone_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/home_shell.dart';
import '../core/widgets/coming_soon.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Routes de l'app publique (clients et espaces pros).
final publicRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/hotels',
              builder: (_, _) => const ComingSoon(title: 'Hôtels', icon: Icons.hotel),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/immobilier',
              builder: (_, _) => const ComingSoon(title: 'Immobilier', icon: Icons.apartment),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/compte',
              builder: (_, _) => const AccountScreen(),
              routes: [
                GoRoute(
                  path: 'telephone',
                  parentNavigatorKey: _rootKey,
                  builder: (_, state) =>
                      VerifyPhoneScreen(redirectTo: state.uri.queryParameters['retour']),
                ),
              ],
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/connexion',
        parentNavigatorKey: _rootKey,
        builder: (_, state) => SignInScreen(redirectTo: state.uri.queryParameters['retour']),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

/// Routes du back-office : réservé aux rôles `admin` et `moderator`.
final adminRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.listen(staffRoleProvider, (_, _) => refresh.value++);

  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final here = state.matchedLocation;
      String? goTo(String path) => here == path ? null : path;

      final auth = ref.read(authStateProvider);
      if (auth.isLoading) return goTo('/chargement');
      if (auth.value == null) return goTo('/connexion');

      final role = ref.read(staffRoleProvider);
      if (role.isLoading) return goTo('/chargement');
      final isStaff = role.value == 'admin' || role.value == 'moderator';
      if (!isStaff) return goTo('/interdit');

      return const {'/connexion', '/interdit', '/chargement'}.contains(here) ? '/' : null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const AdminDashboardScreen()),
      GoRoute(path: '/connexion', builder: (_, _) => const SignInScreen(redirectTo: '/')),
      GoRoute(path: '/interdit', builder: (_, _) => const AdminForbiddenScreen()),
      GoRoute(
        path: '/chargement',
        builder: (_, _) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
