import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/money.dart';
import '../../../l10n/app_localizations.dart';
import '../../billing/data/billing_repository.dart';
import '../../billing/domain/billing.dart';
import '../../billing/presentation/billing_labels.dart';
import '../../organizations/data/organization_repository.dart';
import '../../organizations/domain/organization.dart';
import '../data/admin_repository.dart';
import 'admin_shell.dart';

const scopeLabels = {
  CommissionScope.hotelBooking: 'Réservations d\'hôtel',
  CommissionScope.propertyRent: 'Locations immobilières',
  CommissionScope.propertySale: 'Ventes immobilières',
};

const _ruleStateLabels = {
  RuleState.inForce: 'En vigueur',
  RuleState.scheduled: 'Programmée',
  RuleState.ended: 'Terminée',
  RuleState.disabled: 'Désactivée',
};

final _day = DateFormat('d MMM yyyy', 'fr');
const _oneDay = Duration(days: 1);

/// Jour calendaire (minuit UTC, l'heure du Burkina Faso).
DateTime _utcDay(DateTime d) => DateTime.utc(d.year, d.month, d.day);

/// « du 1 janv. 2026 », « du 1 janv. 2026 au 31 déc. 2026 ». La fin enregistrée est exclue.
String validityLabel(CommissionRule rule) {
  final from = rule.validFrom == null ? '?' : _day.format(rule.validFrom!.toUtc());
  if (rule.validTo == null) return 'à partir du $from';
  return 'du $from au ${_day.format(rule.validTo!.toUtc().subtract(_oneDay))}';
}

bool _partnerFits(CommissionScope scope, Organization org) =>
    scope == CommissionScope.hotelBooking ? org.type == OrgType.hotel : org.type != OrgType.hotel;

/// Liste des partenaires vérifiés concernés par un type d'opération.
List<DropdownMenuEntry<String>> _partnerEntries(
  List<Organization> orgs,
  CommissionScope scope, {
  required String allLabel,
  CommissionRule? current,
}) => [
  DropdownMenuEntry(value: '', label: allLabel),
  for (final org in orgs)
    if (_partnerFits(scope, org)) DropdownMenuEntry(value: org.id, label: org.name),
  if (current?.orgId != null && !orgs.any((o) => o.id == current!.orgId))
    DropdownMenuEntry(value: current!.orgId!, label: current.orgName ?? current.orgId!),
];

/// Règles de commission par type d'opération, et simulateur.
class CommissionRulesTab extends ConsumerWidget {
  const CommissionRulesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(commissionRulesProvider);
    final now = DateTime.now();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog<void>(context: context, builder: (_) => const _RuleDialog()),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle règle'),
      ),
      body: rules.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Chargement impossible : $e')),
        data: (rules) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
          children: [
            const Text(
              "La règle propre à un partenaire passe avant la règle par défaut. Pour changer un taux, "
              "créez une nouvelle règle avec sa date de début : elle remplace l'ancienne à partir de "
              "cette date. Les commissions déjà calculées gardent le taux de leur date.",
            ),
            const SizedBox(height: 12),
            const _Simulator(),
            for (final scope in CommissionScope.values) ...[
              const SizedBox(height: 16),
              Text(scopeLabels[scope]!, style: Theme.of(context).textTheme.titleMedium),
              ..._rulesOf(rules, scope).map((rule) {
                final state = rule.stateAt(now);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${rule.rateLabel} · ${rule.orgName ?? 'Tous les partenaires'}'),
                  subtitle: Text(validityLabel(rule)),
                  trailing: StatusChip(
                    _ruleStateLabels[state]!,
                    state == RuleState.inForce ? ZakaColors.success : Theme.of(context).colorScheme.outline,
                  ),
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (_) => _RuleDialog(rule: rule),
                  ),
                );
              }),
              if (!rules.any((r) => r.scope == scope))
                const Text('Aucune règle : pas de commission pour ce type d\'opération.'),
            ],
          ],
        ),
      ),
    );
  }

  /// Règle par défaut d'abord, puis par partenaire ; les plus récentes en premier.
  List<CommissionRule> _rulesOf(List<CommissionRule> rules, CommissionScope scope) =>
      rules.where((r) => r.scope == scope).toList()..sort((a, b) {
        final byPartner = (a.orgName ?? '').compareTo(b.orgName ?? '');
        if (byPartner != 0) return byPartner;
        return (b.validFrom ?? DateTime(0)).compareTo(a.validFrom ?? DateTime(0));
      });
}

