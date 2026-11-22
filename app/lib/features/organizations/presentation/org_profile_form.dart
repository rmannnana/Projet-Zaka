import 'package:flutter/material.dart';

import '../../../core/phone.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/organization.dart';

/// Valeurs du formulaire de profil public d'un espace publieur.
class OrgProfileValues {
  const OrgProfileValues({
    required this.name,
    required this.description,
    required this.contact,
  });

  final String name;
  final String description;
  final OrgContact contact;
}

/// Formulaire commun à la création et à la modification d'un espace.
class OrgProfileForm extends StatefulWidget {
  const OrgProfileForm({
    super.key,
    required this.type,
    required this.initial,
    required this.submitLabel,
    required this.onSubmit,
  });

  final OrgType type;
  final OrgProfileValues initial;
  final String submitLabel;

  /// Renvoie un message d'erreur, ou null en cas de succès.
  final Future<String?> Function(OrgProfileValues values) onSubmit;

  @override
  State<OrgProfileForm> createState() => _OrgProfileFormState();
}

class _OrgProfileFormState extends State<OrgProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial.name);
  late final _description = TextEditingController(text: widget.initial.description);
  late final _phone = TextEditingController(text: widget.initial.contact.phone);
  late final _email = TextEditingController(text: widget.initial.contact.email);
  late final _city = TextEditingController(text: widget.initial.contact.city);
  late final _address = TextEditingController(text: widget.initial.contact.address);
  late String _country = countryByCode(widget.initial.contact.country).code;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _description, _phone, _email, _city, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final phone = toE164(countryByCode(_country), _phone.text) ?? _phone.text.trim();
    final error = await widget.onSubmit(
      OrgProfileValues(
        name: _name.text.trim(),
        description: _description.text.trim(),
        contact: OrgContact(
          phone: phone,
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
          address: _address.text.trim().isEmpty ? null : _address.text.trim(),
          city: _city.text.trim(),
          country: _country,
        ),
      ),
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isIndividual = widget.type == OrgType.individualOwner;
    String? required(String? v) => (v == null || v.trim().length < 2) ? l10n.fieldRequired : null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _name,
            decoration: InputDecoration(
              labelText: isIndividual ? l10n.orgPublicName : l10n.orgName,
              helperText: isIndividual ? l10n.orgPublicNameHelp : null,
            ),
            textCapitalization: TextCapitalization.words,
            validator: required,
          ),
          if (!isIndividual) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: InputDecoration(labelText: l10n.orgDescription),
              maxLines: 4,
              maxLength: 2000,
            ),
          ],
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _country,
            decoration: InputDecoration(labelText: l10n.country),
            items: [
              for (final c in uemoaCountries)
                DropdownMenuItem(value: c.code, child: Text('${c.flag} ${c.name}')),
            ],
            onChanged: (v) => setState(() => _country = v!),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _city,
            decoration: InputDecoration(labelText: l10n.city),
            textCapitalization: TextCapitalization.words,
            validator: required,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _address,
            decoration: InputDecoration(labelText: l10n.address),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone,
            decoration: InputDecoration(labelText: l10n.contactPhone),
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.replaceAll(RegExp(r'\D'), '').length < 8)
                ? l10n.fieldRequired
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            decoration: InputDecoration(labelText: l10n.contactEmail),
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                (v != null && v.trim().isNotEmpty && !v.contains('@')) ? l10n.invalidEmail : null,
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
                : Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }
}
