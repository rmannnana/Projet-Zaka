import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/catalog.dart';
import '../../../core/links.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../account/data/account_requests_repository.dart';
import '../../account/presentation/report_dialog.dart';
import '../../hotels/presentation/hotel_detail_screen.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/domain/listing.dart';
import '../../listings/presentation/cards.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../requests/domain/requests.dart';
import 'lead_sheet.dart';

/// Fiche d'un bien à louer ou à vendre.
class PropertyDetailScreen extends ConsumerStatefulWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(listingsRepositoryProvider).recordView(ListingKind.property, widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final property = ref.watch(propertyProvider(widget.propertyId));
    final types = ref.watch(propertyTypesProvider).value ?? const <PropertyType>[];
    final amenities = ref.watch(amenitiesProvider).value ?? const <Amenity>[];

    return property.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => ListingUnavailable(message: l10n.listingUnavailable),
      data: (p) {
        if (p == null) return ListingUnavailable(message: l10n.listingUnavailable);
        final place = placeOf(p.district, p.city);
        final specs = propertySpecs(l10n, p);
        void lead(LeadType type) => showLeadSheet(
          context,
          ref,
          targetType: 'property',
          targetId: p.id,
          title: p.title,
          type: type,
        );

        return Scaffold(
          bottomNavigationBar: BottomActionBar(
            price: null,
            actions: [
              IconButton.outlined(
                tooltip: l10n.leadTypeContact,
                onPressed: () => lead(LeadType.contact),
                icon: const Icon(Icons.chat_bubble_outline),
                style: IconButton.styleFrom(
                  minimumSize: const Size(52, 52),
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: ZakaPalette.of(context).line, width: 1.2),
                ),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
                onPressed: () => lead(LeadType.visit),
                icon: const Icon(Icons.event_available_outlined),
                label: Text(l10n.askVisit),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              DetailHeader(
                photos: p.photos,
                icon: Icons.home_work_outlined,
                actions: [
                  FavoriteButton(
                    onImage: true,
                    targetId: p.id,
                    favorite: Favorite(
                      targetType: ListingKind.property,
                      title: p.title,
                      photo: p.cover,
                      city: p.city,
                      price: p.price,
                    ),
                  ),
                  ListingMoreButton(
                    onReport: () => showReportDialog(context, ref, target: ReportTarget.property, targetId: p.id),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Readable(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            TagBadge(label: p.transactionLabel(l10n)),
                            if (p.propertyType.isNotEmpty) TagBadge(label: types.label(p.propertyType), tone: BadgeTone.light),
                            if (p.status == ListingStatus.underOffer)
                              TagBadge(label: l10n.listingUnderOffer, tone: BadgeTone.gold),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(p.title, style: theme.textTheme.headlineSmall),
                        if (place.isNotEmpty) ...[const SizedBox(height: 4), PlaceLine(place)],
                        const SizedBox(height: 10),
                        Text(
                          p.priceLabel(l10n),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (specs.isNotEmpty) ...[const SizedBox(height: 16), SpecsPanel(specs.take(3).toList())],
                        if (p.description.isNotEmpty) ...[
                          DetailHeading(l10n.description),
                          Text(p.description),
                        ],
                        if (p.features.isNotEmpty) ...[
                          DetailHeading(l10n.features),
                          FeatureGrid([for (final id in p.features) (amenityIcon(id), amenities.label(id))]),
                        ],
                        if (p.transactionType == TransactionType.rent &&
                            (p.conditions.deposit.isNotEmpty ||
                                p.conditions.advance.isNotEmpty ||
                                p.conditions.agencyFees.isNotEmpty)) ...[
                          DetailHeading(l10n.rentConditions),
                          if (p.conditions.deposit.isNotEmpty) InfoRow(Icons.savings_outlined, l10n.depositValue(p.conditions.deposit)),
                          if (p.conditions.advance.isNotEmpty) InfoRow(Icons.payments_outlined, l10n.advanceValue(p.conditions.advance)),
                          if (p.conditions.agencyFees.isNotEmpty)
                            InfoRow(Icons.receipt_long_outlined, l10n.agencyFeesValue(p.conditions.agencyFees)),
                        ],
                        DetailHeading(l10n.location),
                        InfoRow(
                          Icons.map_outlined,
                          [p.address, place].where((s) => s.isNotEmpty).join(', '),
                          onTap: () => openMap([p.address, place].where((s) => s.isNotEmpty).join(', ')),
                        ),
                        DetailHeading(l10n.publisher),
                        _PublisherCard(
                          name: p.orgName ?? '',
                          individual: p.byIndividual,
                        ),
                        const SizedBox(height: 16),
                        Text(l10n.realEstateDisclaimer, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PublisherCard extends StatelessWidget {
  const _PublisherCard({required this.name, required this.individual});

  final String name;
  final bool individual;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = ZakaPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: palette.mint,
              foregroundColor: palette.onMint,
              child: Icon(individual ? Icons.person_outline : Icons.real_estate_agent_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        individual ? Icons.person_outline : Icons.verified,
                        size: 15,
                        color: individual ? palette.muted : scheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          individual ? l10n.orgTypeIndividual : l10n.verifiedProfessional,
                          style: TextStyle(fontSize: 12.5, color: individual ? palette.muted : scheme.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fiche d'un programme immobilier neuf et de ses lots.
class ProjectDetailScreen extends ConsumerStatefulWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(listingsRepositoryProvider).recordView(ListingKind.project, widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);
    final project = ref.watch(projectProvider(widget.projectId));
    final units = ref.watch(unitsProvider(widget.projectId)).value ?? const <ProjectUnit>[];
    final types = ref.watch(propertyTypesProvider).value ?? const <PropertyType>[];

    return project.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => ListingUnavailable(message: l10n.listingUnavailable),
      data: (p) {
        if (p == null) return ListingUnavailable(message: l10n.listingUnavailable);
        final place = placeOf(p.district, p.city);
        void ask({String? unitId, String? unitLabel}) => showLeadSheet(
          context,
          ref,
          targetType: 'project',
          targetId: p.id,
          title: p.title,
          type: LeadType.info,
          unitId: unitId,
          unitLabel: unitLabel,
        );
        return Scaffold(
          bottomNavigationBar: BottomActionBar(
            price: p.priceLabel(l10n),
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 50)),
                onPressed: ask,
                child: Text(l10n.askInformation),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              DetailHeader(
                photos: p.photos,
                icon: Icons.domain,
                actions: [
                  FavoriteButton(
                    onImage: true,
                    targetId: p.id,
                    favorite: Favorite(targetType: ListingKind.project, title: p.title, photo: p.cover, city: p.city, price: p.priceFrom),
                  ),
                  ListingMoreButton(
                    onReport: () => showReportDialog(context, ref, target: ReportTarget.project, targetId: p.id),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Readable(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(spacing: 6, runSpacing: 6, children: [
                          TagBadge(label: l10n.newProject),
                          TagBadge(label: p.status.label(l10n), tone: BadgeTone.light),
                        ]),
                        const SizedBox(height: 10),
                        Text(p.title, style: theme.textTheme.headlineSmall),
                        if (place.isNotEmpty) ...[const SizedBox(height: 4), PlaceLine(place)],
                        const SizedBox(height: 16),
                        SpecsPanel([
                          (Icons.apartment, l10n.unitsLeft(p.unitsAvailable)),
                          if (p.deliveryDate.isNotEmpty) (Icons.event_available, p.deliveryDate),
                        ]),
                        if (p.estimatedBudget != null) ...[
                          const SizedBox(height: 8),
                          InfoRow(Icons.account_balance_outlined, l10n.budgetValue(p.estimatedBudget!.format())),
                        ],
                        if (p.description.isNotEmpty) ...[
                          DetailHeading(l10n.description),
                          Text(p.description),
                        ],
                        DetailHeading(l10n.units),
                        if (units.isEmpty) Text(l10n.noUnitYet),
                        for (final u in units)
                          Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  IconTile(icon: Icons.door_front_door_outlined, background: palette.mint, foreground: palette.onMint),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          [u.label, if (u.propertyType.isNotEmpty) types.label(u.propertyType)].join(' · '),
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          [
                                            if (u.surface != null) l10n.surfaceValue(u.surface!),
                                            if (u.rooms != null) l10n.roomsValue(u.rooms!),
                                          ].join(' · '),
                                          style: theme.textTheme.bodySmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          u.price.format(),
                                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (u.status == UnitStatus.available)
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 40)),
                                      onPressed: () => ask(unitId: u.id, unitLabel: u.label),
                                      child: Text(l10n.interested),
                                    )
                                  else
                                    StatusPill(u.status.label(l10n), u.status.color(theme.colorScheme)),
                                ],
                              ),
                            ),
                          ),
                        DetailHeading(l10n.location),
                        InfoRow(
                          Icons.map_outlined,
                          [p.address, place].where((s) => s.isNotEmpty).join(', '),
                          onTap: () => openMap([p.address, place].where((s) => s.isNotEmpty).join(', ')),
                        ),
                        if (p.orgName != null) InfoRow(Icons.domain, l10n.publishedBy(p.orgName!)),
                        const SizedBox(height: 16),
                        Text(l10n.realEstateDisclaimer, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