/// Calcule la commission qui serait appliquée, avec la même fonction que les vraies commissions.
class _Simulator extends ConsumerStatefulWidget {
  const _Simulator();

  @override
  ConsumerState<_Simulator> createState() => _SimulatorState();
}

class _SimulatorState extends ConsumerState<_Simulator> {
  final _amount = TextEditingController(text: '50000');
  CommissionScope _scope = CommissionScope.hotelBooking;
  String _orgId = '';
  bool _busy = false;
  String? _result;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final amount = int.tryParse(_amount.text.trim());
    if (amount == null) {
      setState(() => _result = 'Indiquez un montant en FCFA.');
      return;
    }
    setState(() => _busy = true);
    try {
      final preview = await ref
          .read(billingRepositoryProvider)
          .previewCommission(scope: _scope, orgId: _orgId.isEmpty ? null : _orgId, amount: amount);
      setState(() {
        _result = preview.commission == null
            ? "Aucune règle en vigueur aujourd'hui : pas de commission."
            : '${preview.specific ? 'Règle du partenaire' : 'Règle par défaut'} '
                  '(${preview.rateLabel}) : commission de ${preview.commission!.format()} '
                  'sur ${Money(amount).format()}.';
      });
    } catch (e) {
      setState(() => _result = functionErrorMessage(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orgs = ref.watch(adminOrgsProvider(VerificationStatus.verified)).value ?? const [];
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Simulateur (aujourd'hui)", style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DropdownMenu<CommissionScope>(
                  label: const Text('Opération'),
                  initialSelection: _scope,
                  dropdownMenuEntries: [
                    for (final e in scopeLabels.entries) DropdownMenuEntry(value: e.key, label: e.value),
                  ],
                  onSelected: (v) => setState(() {
                    _scope = v ?? _scope;
                    _orgId = '';
                    _result = null;
                  }),
                ),
                DropdownMenu<String>(
                  key: ValueKey(_scope),
                  label: const Text('Partenaire'),
                  enableFilter: true,
                  requestFocusOnTap: true,
                  initialSelection: _orgId,
                  dropdownMenuEntries: _partnerEntries(orgs, _scope, allLabel: 'Sans règle particulière'),
                  onSelected: (v) => setState(() => _orgId = v ?? ''),
                ),
                SizedBox(
                  width: 160,
                  child: TextField(
                    controller: _amount,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Montant', suffixText: 'FCFA'),
                    onSubmitted: (_) => _run(),
                  ),
                ),
                FilledButton(onPressed: _busy ? null : _run, child: const Text('Calculer')),
              ],
            ),
            if (_result != null) ...[const SizedBox(height: 12), Text(_result!)],
          ],
        ),
      ),
    );
  }
}

class _RuleDialog extends ConsumerStatefulWidget {
  const _RuleDialog({this.rule});

  final CommissionRule? rule;

  @override
  ConsumerState<_RuleDialog> createState() => _RuleDialogState();
}

class _RuleDialogState extends ConsumerState<_RuleDialog> {
  late CommissionScope _scope = widget.rule?.scope ?? CommissionScope.hotelBooking;
  late String _orgId = widget.rule?.orgId ?? '';
  late RateType _rateType = widget.rule?.rateType ?? RateType.percent;
  late final _rate = TextEditingController(
    text: widget.rule?.rate == null ? '' : NumberFormat('0.##', 'fr').format(widget.rule!.rate),
  );
  late final _fixed = TextEditingController(text: widget.rule?.fixedAmount?.amount.toString() ?? '');
  late DateTime _from = _utcDay(widget.rule?.validFrom?.toUtc() ?? DateTime.now());

