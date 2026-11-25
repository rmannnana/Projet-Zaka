import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../billing/data/billing_repository.dart';
import '../../billing/domain/billing.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/domain/listing.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../organizations/data/organization_repository.dart';
import '../../organizations/domain/organization.dart';
import 'editor_widgets.dart';

/// Ligne commune aux hôtels, biens et programmes dans l'espace pro.
class _Row {
  const _Row({
    required this.kind,
    required this.id,
    required this.title,
    required this.photo,
    required this.status,
    required this.featured,
    required this.stats,
    this.subtitle,
    this.reason,
  });

  final ListingKind kind;
  final String id;
  final String title;
  final String? photo;
  final ListingStatus status;
  final bool featured;
  final ListingStats stats;
  final String? subtitle;
  final String? reason;

  /// Compte dans la limite d'annonces du plan (comme côté serveur).
  bool get counted => status.isPublic || status == ListingStatus.pendingReview;
}

/// Annonces d'un espace pro : état, statistiques, mise en ligne, mise en avant.
class ProListingsScreen extends ConsumerWidget {
  const ProListingsScreen({super.key, required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final org = ref.watch(organizationProvider(orgId)).value;
    if (org == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final rows = <_Row>[
      if (org.canPublishHotels)
        for (final h in ref.watch(orgHotelsProvider(orgId)).value ?? const <Hotel>[])
          _Row(
            kind: ListingKind.hotel,
            id: h.id,
            title: h.name.isEmpty ? l10n.untitledHotel : h.name,
            photo: h.cover,
            status: h.status,
            featured: h.featured,
            stats: h.stats,
            subtitle: [
              l10n.roomTypesCount(h.roomTypesCount),
              if (h.acceptanceRate != null) l10n.acceptanceRate((h.acceptanceRate! * 100).round()),
            ].join(' · '),
            reason: h.moderation?.reason,
          ),
      if (org.canPublishProperties)
        for (final p in ref.watch(orgPropertiesProvider(orgId)).value ?? const <Property>[])
          _Row(
            kind: ListingKind.property,
            id: p.id,
            title: p.title.isEmpty ? l10n.untitledListing : p.title,
            photo: p.cover,
            status: p.status,
            featured: p.featured,
            stats: p.stats,
            subtitle: p.price.amount > 0 ? p.priceLabel(l10n) : null,
            reason: p.moderation?.reason,
          ),
      if (org.canPublishProjects)
        for (final p in ref.watch(orgProjectsProvider(orgId)).value ?? const <Project>[])
          _Row(
            kind: ListingKind.project,
            id: p.id,
            title: p.title.isEmpty ? l10n.untitledProject : p.title,
            photo: p.cover,
            status: p.status,
            featured: p.featured,
            stats: p.stats,
            subtitle: l10n.unitsAvailableValue(p.unitsAvailable, p.unitsCount),
            reason: p.moderation?.reason,
          ),
    ];

    final now = DateTime.now();
    final subscription = ref.watch(orgSubscriptionProvider(orgId)).value;
    final plan = effectivePlan(subscription, ref.watch(freePlanProvider).value, now);
    final max = plan?.features.maxListings;
    final online = rows.where((r) => r.counted).length;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myListings)),
      floatingActionButton: org.isVerified
          ? FloatingActionButton.extended(
              onPressed: () => _create(context, ref, org),
              icon: const Icon(Icons.add),
              label: Text(l10n.newListing),
            )
          : null,
      body: Readable(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            if (!org.isVerified)
              Card.filled(
                child: ListTile(leading: const Icon(Icons.info_outline), title: Text(l10n.listingsNeedVerification)),
              ),
            if (org.requiresListingReview)
              Card.filled(
                child: ListTile(leading: const Icon(Icons.fact_check_outlined), title: Text(l10n.listingsReviewedByZaka)),
              ),
            Card.outlined(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium_outlined),
                title: Text(max == null ? l10n.listingsOnlineUnlimited(online) : l10n.listingsOnline(online, max)),
                subtitle: Text(l10n.planLabel(plan?.name ?? l10n.billingFree)),
                trailing: TextButton(onPressed: () => context.push('/pro/$orgId/abonnement'), child: Text(l10n.changePlan)),
              ),
            ),
            const SizedBox(height: 8),
            if (rows.isEmpty)
              EmptyState(
                icon: Icons.add_home_work_outlined,
                title: l10n.noListingYet,
                body: org.isVerified ? l10n.noListingYetHint : null,
              ),
            for (final r in rows) _ListingTile(orgId: orgId, org: org, row: r),
          ],
        ),
      ),
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref, Organization org) async {
    final l10n = AppLocalizations.of(context);
    var kind = org.canPublishHotels ? ListingKind.hotel : ListingKind.property;
    if (org.canPublishProjects) {
      final picked = await showModalBottomSheet<ListingKind>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.home_work_outlined),
                title: Text(l10n.newProperty),
                onTap: () => Navigator.pop(context, ListingKind.property),
              ),
              ListTile(
                leading: const Icon(Icons.domain),
                title: Text(l10n.newProjectListing),
                onTap: () => Navigator.pop(context, ListingKind.project),
              ),
            ],
          ),
        ),
      );
      if (picked == null) return;
      kind = picked;
    }
    try {
      final id = await ref.read(listingsRepositoryProvider).createDraft(kind, org, {
        if (kind == ListingKind.hotel) 'name': org.name,
        'city': org.contact.city,
      });
      if (context.mounted) context.push('/pro/$orgId/annonces/${kind.slug}/$id');
    } catch (e) {
      if (context.mounted) showResult(context, functionErrorMessage(e), error: true);
    }
  }
}

