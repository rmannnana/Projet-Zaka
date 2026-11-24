import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../billing/data/billing_repository.dart';
import '../../billing/presentation/billing_labels.dart';
import '../data/organization_repository.dart';
import '../domain/organization.dart';
import 'org_labels.dart';
import 'org_profile_form.dart';

/// Tableau de bord d'un espace publieur.
class OrgScreen extends ConsumerWidget {
  const OrgScreen({super.key, required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final org = ref.watch(organizationProvider(orgId));

    return Scaffold(
      appBar: AppBar(title: Text(org.value?.name ?? '')),
      body: org.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (org) {
          if (org == null) return Center(child: Text(l10n.orgNotFound));
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListTile(
                leading: CircleAvatar(child: Icon(org.type.icon)),
                title: Text(org.name, style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text('${org.type.label(l10n)} · ${org.contact.city}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _StatusCard(org: org),
              ),
              const SizedBox(height: 8),
              if (org.type.requiresDocuments)
                ListTile(
                  leading: const Icon(Icons.folder_shared_outlined),
                  title: Text(l10n.verificationFile),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/pro/$orgId/dossier'),
                ),
              ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: Text(l10n.orgEditProfile),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/pro/$orgId/profil'),
              ),
              if (org.type.requiresDocuments)
                ListTile(
                  leading: const Icon(Icons.group_outlined),
                  title: Text(l10n.orgMembers),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/pro/$orgId/membres'),
                ),
              ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: Text(l10n.billingSubscription),
                subtitle: _SubscriptionSummary(orgId: orgId),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/pro/$orgId/abonnement'),
              ),
              // Au MVP, seules les réservations d'hôtel génèrent des commissions.
              if (org.type == OrgType.hotel)
                ListTile(
                  leading: const Icon(Icons.percent),
                  title: Text(l10n.commissionsTitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/pro/$orgId/commissions'),
                ),
              ListTile(
                enabled: false,
                leading: const Icon(Icons.list_alt),
                title: Text(l10n.orgListings),
                subtitle: Text(l10n.comingSoon),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// « Gratuit » ou « Hôtel Pro · jusqu'au 24 décembre 2026 ».
class _SubscriptionSummary extends ConsumerWidget {
  const _SubscriptionSummary({required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subscription = ref.watch(orgSubscriptionProvider(orgId)).value;
    if (subscription == null || !subscription.isRunningAt(DateTime.now())) {
      return Text(l10n.billingFree);
    }
    return Text(
      l10n.billingPlanUntil(
        subscription.planSnapshot.name,
        billingDate.format(subscription.currentPeriodEnd!),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.org});

  final Organization org;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final v = org.verification;
    final date = DateFormat.yMMMMd('fr');
    final isIndividual = !org.type.requiresDocuments;

    final (String text, String? action) = switch (v.status) {
      VerificationStatus.draft => (l10n.statusDraftHelp, l10n.verificationComplete),
      VerificationStatus.pending => (
        v.submittedAt == null
            ? l10n.statusPendingHelp
            : l10n.statusPendingSince(date.format(v.submittedAt!)),
        null,
      ),
      VerificationStatus.verified => (
        isIndividual ? l10n.statusVerifiedIndividualHelp : l10n.statusVerifiedHelp,
        null,
      ),
      VerificationStatus.rejected => (l10n.statusRejectedHelp(v.note ?? '-'), l10n.verificationFix),
      VerificationStatus.suspended => (l10n.statusSuspendedHelp(v.note ?? '-'), null),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerificationStatusChip(v.status),
            const SizedBox(height: 8),
            Text(text),
            if (action != null) ...[
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => context.push('/pro/${org.id}/dossier'),
                child: Text(action),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Modification du profil public d'un espace.
class EditOrgScreen extends ConsumerWidget {
  const EditOrgScreen({super.key, required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final org = ref.watch(organizationProvider(orgId)).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.orgEditProfile)),
      body: org == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    OrgProfileForm(
                      type: org.type,
                      submitLabel: l10n.save,
                      initial: OrgProfileValues(
                        name: org.name,
                        description: org.description,
                        contact: org.contact,
                      ),
                      onSubmit: (values) async {
                        try {
                          await ref.read(organizationRepositoryProvider).updateProfile(
                            orgId,
                            name: values.name,
                            description: values.description,
                            contact: values.contact,
                          );
                          if (context.mounted) context.pop();
                          return null;
                        } catch (e) {
                          return functionErrorMessage(e);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