  /// Dernier jour inclus (la fin enregistrée est le lendemain, exclu).
  late DateTime? _lastDay = widget.rule?.validTo == null
      ? null
      : _utcDay(widget.rule!.validTo!.toUtc()).subtract(_oneDay);
  late bool _active = widget.rule?.active ?? true;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _rate.dispose();
    _fixed.dispose();
    super.dispose();
  }

  Future<DateTime?> _pick(DateTime initial) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2025),
      lastDate: DateTime(2040),
    );
    return picked == null ? null : _utcDay(picked);
  }

  Future<void> _save() async {
    final rate = double.tryParse(_rate.text.trim().replaceAll(',', '.'));
    final fixed = int.tryParse(_fixed.text.trim());
    String? problem;
    if (_rateType == RateType.percent && (rate == null || rate <= 0 || rate > 100)) {
      problem = 'Indiquez un taux entre 0 et 100 %.';
    } else if (_rateType == RateType.fixed && (fixed == null || fixed <= 0)) {
      problem = 'Indiquez un montant fixe en FCFA.';
    } else if (_lastDay != null && _lastDay!.isBefore(_from)) {
      problem = 'Le dernier jour doit suivre le premier.';
    }
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(billingRepositoryProvider).saveRule({
        'scope': scopeKey(_scope),
        'rateType': _rateType.name,
        if (_rateType == RateType.percent) 'rate': rate,
        if (_rateType == RateType.fixed) 'fixedAmount': fixed,
        'orgId': _orgId.isEmpty ? null : _orgId,
        'validFrom': _from.millisecondsSinceEpoch,
        'validTo': _lastDay?.add(_oneDay).millisecondsSinceEpoch,
        'active': _active,
      }, ruleId: widget.rule?.id);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = functionErrorMessage(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orgs = ref.watch(adminOrgsProvider(VerificationStatus.verified)).value ?? const [];
    return AlertDialog(
      title: Text(widget.rule == null ? 'Nouvelle règle de commission' : 'Modifier la règle'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.rule != null)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Pour un nouveau taux, préférez une nouvelle règle avec sa date de début : "
                    "l'historique reste lisible.",
                  ),
                ),
              DropdownMenu<CommissionScope>(
                expandedInsets: EdgeInsets.zero,
                label: const Text('Opération'),
                initialSelection: _scope,
                dropdownMenuEntries: [
                  for (final e in scopeLabels.entries) DropdownMenuEntry(value: e.key, label: e.value),
                ],
                onSelected: (v) => setState(() {
                  _scope = v ?? _scope;
                  _orgId = '';
                }),
              ),
              const SizedBox(height: 12),
              DropdownMenu<String>(
                key: ValueKey(_scope),
                expandedInsets: EdgeInsets.zero,
                label: const Text('Partenaire'),
                enableFilter: true,
                requestFocusOnTap: true,
                initialSelection: _orgId,
                dropdownMenuEntries: _partnerEntries(
                  orgs,
                  _scope,
                  allLabel: 'Tous les partenaires (règle par défaut)',
                  current: widget.rule,
                ),
                onSelected: (v) => setState(() => _orgId = v ?? ''),
              ),
              const SizedBox(height: 12),
              SegmentedButton<RateType>(
                segments: const [
                  ButtonSegment(value: RateType.percent, label: Text('Pourcentage')),
                  ButtonSegment(value: RateType.fixed, label: Text('Montant fixe')),
                ],
                selected: {_rateType},
                onSelectionChanged: (s) => setState(() => _rateType = s.first),
              ),
              const SizedBox(height: 12),
              if (_rateType == RateType.percent)
                TextField(
                  controller: _rate,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Taux', suffixText: '%', helperText: 'Ex. 7,5'),
                )
              else
                TextField(
                  controller: _fixed,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Montant par opération', suffixText: 'FCFA'),
                ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: const Text('Premier jour'),
                subtitle: Text(_day.format(_from)),
                onTap: () async {
                  final d = await _pick(_from);
                  if (d != null) setState(() => _from = d);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_busy),
                title: const Text('Dernier jour'),
                subtitle: Text(_lastDay == null ? 'Sans fin' : _day.format(_lastDay!)),
                trailing: _lastDay == null
                    ? null
                    : IconButton(
                        tooltip: 'Sans fin',
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _lastDay = null),
                      ),
                onTap: () async {
                  final d = await _pick(_lastDay ?? _from);
                  if (d != null) setState(() => _lastDay = d);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                value: _active,
                onChanged: (v) => setState(() => _active = v),
              ),
              if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Annuler')),
        FilledButton(onPressed: _saving ? null : _save, child: const Text('Enregistrer')),
      ],
    );
  }
}

const _actionLabels = {
  CommissionStatus.invoiced: 'Marquer facturées',
  CommissionStatus.paid: 'Marquer payées',
  CommissionStatus.waived: 'Offrir',
  CommissionStatus.due: 'Annuler la facture',
};