class _ListingTile extends ConsumerWidget {
  const _ListingTile({required this.orgId, required this.org, required this.row});

  final String orgId;
  final Organization org;
  final _Row row;

  Future<void> _run(BuildContext context, Future<String?> Function() action) async {
    try {
      final message = await action();
      if (message != null && context.mounted) showResult(context, message);
    } catch (e) {
      if (context.mounted) showResult(context, functionErrorMessage(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final repo = ref.read(listingsRepositoryProvider);
    final r = row;
    final isProperty = r.kind == ListingKind.property;
    final isProject = r.kind == ListingKind.project;
    final publicPath = switch (r.kind) {
      ListingKind.hotel => '/hotel/${r.id}',
      ListingKind.property => '/bien/${r.id}',
      ListingKind.project => '/programme/${r.id}',
    };

    final actions = <(String, Future<String?> Function())>[
      if (r.status.canPublish)
        (
          org.requiresListingReview ? l10n.sendForReview : l10n.publish,
          () async {
            final status = await repo.publish(r.kind, r.id);
            return status == ListingStatus.pendingReview ? l10n.sentForReview : l10n.publishedNow;
          },
        ),
      if (isProperty && r.status == ListingStatus.published)
        (l10n.markUnderOffer, () async {
          await repo.setStatus(r.kind, r.id, ListingStatus.underOffer);
          return null;
        }),
      if (isProperty && (r.status == ListingStatus.published || r.status == ListingStatus.underOffer))
        (l10n.markRentedOrSold, () async {
          // Le type (location ou vente) est lu sur la fiche ; « louée » par défaut pour une location.
          final p = await ref.read(propertyProvider(r.id).future);
          await repo.setStatus(r.kind, r.id, p?.transactionType == TransactionType.sale ? ListingStatus.sold : ListingStatus.rented);
          return null;
        }),
      if (isProperty && r.status == ListingStatus.underOffer)
        (l10n.backOnline, () async {
          await repo.publish(r.kind, r.id);
          return null;
        }),
      if (isProject && r.status == ListingStatus.published)
        (l10n.markInProgress, () async {
          await repo.setStatus(r.kind, r.id, ListingStatus.inProgress);
          return null;
        }),
      if (isProject && (r.status == ListingStatus.published || r.status == ListingStatus.inProgress))
        (l10n.markDelivered, () async {
          await repo.setStatus(r.kind, r.id, ListingStatus.delivered);
          return null;
        }),
      if (r.status.isPublic)
        (r.featured ? l10n.unfeature : l10n.feature, () async {
          await repo.setFeatured(r.kind, r.id, !r.featured);
          return r.featured ? null : l10n.featuredNow;
        }),
      if (r.status.isPublic)
        (l10n.takeOffline, () async {
          await repo.setStatus(r.kind, r.id, ListingStatus.inactive);
          return l10n.takenOffline;
        }),
    ];

    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: r.status == ListingStatus.suspended || r.status == ListingStatus.pendingReview
            ? null
            : () => context.push('/pro/$orgId/annonces/${r.kind.slug}/${r.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(width: 96, height: 72, child: NetImage(r.photo)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                    if (r.subtitle != null && r.subtitle!.isNotEmpty) Text(r.subtitle!, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusPill(r.status.label(l10n), r.status.color(scheme)),
                        if (r.featured) StatusPill(l10n.featured, scheme.secondary),
                        Text(
                          r.kind == ListingKind.hotel
                              ? l10n.statsHotel(r.stats.views, r.stats.requests)
                              : l10n.statsListing(r.stats.views, r.stats.leads),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (r.reason != null && (r.status == ListingStatus.rejected || r.status == ListingStatus.suspended))
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(l10n.moderationReason(r.reason!), style: TextStyle(color: scheme.error)),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<int>(
                onSelected: (i) {
                  if (i == -1) {
                    context.push(publicPath);
                  } else {
                    _run(context, actions[i].$2);
                  }
                },
                itemBuilder: (_) => [
                  for (final (i, a) in actions.indexed) PopupMenuItem(value: i, child: Text(a.$1)),
                  if (r.status.isPublic) PopupMenuItem(value: -1, child: Text(l10n.seePublicListing)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
