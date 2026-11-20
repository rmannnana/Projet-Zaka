import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Écran provisoire pour les sections pas encore développées.
class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key, required this.title, this.icon = Icons.construction});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(l10n.comingSoon, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(l10n.comingSoonBody, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
