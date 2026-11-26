import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../data/organization_repository.dart';
import '../domain/organization.dart';
import 'org_labels.dart';

/// Dossier de vérification d'un compte pro : données légales et pièces
/// (IFU, RCCM, justificatif de résidence).
class VerificationScreen extends ConsumerWidget {
  const VerificationScreen({super.key, required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final org = ref.watch(organizationProvider(orgId)).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.verificationFile)),
      body: org == null
          ? const Center(child: CircularProgressIndicator())
          : Readable(
              maxWidth: 640,
              child: org.canEditVerification ? _VerificationForm(org: org) : _ReadOnly(org: org),
            ),
    );
  }
}

class _ReadOnly extends StatelessWidget {
  const _ReadOnly({required this.org});

  final Organization org;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final legal = org.legal ?? const OrgLegal();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        NoticeCard(
          title: org.verification.status.label(l10n),
          text: l10n.verificationLocked,
          icon: Icons.lock_outline,
          tone: org.isVerified ? Tone.sage : Tone.peach,
        ),
        const SizedBox(height: 14),
        SectionCard(
          title: l10n.legalInfo,
          children: [
            FieldLine(l10n.ifuNumber, legal.ifuNumber),
            FieldLine(l10n.rccmNumber, legal.rccmNumber),
            FieldLine(l10n.representativeName, legal.representativeName),
          ],
        ),
        SectionCard(
          title: l10n.documents,
          children: [
            for (final kind in DocumentKind.values)
              _DocumentRow(
                label: kind.label(l10n),
                status: _documentPath(org, kind) == null ? l10n.documentMissing : l10n.documentReceived,
                received: _documentPath(org, kind) != null,
              ),
          ],
        ),
      ],
    );
  }
}

String? _documentPath(Organization org, DocumentKind kind) {
  final docs = org.verification.documents;
  return switch (kind) {
    DocumentKind.ifu => docs.ifu,
    DocumentKind.rccm => docs.rccm,
    DocumentKind.proofOfAddress => docs.proofOfAddress,
  };
}

class _VerificationForm extends ConsumerStatefulWidget {
  const _VerificationForm({required this.org});

  final Organization org;

  @override
  ConsumerState<_VerificationForm> createState() => _VerificationFormState();
}

class _VerificationFormState extends ConsumerState<_VerificationForm> {
  final _formKey = GlobalKey<FormState>();
  late final _ifu = TextEditingController(text: widget.org.legal?.ifuNumber);
  late final _rccm = TextEditingController(text: widget.org.legal?.rccmNumber);
  late final _representative = TextEditingController(text: widget.org.legal?.representativeName);

  /// Pièces déjà envoyées (dossier refusé) ou nouvellement déposées.
  late final Map<DocumentKind, String> _documents = {
    for (final kind in DocumentKind.values) kind: ?_documentPath(widget.org, kind),
  };

  /// Nom du fichier choisi, pour l'affichage.
  final Map<DocumentKind, String> _fileNames = {};
  DocumentKind? _uploading;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _ifu.dispose();
    _rccm.dispose();
    _representative.dispose();
    super.dispose();
  }

  Future<void> _pick(DocumentKind kind) async {
    final l10n = AppLocalizations.of(context);
    final file = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: allowedDocumentExtensions);
    if (file == null) return;
    final ext = file.extension?.toLowerCase();
    if (ext == null || !allowedDocumentExtensions.contains(ext)) {
      setState(() => _error = l10n.documentBadType);
      return;
    }
    setState(() {
      _uploading = kind;
      _error = null;
    });
    try {
      final bytes = await file.readAsBytes();
      if (bytes.length > maxDocumentBytes) {
        setState(() => _error = l10n.documentTooLarge);
        return;
      }
      final path = await ref
          .read(organizationRepositoryProvider)
          .uploadDocument(widget.org.id, kind, bytes: bytes, extension: ext);
      setState(() {
        _documents[kind] = path;
        _fileNames[kind] = file.name;
      });
    } catch (e) {
      if (mounted) setState(() => _error = functionErrorMessage(e));
    } finally {
      if (mounted) setState(() => _uploading = null);
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_documents.length < DocumentKind.values.length) {
      setState(() => _error = l10n.documentsMissing);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repo = ref.read(organizationRepositoryProvider);
    try {
      final legal = OrgLegal(
        ifuNumber: _ifu.text.trim(),
        rccmNumber: _rccm.text.trim(),
        representativeName: _representative.text.trim(),
      );
      if (legal != widget.org.legal) await repo.updateLegal(widget.org.id, legal);
      await repo.submitVerification(widget.org.id, _documents);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.verificationSent)));
      context.pop();
    } catch (e) {
      if (mounted) setState(() => _error = functionErrorMessage(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final busy = _submitting || _uploading != null;
    String? required(String? v) => (v == null || v.trim().length < 3) ? l10n.fieldRequired : null;
    final note = widget.org.verification.note;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.org.verification.status == VerificationStatus.rejected && note != null) ...[
            NoticeCard(title: l10n.statusRejected, text: note, icon: Icons.error_outline, tone: Tone.danger),
            const SizedBox(height: 14),
          ],
          PageIntro(text: l10n.verificationIntro),
          SectionCard(
            title: l10n.legalInfo,
            children: [
              TextFormField(
                controller: _ifu,
                decoration: InputDecoration(labelText: l10n.ifuNumber),
                validator: required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rccm,
                decoration: InputDecoration(labelText: l10n.rccmNumber, hintText: 'BF-OUA-2026-B-1234'),
                validator: required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _representative,
                decoration: InputDecoration(labelText: l10n.representativeName),
                textCapitalization: TextCapitalization.words,
                validator: required,
              ),
            ],
          ),
          SectionCard(
            title: l10n.documents,
            subtitle: l10n.documentsHelp,
            children: [
              for (final kind in DocumentKind.values)
                _DocumentRow(
                  label: kind.label(l10n),
                  status:
                      _fileNames[kind] ?? (_documents.containsKey(kind) ? l10n.documentReceived : l10n.documentMissing),
                  received: _documents.containsKey(kind),
                  trailing: _uploading == kind
                      ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 38)),
                          onPressed: busy ? null : () => _pick(kind),
                          child: Text(_documents.containsKey(kind) ? l10n.replace : l10n.choose),
                        ),
                ),
            ],
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: busy ? null : _submit,
            child: _submitting
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.verificationSubmit),
          ),
          const SizedBox(height: 8),
          Text(l10n.verificationPrivacy, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Une pièce du dossier : reçue (coche verte) ou à fournir.
class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.label, required this.status, required this.received, this.trailing});

  final String label;
  final String status;
  final bool received;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        ToneIcon(
          received ? Icons.check_circle_outline : Icons.upload_file,
          tone: received ? Tone.sage : Tone.neutral,
          size: 40,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                status,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: received ? ZakaColors.success : ZakaPalette.of(context).muted, fontSize: 12.5),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    ),
  );
}
