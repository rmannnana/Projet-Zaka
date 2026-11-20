import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/auth_repository.dart';

/// Connexion / inscription par e-mail. La connexion par téléphone (OTP)
/// sera ajoutée en phase 1.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, this.redirectTo});

  final String? redirectTo;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _signUp = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final repo = ref.read(authRepositoryProvider);
    try {
      if (_signUp) {
        await repo.signUpWithEmail(
          email: _email.text,
          password: _password.text,
          displayName: _name.text,
        );
      } else {
        await repo.signInWithEmail(_email.text, _password.text);
      }
      if (mounted) context.go(widget.redirectTo ?? '/compte');
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _messageFor(e.code));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _messageFor(String code) => switch (code) {
    'invalid-credential' || 'wrong-password' || 'user-not-found' => 'E-mail ou mot de passe incorrect.',
    'email-already-in-use' => 'Un compte existe déjà avec cette adresse.',
    'weak-password' => 'Mot de passe trop faible.',
    'network-request-failed' => 'Pas de connexion internet.',
    'too-many-requests' => 'Trop de tentatives. Réessayez dans quelques minutes.',
    _ => AppLocalizations.of(context).genericError,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_signUp ? l10n.signUp : l10n.signIn)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: [
                if (_signUp) ...[
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(labelText: l10n.displayName),
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.name],
                    validator: (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(labelText: l10n.email),
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  validator: (v) => (v == null || !v.contains('@')) ? l10n.invalidEmail : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(labelText: l10n.password),
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  validator: (v) => (v == null || v.length < 8) ? l10n.passwordTooShort : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _busy ? null : _submit,
                  child: _busy
                      ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_signUp ? l10n.signUp : l10n.signIn),
                ),
                TextButton(
                  onPressed: _busy ? null : () => setState(() => _signUp = !_signUp),
                  child: Text(_signUp ? l10n.alreadyHaveAccount : l10n.noAccountYet),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
