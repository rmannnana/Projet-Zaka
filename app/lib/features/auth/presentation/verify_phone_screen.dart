import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import 'phone_form.dart';

/// Ajoute un numéro vérifié au compte connecté (exigé pour publier
/// en tant que particulier).
class VerifyPhoneScreen extends StatelessWidget {
  const VerifyPhoneScreen({super.key, this.redirectTo});

  final String? redirectTo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.verifyPhoneTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            children: [
              Text(l10n.verifyPhoneIntro),
              const SizedBox(height: 24),
              PhoneVerificationForm(
                link: true,
                onVerified: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.phoneVerified)),
                  );
                  if (redirectTo != null) {
                    context.go(redirectTo!);
                  } else {
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
