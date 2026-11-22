import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../data/admin_repository.dart';
import 'admin_shell.dart';

final _date = DateFormat('d MMM yyyy, HH:mm', 'fr');

const _reasonLabels = {
  'fraud': 'Arnaque ou fraude',
  'wrong_info': 'Informations fausses',
  'unavailable': "N'est plus disponible",
  'inappropriate': 'Contenu inapproprié',
  'duplicate': 'Annonce en double',
  'other': 'Autre',
};

const _targetLabels = {
  'hotel': 'Hôtel',
  'property': 'Bien immobilier',
  'project': 'Programme',
  'organization': 'Compte',
};

/// Signalements ouverts, du plus ancien au plus récent.
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(openReportsProvider);
    return reports.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Chargement impossible : $e')),
      data: (reports) => reports.isEmpty
          ? const Center(child: Text('Aucun signalement ouvert.'))
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: reports.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) => _ReportTile(report: reports[i]),
            ),
    );
  }
}

class _ReportTile extends ConsumerWidget {
  const _ReportTile({required this.report});

  final AdminRecord report;

  Future<void> _close(BuildContext context, WidgetRef ref, {required bool resolved}) async {
    final note = await askNote(
      context,
      title: resolved ? 'Marquer comme traité' : 'Classer sans suite',
      confirmLabel: 'Confirmer',
      help: resolved
          ? "Indiquez l'action menée (annonce suspendue, pro contacté…)."
          : 'Le signalement sera archivé sans action.',
      required: resolved,
    );
    if (note == null) return;
    try {
      await ref.read(adminRepositoryProvider).closeReport(
        report.id,
        resolved: resolved,
        staffUid: ref.read(staffUidProvider)!,
        resolution: note,
      );
      ref.invalidate(adminCountersProvider);
    } catch (e) {
      if (context.mounted) showAdminError(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = report.str('targetType') ?? '';
    final targetId = report.str('targetId') ?? '';
    final at = report.date('createdAt');
    return ListTile(
      isThreeLine: true,
      leading: const Icon(Icons.flag_outlined),
      title: Text('${_reasonLabels[report.str('reason')] ?? report.str('reason')} · ${_targetLabels[type] ?? type}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (report.str('details') != null) Text(report.str('details')!),
          SelectableText(
            '${at == null ? '' : _date.format(at)} · cible : $targetId · auteur : ${report.str('reporterUid')}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: Wrap(
        spacing: 4,
        children: [
          if (type == 'organization')
            IconButton(
              tooltip: 'Voir le compte',
              icon: const Icon(Icons.open_in_new),
              onPressed: () => context.go('/comptes/$targetId'),
            ),
          IconButton(
            tooltip: 'Traité',
            icon: const Icon(Icons.check),
            onPressed: () => _close(context, ref, resolved: true),
          ),
          IconButton(
            tooltip: 'Classer sans suite',
            icon: const Icon(Icons.archive_outlined),
            onPressed: () => _close(context, ref, resolved: false),
          ),
        ],
      ),
    );
  }
}

/// Demandes d'effacement des données personnelles en attente.
class DeletionRequestsScreen extends ConsumerWidget {
  const DeletionRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(pendingDeletionsProvider);
    return requests.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Chargement impossible : $e')),
      data: (requests) => requests.isEmpty
          ? const Center(child: Text('Aucune demande en attente.'))
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Délai de traitement : 30 jours après la demande. L'effacement supprime le profil, "
                    'les photos et le compte ; les demandes passées sont conservées sans nom ni téléphone.',
                  ),
                ),
                for (final r in requests) _DeletionTile(request: r),
              ],
            ),
    );
  }
}

class _DeletionTile extends ConsumerStatefulWidget {
  const _DeletionTile({required this.request});

  final AdminRecord request;

  @override
  ConsumerState<_DeletionTile> createState() => _DeletionTileState();
}

class _DeletionTileState extends ConsumerState<_DeletionTile> {
  bool _busy = false;

  Future<void> _process({required bool accept}) async {
    String? note;
    if (accept) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Effacer les données'),
          content: const Text('Cette opération est définitive. Continuer ?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Effacer')),
          ],
        ),
      );
      if (ok != true) return;
    } else {
      note = await askNote(context, title: 'Refuser la demande', confirmLabel: 'Refuser');
      if (note == null) return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(adminRepositoryProvider).processDeletion(widget.request.id, accept: accept, note: note);
      ref.invalidate(adminCountersProvider);
    } catch (e) {
      if (mounted) showAdminError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = widget.request.str('uid') ?? '';
    final user = ref.watch(adminUserProvider(uid)).value;
    final at = widget.request.date('requestedAt');
    final deadline = at?.add(const Duration(days: 30));
    final late = deadline != null && DateTime.now().isAfter(deadline);
    return Card.outlined(
      child: ListTile(
        isThreeLine: true,
        leading: Icon(Icons.person_remove_outlined, color: late ? Theme.of(context).colorScheme.error : null),
        title: Text(user == null ? uid : '${user.displayName} · ${user.email ?? user.phone ?? ''}'),
        subtitle: Text(
          '${at == null ? '' : 'Demandé le ${_date.format(at)}'}'
          '${deadline == null ? '' : ' · à traiter avant le ${DateFormat.yMMMd('fr').format(deadline)}'}'
          '${widget.request.str('reason') == null ? '' : '\nMotif : ${widget.request.str('reason')}'}',
        ),
        trailing: _busy
            ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : Wrap(
                spacing: 8,
                children: [
                  OutlinedButton(onPressed: () => _process(accept: false), child: const Text('Refuser')),
                  FilledButton(onPressed: () => _process(accept: true), child: const Text('Effacer')),
                ],
              ),
      ),
    );
  }
}
