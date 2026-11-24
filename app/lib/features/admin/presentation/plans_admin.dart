import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../billing/data/billing_repository.dart';
import '../../billing/domain/billing.dart';
import '../../billing/presentation/billing_labels.dart';
import '../../organizations/data/organization_repository.dart';

const planTargetLabels = {
  PlanTarget.hotel: 'Hôtels',
  PlanTarget.realEstate: 'Immobilier (agences, promoteurs, particuliers)',
  PlanTarget.all: 'Tous les comptes',
};

/// Grille des plans d'abonnement.
class PlansTab extends ConsumerWidget {
  const PlansTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plans = ref.watch(allPlansProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showPlanDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau plan'),
      ),
      body: plans.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Chargement impossible : $e')),
        data: (plans) => ListView(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Le plan Gratuit s'applique à tout compte sans abonnement payant. "
                "Modifier un plan ne change pas les abonnements déjà payés : ils gardent "
                "les conditions du jour de leur paiement jusqu'à leur échéance.",
              ),
            ),
            if (!plans.any((p) => p.isFree))
              ListTile(
                leading: const Icon(Icons.warning_amber),
                title: const Text("Le plan Gratuit n'existe pas encore."),
                trailing: FilledButton(
                  onPressed: () => showPlanDialog(context, createFree: true),
                  child: const Text('Le créer'),
                ),
              ),
            for (final plan in plans)
              ListTile(
                leading: Icon(plan.isFree ? Icons.card_giftcard : Icons.workspace_premium_outlined),
                title: Text(plan.active ? plan.name : '${plan.name} (désactivé)'),
                subtitle: Text(
                  [
                    plan.priceLabel(l10n),
                    planTargetLabels[plan.target],
                    ...plan.featureLabels(l10n),
                  ].join(' · '),
                ),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () => showPlanDialog(context, plan: plan),
              ),
          ],
        ),
      ),
    );
  }
}

/// Crée ([plan] absent) ou modifie un plan.
Future<void> showPlanDialog(BuildContext context, {SubscriptionPlan? plan, bool createFree = false}) =>
    showDialog<void>(
      context: context,
      builder: (_) => _PlanDialog(plan: plan, createFree: createFree),
    );

class _PlanDialog extends ConsumerStatefulWidget {
  const _PlanDialog({this.plan, this.createFree = false});

  final SubscriptionPlan? plan;
  final bool createFree;

  @override
  ConsumerState<_PlanDialog> createState() => _PlanDialogState();
}

class _PlanDialogState extends ConsumerState<_PlanDialog> {
  late final bool _free = widget.createFree || (widget.plan?.isFree ?? false);
  late final _name = TextEditingController(text: widget.plan?.name ?? (_free ? 'Gratuit' : ''));
  late final _description = TextEditingController(text: widget.plan?.description ?? '');
  late final _price = TextEditingController(
    text: _free ? '0' : (widget.plan == null ? '' : '${widget.plan!.price.amount}'),
  );
  late final _maxListings = TextEditingController(
    text: widget.plan?.features.maxListings?.toString() ?? (widget.plan == null ? '3' : ''),
  );
  late final _featured = TextEditingController(text: '${widget.plan?.features.featuredListings ?? 0}');
  late PlanPeriod _period = widget.plan?.period ?? PlanPeriod.month;
  late PlanTarget _target = _free ? PlanTarget.all : widget.plan?.target ?? PlanTarget.hotel;
  late bool _advancedStats = widget.plan?.features.advancedStats ?? false;
  late bool _active = widget.plan?.active ?? true;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _description, _price, _maxListings, _featured]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final price = int.tryParse(_price.text.trim());
    final featured = int.tryParse(_featured.text.trim());
    final maxText = _maxListings.text.trim();
    final maxListings = maxText.isEmpty ? null : int.tryParse(maxText);
    String? problem;
    if (_name.text.trim().length < 2) {
      problem = 'Indiquez un nom.';
    } else if (price == null) {
      problem = 'Indiquez le prix en FCFA (nombre entier).';
    } else if (!_free && price <= 0) {
      problem = 'Un plan payant doit avoir un prix supérieur à 0.';
    } else if (featured == null) {
      problem = "Indiquez le nombre d'annonces mises en avant (0 si aucune).";
    } else if (maxText.isNotEmpty && maxListings == null) {
      problem = "Nombre d'annonces invalide.";
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
      await ref.read(billingRepositoryProvider).savePlan(
        {
          'name': _name.text.trim(),
          'description': _description.text.trim(),
          'price': price,
          'period': _period.name,
          'target': _target == PlanTarget.realEstate ? 'real_estate' : _target.name,
          'features': {
            'maxListings': maxListings,
            'featuredListings': featured,
            'advancedStats': _advancedStats,
          },
          'active': _active,
        },
        planId: widget.plan?.id ?? (widget.createFree ? freePlanId : null),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = functionErrorMessage(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final digits = [FilteringTextInputFormatter.digitsOnly];
    return AlertDialog(
      title: Text(widget.plan == null ? 'Nouveau plan' : 'Modifier le plan'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_free)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text('Plan de base : il reste gratuit, actif et ouvert à tous les comptes.'),
                ),
              TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nom')),
              const SizedBox(height: 12),
              TextField(
                controller: _description,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description (facultatif)'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _price,
                      enabled: !_free,
                      inputFormatters: digits,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Prix', suffixText: 'FCFA'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SegmentedButton<PlanPeriod>(
                    segments: const [
                      ButtonSegment(value: PlanPeriod.month, label: Text('Mois')),
                      ButtonSegment(value: PlanPeriod.year, label: Text('An')),
                    ],
                    selected: {_period},
                    onSelectionChanged: (s) => setState(() => _period = s.first),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<PlanTarget>(
                initialValue: _target,
                decoration: const InputDecoration(labelText: 'Pour'),
                items: [
                  for (final e in planTargetLabels.entries)
                    DropdownMenuItem(value: e.key, child: Text(e.value)),
                ],
                onChanged: _free ? null : (v) => setState(() => _target = v!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _maxListings,
                      inputFormatters: digits,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Annonces publiées',
                        helperText: 'Vide : illimité',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _featured,
                      inputFormatters: digits,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Mises en avant'),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Statistiques détaillées'),
                value: _advancedStats,
                onChanged: (v) => setState(() => _advancedStats = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Proposé aux pros'),
                subtitle: const Text('Désactivé : plus proposé, les abonnements en cours continuent.'),
                value: _active,
                onChanged: _free ? null : (v) => setState(() => _active = v),
              ),
              if (_error != null)
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
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
