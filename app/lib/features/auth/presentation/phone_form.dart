import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/phone.dart';
import '../../../l10n/app_localizations.dart';
import '../../account/data/user_repository.dart';
import '../data/auth_repository.dart';

/// Saisie d'un numéro UEMOA puis du code reçu par SMS.
///
/// [link] ajoute le numéro au compte connecté au lieu de se connecter avec.
class PhoneVerificationForm extends ConsumerStatefulWidget {
  const PhoneVerificationForm({super.key, required this.onVerified, this.link = false});

  final VoidCallback onVerified;
  final bool link;

  @override
  ConsumerState<PhoneVerificationForm> createState() => _PhoneVerificationFormState();
}

class _PhoneVerificationFormState extends ConsumerState<PhoneVerificationForm> {
  final _number = TextEditingController();
  final _code = TextEditingController();
  late UemoaCountry _country = countryByCode(ref.read(currentUserProfileProvider).value?.country);
  PhoneVerification? _pending;
  String? _e164;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _number.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendCode() async {
    final l10n = AppLocalizations.of(context);
    final e164 = toE164(_country, _number.text);
    if (e164 == null) {
      setState(() => _error = l10n.phoneInvalidForCountry(_country.name));
      return;
    }
    await _run(() async {
      final verification = await ref.read(authRepositoryProvider).verifyPhone(e164, link: widget.link);
      if (verification.autoVerified) {
        widget.onVerified();
        return;
      }
      setState(() {
        _pending = verification;
        _e164 = e164;
      });
    });
  }

  Future<void> _confirm() => _run(() async {
    await _pending!.confirm(_code.text);
    widget.onVerified();
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final error = _error == null
        ? null
        : Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error));
    final progress = const SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );

    if (_pending == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<UemoaCountry>(
                value: _country,
                underline: const SizedBox.shrink(),
                onChanged: _busy ? null : (c) => setState(() => _country = c!),
                items: [
                  for (final c in uemoaCountries)
                    DropdownMenuItem(value: c, child: Text('${c.flag} +${c.dialCode}')),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _number,
                  enabled: !_busy,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9 +]'))],
                  decoration: InputDecoration(labelText: l10n.phoneNumber),
                  onSubmitted: (_) => _sendCode(),
                ),
              ),
            ],
          ),
          if (error != null) ...[const SizedBox(height: 12), error],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _busy ? null : _sendCode,
            child: _busy ? progress : Text(l10n.phoneSendCode),
          ),
          const SizedBox(height: 8),
          Text(l10n.phoneSmsNotice, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.phoneCodeSentTo(_e164!)),
        const SizedBox(height: 12),
        TextField(
          controller: _code,
          enabled: !_busy,
          autofocus: true,
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          decoration: InputDecoration(labelText: l10n.phoneCode),
          onSubmitted: (_) => _confirm(),
        ),
        if (error != null) ...[const SizedBox(height: 12), error],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _busy ? null : _confirm,
          child: _busy ? progress : Text(l10n.phoneVerify),
        ),
        TextButton(
          onPressed: _busy ? null : () => setState(() => _pending = null),
          child: Text(l10n.phoneChangeNumber),
        ),
      ],
    );
  }
}
