import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/catalog.dart';
import '../../../core/links.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../account/data/account_requests_repository.dart';
import '../../account/presentation/report_dialog.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/domain/listing.dart';
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
      error: (e, _) => Scaffold(appBar: AppBar(), body: EmptyState(icon: Icons.search_off, title: l10n.listingUnavailable)),
      data: (p) {
        if (p == null) {
          return Scaffold(appBar: AppBar(), body: EmptyState(icon: Icons.search_off, title: l10n.listingUnavailable));
        }
        final place = placeOf(p.district, p.city);
        final facts = [
          if (p.surface != null) (Icons.square_foot, l10n.surfaceValue(p.surface!)),
          if (p.rooms != null) (Icons.meeting_room_outlined, l10n.roomsValue(p.rooms!)),
          if (p.bedrooms != null) (Icons.bed_outlined, l10n.bedroomsValue(p.bedrooms!)),
          if (p.bathrooms != null) (Icons.bathtub_outlined, l10n.bathroomsValue(p.bathrooms!)),
        ];
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
            price: p.priceLabel(l10n),
            actions: [
              OutlinedButton(onPressed: () => lead(LeadType.contact), child: Text(l10n.leadTypeContact)),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                onPressed: () => lead(LeadType.visit),
                child: Text(l10n.askVisit),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(background: PhotoGallery(photos: p.photos, icon: Icons.home_work_outlined)),
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
                  PopupMenuButton<String>(
                    onSelected: (_) => showReportDialog(context, ref, target: ReportTarget.property, targetId: p.id),
                    itemBuilder: (_) => [PopupMenuItem(value: 'report', child: Text(l10n.reportTitle))],
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Readable(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TagBadge(label: p.transactionLabel(l10n)),
                            if (p.propertyType.isNotEmpty) TagBadge(label: types.label(p.propertyType)),
                            if (p.status == ListingStatus.underOffer) TagBadge(label: l10n.listingUnderOffer),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(p.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                        if (place.isNotEmpty) Text(place, style: theme.textTheme.bodyMedium),
                        if (facts.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              for (final (icon, text) in facts)
                                Chip(avatar: Icon(icon, size: 18), label: Text(text)),
                            ],
                          ),
                        ],
                        if (p.description.isNotEmpty) ...[const SizedBox(height: 16), Text(p.description)],
                        if (p.features.isNotEmpty) ...[
                          _heading(context, l10n.features),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final id in p.features)
                                Chip(avatar: const Icon(Icons.check, size: 16), label: Text(amenities.label(id))),
                            ],
                          ),
                        ],
                        if (p.transactionType == TransactionType.rent &&
                            (p.conditions.deposit.isNotEmpty ||
                                p.conditions.advance.isNotEmpty ||
                                p.conditions.agencyFees.isNotEmpty)) ...[
                          _heading(context, l10n.rentConditions),
                          if (p.conditions.deposit.isNotEmpty) InfoRow(Icons.savings_outlined, l10n.depositValue(p.conditions.deposit)),
                          if (p.conditions.advance.isNotEmpty) InfoRow(Icons.payments_outlined, l10n.advanceValue(p.conditions.advance)),
                          if (p.conditions.agencyFees.isNotEmpty)
                            InfoRow(Icons.receipt_long_outlined, l10n.agencyFeesValue(p.conditions.agencyFees)),
                        ],
                        _heading(context, l10n.location),
                        InfoRow(
                          Icons.map_outlined,
                          [p.address, place].where((s) => s.isNotEmpty).join(', '),
                          onTap: () => openMap([p.address, place].where((s) => s.isNotEmpty).join(', ')),
                        ),
                        _heading(context, l10n.publisher),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(child: Icon(p.byIndividual ? Icons.person_outline : Icons.real_estate_agent_outlined)),
                          title: Text(p.orgName ?? ''),
                          subtitle: Text(p.byIndividual ? l10n.orgTypeIndividual : l10n.verifiedProfessional),
                        ),
                        const SizedBox(height: 8),
                        Text(l10n.realEstateDisclaimer, style: theme.textTheme.bodySmall),
                        const SizedBox(height: 32),
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

