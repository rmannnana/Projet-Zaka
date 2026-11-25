import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../billing/data/billing_repository.dart';
import '../../billing/presentation/billing_labels.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/domain/listing.dart';
import '../../requests/data/requests_repository.dart';
import '../../requests/domain/requests.dart';
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
      appBar: AppBar(title: Text(l10n.proSpaces)),
      body: org.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (org) {
          if (org == null) return EmptyState(icon: Icons.search_off, title: l10n.orgNotFound);
          final isHotel = org.type == OrgType.hotel;
          return Readable(
            maxWidth: 760,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              children: [
                _Header(org: org),
                const SizedBox(height: 14),
                _StatusCard(org: org),
                const SizedBox(height: 14),
                _Stats(org: org),
                MenuGroup(
                  title: l10n.orgSectionActivity,
                  children: [
                    MenuTile(
                      icon: Icons.list_alt,
                      title: l10n.myListings,
                      subtitle: org.isVerified ? l10n.myListingsHint : l10n.listingsNeedVerification,
                      onTap: () => context.push('/pro/$orgId/annonces'),
                    ),
                    if (isHotel)
                      MenuTile(
                        icon: Icons.event_available_outlined,
                        title: l10n.receivedBookings,
                        onTap: () => context.push('/pro/$orgId/reservations'),
                      )
                    else
                      MenuTile(
                        icon: Icons.forum_outlined,
                        title: l10n.receivedLeads,
                        onTap: () => context.push('/pro/$orgId/contacts'),
                      ),
                  ],
                ),
                MenuGroup(
                  title: l10n.orgSectionSpace,
                  children: [
                    MenuTile(
                      icon: Icons.storefront_outlined,
                      title: l10n.orgEditProfile,
                      onTap: () => context.push('/pro/$orgId/profil'),
                    ),
                    if (org.type.requiresDocuments)
                      MenuTile(
                        icon: Icons.folder_shared_outlined,
                        title: l10n.verificationFile,
                        onTap: () => context.push('/pro/$orgId/dossier'),
                      ),
                    if (org.type.requiresDocuments)
                      MenuTile(
                        icon: Icons.group_outlined,
                        title: l10n.orgMembers,
                        onTap: () => context.push('/pro/$orgId/membres'),
                      ),
                  ],
                ),
                MenuGroup(
                  title: l10n.orgSectionBilling,
                  children: [
                    MenuTile(
                      icon: Icons.workspace_premium_outlined,
                      title: l10n.billingSubscription,
                      subtitle: _subscriptionSummary(context, ref),
                      onTap: () => context.push('/pro/$orgId/abonnement'),
                    ),
                    // Au MVP, seules les réservations d'hôtel génèrent des commissions.
                    if (isHotel)
                      MenuTile(
                        icon: Icons.percent,
                        title: l10n.commissionsTitle,
                        onTap: () => context.push('/pro/$orgId/commissions'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// « Gratuit » ou « Hôtel Pro · jusqu'au 24 décembre 2026 ».
  String _subscriptionSummary(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subscription = ref.watch(orgSubscriptionProvider(orgId)).value;
    if (subscription == null || !subscription.isRunningAt(DateTime.now())) return l10n.billingFree;
    return l10n.billingPlanUntil(subscription.planSnapshot.name, billingDate.format(subscription.currentPeriodEnd!));
  }
}

/// Bandeau vert : nom, type, ville et statut de l'espace.
class _Header extends StatelessWidget {
  const _Header({required this.org});

  final Organization org;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BrandCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(org.type.icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  org.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 19, height: 1.2),
                ),
                const SizedBox(height: 3),
                Text(
                  [org.type.label(l10n), if (org.contact.city.isNotEmpty) org.contact.city].join(' · '),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                ),
                const SizedBox(height: 10),
                OnBrandPill(
                  org.verification.status.label(l10n),
                  icon: org.isVerified ? Icons.verified : Icons.schedule,
                  gold: org.isVerified,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chiffres clés : annonces en ligne, demandes à traiter, vues.
class _Stats extends ConsumerWidget {
  const _Stats({required this.org});

  final Organization org;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = org.id;
    final listings = <(ListingStatus, ListingStats)>[
      if (org.canPublishHotels)
        for (final h in ref.watch(orgHotelsProvider(id)).value ?? const <Hotel>[]) (h.status, h.stats),
      if (org.canPublishProperties)
        for (final p in ref.watch(orgPropertiesProvider(id)).value ?? const <Property>[]) (p.status, p.stats),
      if (org.canPublishProjects)
        for (final p in ref.watch(orgProjectsProvider(id)).value ?? const <Project>[]) (p.status, p.stats),
    ];
    final isHotel = org.type == OrgType.hotel;
    final toHandle = isHotel
        ? ref.watch(orgBookingsProvider(id)).value?.where((b) => b.status.isOpen).length
        : ref.watch(orgLeadsProvider(id)).value?.where((l) => l.status == LeadStatus.fresh).length;
    final online = listings.where((l) => l.$1.isPublic).length;
    final views = listings.fold<int>(0, (sum, l) => sum + l.$2.views);
    // Trois chiffres sur une ligne, même sur téléphone.
    return StatGrid(
      minWidth: 110,
      children: [
        StatCard(
          icon: Icons.public,
          value: '$online',
          label: l10n.orgStatListings,
          onTap: () => context.push('/pro/$id/annonces'),
        ),
        StatCard(
          icon: isHotel ? Icons.event_available_outlined : Icons.forum_outlined,
          value: toHandle == null ? '-' : '$toHandle',
          label: l10n.orgStatToHandle,
          tone: Tone.peach,
          highlight: (toHandle ?? 0) > 0,
          onTap: () => context.push(isHotel ? '/pro/$id/reservations' : '/pro/$id/contacts'),
        ),
        StatCard(
          icon: Icons.visibility_outlined,
          value: _compact.format(views),
          label: l10n.orgStatViews,
          tone: Tone.sky,
        ),
      ],
    );
  }
}

final _compact = NumberFormat.compact(locale: 'fr');

/// Statut de vérification, avec l'action à mener s'il y en a une.
class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.org});

  final Organization org;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final v = org.verification;
    final date = DateFormat.yMMMMd('fr');
    final isIndividual = !org.type.requiresDocuments;

    final (String text, String? action, Tone tone, IconData icon) = switch (v.status) {
      VerificationStatus.draft => (l10n.statusDraftHelp, l10n.verificationComplete, Tone.peach, Icons.edit_note),
      VerificationStatus.pending => (
        v.submittedAt == null ? l10n.statusPendingHelp : l10n.statusPendingSince(date.format(v.submittedAt!)),
        null,
        Tone.peach,
        Icons.hourglass_top,
      ),
      VerificationStatus.verified => (
        isIndividual ? l10n.statusVerifiedIndividualHelp : l10n.statusVerifiedHelp,
        null,
        Tone.sage,
        Icons.verified_outlined,
      ),
      VerificationStatus.rejected => (
        l10n.statusRejectedHelp(v.note ?? '-'),
        l10n.verificationFix,
        Tone.danger,
        Icons.error_outline,
      ),
      VerificationStatus.suspended => (l10n.statusSuspendedHelp(v.note ?? '-'), null, Tone.danger, Icons.block),
    };

    return NoticeCard(
      title: v.status.label(l10n),
      text: text,
      icon: icon,
      tone: tone,
      action: action == null
          ? null
          : FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
              onPressed: () => context.push('/pro/${org.id}/dossier'),
              child: Text(action),
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
          : Readable(
              maxWidth: 640,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  OrgProfileForm(
                    type: org.type,
                    submitLabel: l10n.save,
                    initial: OrgProfileValues(name: org.name, description: org.description, contact: org.contact),
                    onSubmit: (values) async {
                      try {
                        await ref
                            .read(organizationRepositoryProvider)
                            .updateProfile(
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
    );
  }
}
