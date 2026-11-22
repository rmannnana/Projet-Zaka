import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/open_bytes.dart';
import '../../../l10n/app_localizations.dart';
import '../../organizations/data/organization_repository.dart';
import '../../organizations/domain/organization.dart';
import '../../organizations/presentation/org_labels.dart';
import '../data/admin_repository.dart';
import 'admin_shell.dart';
import 'audit_screen.dart';

final _date = DateFormat('d MMM yyyy, HH:mm', 'fr');

/// Comptes par statut ; l'onglet « En vérification » est la file de travail.
class OrgReviewListScreen extends ConsumerWidget {
  const OrgReviewListScreen({super.key});

  static const _tabs = [
    VerificationStatus.pending,
    VerificationStatus.verified,
    VerificationStatus.rejected,
    VerificationStatus.suspended,
    VerificationStatus.draft,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: [for (final s in _tabs) Tab(text: s.label(l10n))],
          ),
          Expanded(
            child: TabBarView(
              children: [for (final s in _tabs) _OrgList(status: s)],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrgList extends ConsumerWidget {
  const _OrgList({required this.status});

  final VerificationStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final orgs = ref.watch(adminOrgsProvider(status));
    return orgs.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Chargement impossible : $e')),
      data: (orgs) => orgs.isEmpty
          ? const Center(child: Text('Aucun compte.'))
          : ListView.separated(
              itemCount: orgs.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final org = orgs[i];
                final when = status == VerificationStatus.pending
                    ? org.verification.submittedAt
                    : org.updatedAt;
                return ListTile(
                  leading: CircleAvatar(child: Icon(org.type.icon)),
                  title: Text(org.name),
                  subtitle: Text(
                    '${org.type.label(l10n)} · ${org.contact.city} (${org.contact.country})'
                    '${when == null ? '' : ' · ${_date.format(when)}'}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/comptes/${org.id}'),
                );
              },
            ),
    );
  }
}

/// Fiche d'un compte : informations, pièces, historique et décision.
class OrgReviewScreen extends ConsumerWidget {
  const OrgReviewScreen({super.key, required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final org = ref.watch(organizationProvider(orgId));
    return org.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Chargement impossible : $e')),
      data: (org) {
        if (org == null) return const Center(child: Text('Compte introuvable.'));
        final v = org.verification;
        final legal = org.legal ?? const OrgLegal();
        final docs = {
          DocumentKind.ifu: v.documents.ifu,
          DocumentKind.rccm: v.documents.rccm,
          DocumentKind.proofOfAddress: v.documents.proofOfAddress,
        };

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Retour',
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/comptes'),
                ),
                Expanded(child: Text(org.name, style: Theme.of(context).textTheme.headlineSmall)),
                VerificationStatusChip(v.status),
              ],
            ),
            const SizedBox(height: 8),
            _DecisionBar(org: org),
            if (v.note != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.comment_outlined),
                  title: const Text('Dernier motif'),
                  subtitle: Text(v.note!),
                ),
              ),
            _Section('Profil', [
              _Field('Type', org.type.label(l10n)),
              _Field('Ville', '${org.contact.city} (${org.contact.country})'),
              _Field('Adresse', org.contact.address),
              _Field('Téléphone', org.contact.phone),
              _Field('E-mail', org.contact.email),
              _Field('Présentation', org.description),
              _Field('Créé le', org.createdAt == null ? null : _date.format(org.createdAt!)),
            ]),
            if (org.type.requiresDocuments) ...[
              _Section('Informations légales', [
                _Field('Numéro IFU', legal.ifuNumber),
                _Field('Numéro RCCM', legal.rccmNumber),
                _Field('Représentant légal', legal.representativeName),
                _Field('Dossier envoyé le', v.submittedAt == null ? null : _date.format(v.submittedAt!)),
              ]),
              _Section('Pièces justificatives', [
                for (final MapEntry(key: kind, value: path) in docs.entries)
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(kind.label(l10n)),
                    subtitle: Text(path ?? 'Non fournie'),
                    trailing: path == null
                        ? null
                        : OutlinedButton.icon(
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Ouvrir'),
                            onPressed: () => _openDocument(context, ref, path),
                          ),
                  ),
              ]),
            ],
            _Section('Historique', [
              SizedBox(height: 320, child: AuditList(targetRef: 'organizations/$orgId')),
            ]),
          ],
        );
      },
    );
  }

  Future<void> _openDocument(BuildContext context, WidgetRef ref, String path) async {
    try {
      final bytes = await ref.read(adminRepositoryProvider).documentBytes(path);
      final ext = path.split('.').last;
      await openBytes(bytes, contentTypeFor(ext));
    } catch (e) {
      if (context.mounted) showAdminError(context, e);
    }
  }
}

class _DecisionBar extends ConsumerStatefulWidget {
  const _DecisionBar({required this.org});

  final Organization org;

  @override
  ConsumerState<_DecisionBar> createState() => _DecisionBarState();
}

class _DecisionBarState extends ConsumerState<_DecisionBar> {
  bool _busy = false;

  Future<void> _decide(OrgDecision decision) async {
    String? note;
    switch (decision) {
      case OrgDecision.reject:
        note = await askNote(
          context,
          title: 'Refuser le dossier',
          confirmLabel: 'Refuser',
          help: 'Le pro pourra corriger son dossier et le renvoyer.',
        );
        if (note == null) return;
      case OrgDecision.suspend:
        note = await askNote(
          context,
          title: 'Suspendre le compte',
          confirmLabel: 'Suspendre',
          help: 'Le compte ne pourra plus modifier ni publier ses annonces.',
        );
        if (note == null) return;
      case OrgDecision.verify || OrgDecision.reinstate:
        final ok = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(decision == OrgDecision.verify ? 'Valider le compte' : 'Rétablir le compte'),
            content: Text(
              decision == OrgDecision.verify
                  ? 'Les pièces et les informations légales ont été contrôlées ?'
                  : 'Le compte pourra de nouveau publier.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Confirmer')),
            ],
          ),
        );
        if (ok != true) return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(adminRepositoryProvider).reviewOrg(widget.org.id, decision, note: note);
      ref.invalidate(adminCountersProvider);
    } catch (e) {
      if (mounted) showAdminError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = switch (widget.org.verification.status) {
      VerificationStatus.pending => [
        FilledButton.icon(
          onPressed: _busy ? null : () => _decide(OrgDecision.verify),
          icon: const Icon(Icons.check),
          label: const Text('Valider'),
        ),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _decide(OrgDecision.reject),
          icon: const Icon(Icons.close),
          label: const Text('Refuser'),
        ),
      ],
      VerificationStatus.verified => [
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _decide(OrgDecision.suspend),
          icon: const Icon(Icons.block),
          label: const Text('Suspendre'),
        ),
      ],
      VerificationStatus.suspended => [
        FilledButton.icon(
          onPressed: _busy ? null : () => _decide(OrgDecision.reinstate),
          icon: const Icon(Icons.restore),
          label: const Text('Rétablir'),
        ),
      ],
      VerificationStatus.draft || VerificationStatus.rejected => <Widget>[],
    };
    if (actions.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(spacing: 8, runSpacing: 8, children: actions),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.children);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card.outlined(
    margin: const EdgeInsets.only(top: 12),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          ...children,
        ],
      ),
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    title: Text(label),
    subtitle: SelectableText(value == null || value!.isEmpty ? '-' : value!),
  );
}