Widget _heading(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.only(top: 24, bottom: 8),
  child: Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
);

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
    final project = ref.watch(projectProvider(widget.projectId));
    final units = ref.watch(unitsProvider(widget.projectId)).value ?? const <ProjectUnit>[];
    final types = ref.watch(propertyTypesProvider).value ?? const <PropertyType>[];

    return project.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: EmptyState(icon: Icons.search_off, title: l10n.listingUnavailable)),
      data: (p) {
        if (p == null) {
          return Scaffold(appBar: AppBar(), body: EmptyState(icon: Icons.search_off, title: l10n.listingUnavailable));
        }
        final place = placeOf(p.district, p.city);
        return Scaffold(
          bottomNavigationBar: BottomActionBar(
            price: p.priceLabel(l10n),
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                onPressed: () => showLeadSheet(
                  context,
                  ref,
                  targetType: 'project',
                  targetId: p.id,
                  title: p.title,
                  type: LeadType.info,
                ),
                child: Text(l10n.askInformation),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(background: PhotoGallery(photos: p.photos, icon: Icons.domain)),
                actions: [
                  FavoriteButton(
                    onImage: true,
                    targetId: p.id,
                    favorite: Favorite(targetType: ListingKind.project, title: p.title, photo: p.cover, city: p.city, price: p.priceFrom),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (_) => showReportDialog(context, ref, target: ReportTarget.project, targetId: p.id),
                    itemBuilder: (_) => [PopupMenuItem(value: 'report', child: Text(l10n.reportTitle))],
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Readable(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(spacing: 8, children: [
                          TagBadge(label: l10n.newProject),
                          TagBadge(label: p.status.label(l10n)),
                        ]),
                        const SizedBox(height: 8),
                        Text(p.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                        if (place.isNotEmpty) Text(place),
                        const SizedBox(height: 12),
                        if (p.deliveryDate.isNotEmpty) InfoRow(Icons.event_available, l10n.deliveryValue(p.deliveryDate)),
                        if (p.estimatedBudget != null) InfoRow(Icons.account_balance_outlined, l10n.budgetValue(p.estimatedBudget!.format())),
                        InfoRow(Icons.apartment, l10n.unitsAvailableValue(p.unitsAvailable, p.unitsCount)),
                        if (p.description.isNotEmpty) ...[const SizedBox(height: 12), Text(p.description)],
                        _heading(context, l10n.units),
                        if (units.isEmpty) Text(l10n.noUnitYet),
                        for (final u in units)
                          Card.outlined(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text([u.label, if (u.propertyType.isNotEmpty) types.label(u.propertyType)].join(' · ')),
                              subtitle: Text([
                                if (u.surface != null) l10n.surfaceValue(u.surface!),
                                if (u.rooms != null) l10n.roomsValue(u.rooms!),
                                u.price.format(),
                              ].join(' · ')),
                              trailing: u.status == UnitStatus.available
                                  ? TextButton(
                                      onPressed: () => showLeadSheet(
                                        context,
                                        ref,
                                        targetType: 'project',
                                        targetId: p.id,
                                        title: p.title,
                                        type: LeadType.info,
                                        unitId: u.id,
                                        unitLabel: u.label,
                                      ),
                                      child: Text(l10n.interested),
                                    )
                                  : StatusPill(u.status.label(l10n), u.status.color(theme.colorScheme)),
                            ),
                          ),
                        _heading(context, l10n.location),
                        InfoRow(
                          Icons.map_outlined,
                          [p.address, place].where((s) => s.isNotEmpty).join(', '),
                          onTap: () => openMap([p.address, place].where((s) => s.isNotEmpty).join(', ')),
                        ),
                        if (p.orgName != null) InfoRow(Icons.domain, l10n.publishedBy(p.orgName!)),
                        const SizedBox(height: 8),
                        Text(l10n.realEstateDisclaimer, style: theme.textTheme.bodySmall),
                        const SizedBox(height: 32),
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
