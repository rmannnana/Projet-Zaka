import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/admin_repository.dart';

final _date = DateFormat('d MMM yyyy, HH:mm:ss', 'fr');

/// Libellés lisibles des actions enregistrées par les Cloud Functions.
const _actionLabels = {
  'organization.create': 'Création du compte',
  'organization.submitVerification': 'Envoi du dossier',
  'organization.verify': 'Compte validé',
  'organization.reject': 'Dossier refusé',
  'organization.suspend': 'Compte suspendu',
  'organization.reinstate': 'Compte rétabli',
  'organization.addMember': 'Membre ajouté',
  'organization.removeMember': 'Membre retiré',
  'user.setRole': 'Rôle modifié',
  'privacy.deleteUserData': 'Données personnelles effacées',
  'privacy.refuseDeletion': 'Demande de suppression refusée',
  'subscriptionPlan.create': "Plan d'abonnement créé",
  'subscriptionPlan.update': "Plan d'abonnement modifié",
  'commissionRule.create': 'Règle de commission créée',
  'commissionRule.update': 'Règle de commission modifiée',
  'subscription.activate': 'Abonnement activé',
  'subscription.renew': 'Abonnement renouvelé',
  'subscription.expire': 'Abonnement arrivé à échéance',
  'commission.invoiced': 'Commission facturée',
  'commission.paid': 'Commission payée',
  'commission.waived': 'Commission offerte',
  'commission.due': 'Facture de commission annulée',
  'listing.publish': 'Annonce publiée après validation',
  'listing.reject': 'Annonce refusée',
  'listing.suspend': 'Annonce suspendue',
  'listing.reinstate': 'Annonce rétablie',
  'booking.accept': 'Réservation acceptée',
  'booking.reject': 'Réservation refusée',
  'booking.request_info': 'Précisions demandées au client',
  'booking.complete': 'Séjour terminé',
  'booking.cancel': "Réservation annulée par l'hôtel",
  'dispute.export': 'Dossier de litige exporté',
};

/// Journal d'activité complet (100 dernières opérations sensibles).
class AuditScreen extends StatelessWidget {
  const AuditScreen({super.key});

  @override
  Widget build(BuildContext context) => const AuditList();
}

/// Liste des entrées du journal, éventuellement limitée à un document.
class AuditList extends ConsumerWidget {
  const AuditList({super.key, this.targetRef});

  final String? targetRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(auditProvider(targetRef));
    return entries.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Chargement impossible : $e')),
      data: (entries) => entries.isEmpty
          ? const Center(child: Text('Aucune entrée.'))
          : ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final e = entries[i];
                final action = e.str('action') ?? '';
                final at = e.date('at');
                return ExpansionTile(
                  title: Text(_actionLabels[action] ?? action),
                  subtitle: Text(
                    '${at == null ? '' : _date.format(at)} · par ${e.str('actorUid') ?? '?'}'
                    '${targetRef == null ? '\n${e.str('targetRef') ?? ''}' : ''}',
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (e.data['before'] != null) SelectableText('Avant : ${e.data['before']}'),
                    if (e.data['after'] != null) SelectableText('Après : ${e.data['after']}'),
                  ],
                );
              },
            ),
    );
  }
}