/// Registre des commissions : suivi par statut et par partenaire.
class CommissionsRegistryTab extends ConsumerStatefulWidget {
  const CommissionsRegistryTab({super.key});

  @override
  ConsumerState<CommissionsRegistryTab> createState() => _CommissionsRegistryTabState();
}

class _CommissionsRegistryTabState extends ConsumerState<CommissionsRegistryTab> {
  CommissionStatus _status = CommissionStatus.due;
  final _selected = <String>{};
  bool _busy = false;

  Future<void> _apply(CommissionStatus to) async {
    String? note;
    if (to == CommissionStatus.waived) {
      note = await askNote(
        context,
        title: 'Offrir ${_selected.length} commission(s)',
        confirmLabel: 'Offrir',
        help: 'Les commissions offertes ne seront pas réclamées au partenaire.',
      );
      if (note == null) return;
    }
    setState(() => _busy = true);
    try {
      final ids = _selected.toList();
      // La fonction traite 100 commissions par appel.
      for (var i = 0; i < ids.length; i += 100) {
        await ref
            .read(billingRepositoryProvider)
            .updateCommissionStatus(ids.sublist(i, i + 100 > ids.length ? ids.length : i + 100), to, note: note);
      }
      setState(_selected.clear);
    } catch (e) {
      if (mounted) showAdminError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final commissions = ref.watch(commissionsByStatusProvider(_status));
    final actions = CommissionStatus.values.where(_status.canMoveTo).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<CommissionStatus>(
            segments: [for (final s in CommissionStatus.values) ButtonSegment(value: s, label: Text(s.label(l10n)))],
            selected: {_status},
            onSelectionChanged: (s) => setState(() {
              _status = s.first;
              _selected.clear();
            }),
          ),
        ),
        Expanded(
          child: commissions.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Chargement impossible : $e')),
            data: (list) {
              if (list.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Aucune commission dans cette catégorie. Les commissions sont calculées '
                      'automatiquement à la fin de chaque séjour réservé via ZAKA.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              final byPartner = <String, List<Commission>>{};
              for (final c in list) {
                byPartner.putIfAbsent(c.orgName ?? c.orgId, () => []).add(c);
              }
              final partners = byPartner.entries.toList()..sort((a, b) => totalOf(b.value).compareTo(totalOf(a.value)));
              return ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  ListTile(
                    title: Text('${list.length} commission(s) · total ${totalOf(list).format()}'),
                    subtitle: list.length == 200 ? const Text('Seules les 200 plus récentes sont affichées.') : null,
                  ),
                  ExpansionTile(
                    title: const Text('Par partenaire'),
                    children: [
                      for (final p in partners)
                        ListTile(
                          dense: true,
                          title: Text(p.key),
                          trailing: Text('${totalOf(p.value).format()} (${p.value.length})'),
                          onTap: actions.isEmpty
                              ? null
                              : () => setState(
                                  () => _selected
                                    ..clear()
                                    ..addAll(p.value.map((c) => c.id)),
                                ),
                        ),
                    ],
                  ),
                  if (actions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('${_selected.length} sélectionnée(s)'),
                          TextButton(
                            onPressed: () => setState(
                              () => _selected
                                ..clear()
                                ..addAll(list.map((c) => c.id)),
                            ),
                            child: const Text('Tout sélectionner'),
                          ),
                          for (final to in actions)
                            OutlinedButton(
                              onPressed: _busy || _selected.isEmpty ? null : () => _apply(to),
                              child: Text(_actionLabels[to]!),
                            ),
                        ],
                      ),
                    ),
                  for (final c in list)
                    CheckboxListTile(
                      value: _selected.contains(c.id),
                      onChanged: actions.isEmpty
                          ? null
                          : (v) => setState(() => v == true ? _selected.add(c.id) : _selected.remove(c.id)),
                      title: Text('${c.amount.format()} · ${c.orgName ?? c.orgId}'),
                      subtitle: Text(
                        [
                          if (c.createdAt != null) _day.format(c.createdAt!),
                          'sur ${c.baseAmount.format()}',
                          if (c.source != null) '${c.source!.type} ${c.source!.id}',
                          if (c.statusNote != null) c.statusNote!,
                        ].join(' · '),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
