import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import 'flavor.dart';
import 'router.dart';
import 'services.dart';
import 'theme.dart';

/// Racine commune : seule la table de routes change entre l'app publique
/// et le back-office.
class ZakaApp extends ConsumerWidget {
  const ZakaApp({super.key, required this.target});

  final AppTarget target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(
      target == AppTarget.admin ? adminRouterProvider : publicRouterProvider,
    );
    final flavor = Flavor.current;
    ref.watch(pushRegistrationProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) {
        final l10n = AppLocalizations.of(context);
        return target == AppTarget.admin ? l10n.adminTitle : l10n.appTitle;
      },
      theme: ZakaTheme.light(),
      darkTheme: ZakaTheme.dark(),
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => EnvBanner(flavor: flavor, child: child!),
    );
  }
}

/// Bandeau « DEV » ou « STAGING » pour ne jamais confondre les environnements.
/// Absent en production et dans l'APK à partager (`ENV_MARKS=false`).
class EnvBanner extends StatelessWidget {
  const EnvBanner({super.key, required this.flavor, required this.child});

  final Flavor flavor;
  final Widget child;

  @override
  Widget build(BuildContext context) => !flavor.showsBanner
      ? child
      : Banner(
          message: flavor.name.toUpperCase(),
          location: BannerLocation.topEnd,
          color: flavor == Flavor.dev ? Colors.green.shade700 : Colors.orange.shade800,
          child: child,
        );
}
