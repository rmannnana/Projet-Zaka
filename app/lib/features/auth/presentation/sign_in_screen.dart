import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/auth_repository.dart';
import 'phone_form.dart';

enum _Method { phone, email }

/// Connexion et inscription : téléphone (SMS), e-mail ou Google.
/// Le téléphone est proposé en premier : c'est l'identifiant le plus répandu
/// dans la zone UEMOA.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, this.redirectTo});

  final String? redirectTo;

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  _Method _method = _Method.phone;
  bool _googleBusy = false;
  String? _googleError;

  void _done() {
    if (mounted) context.go(widget.redirectTo ?? '/compte');
  }

  Future<void> _google() async {
    setState(() {
      _googleBusy = true;
      _googleError = null;
    });
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      _done();
    } catch (e) {
      if (mounted) setState(() => _googleError = authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _googleBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.signIn)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            children: [
              SegmentedButton<_Method>(
                segments: [
                  ButtonSegment(
                    value: _Method.phone,
                    icon: const Icon(Icons.phone_android),
                    label: Text(l10n.methodPhone),
                  ),
                  ButtonSegment(
                    value: _Method.email,
                    icon: const Icon(Icons.mail_outline),
                    label: Text(l10n.methodEmail),
                  ),
                ],
                selected: {_method},
                onSelectionChanged: (s) => setState(() => _method = s.first),
              ),
              const SizedBox(height: 24),
              switch (_method) {
                _Method.phone => PhoneVerificationForm(onVerified: _done),
                _Method.email => _EmailForm(onDone: _done),
              },
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(l10n.or),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _googleBusy ? null : _google,
                icon: const Icon(Icons.account_circle_outlined),
                label: Text(l10n.continueWithGoogle),
              ),
              if (_googleError != null) ...[
                const SizedBox(height: 8),
                Text(_googleError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailForm extends ConsumerStatefulWidget {
  const _EmailForm({required this.onDone});

  final VoidCallback onDone;

  @override
  ConsumerState<_EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends ConsumerState<_EmailForm> {
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
      widget.onDone();
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
    );
  }
}
