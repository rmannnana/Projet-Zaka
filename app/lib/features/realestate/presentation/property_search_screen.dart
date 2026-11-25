import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/catalog.dart';
import '../../../core/money.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/home_screen.dart';
import '../../hotels/presentation/hotel_search_screen.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/domain/listing.dart';
import '../../listings/presentation/cards.dart';

const _rentBudgets = [50000, 100000, 200000, 350000, 500000];
const _saleBudgets = [10000000, 25000000, 50000000, 100000000];

/// Immobilier : biens à louer, à vendre, et programmes neufs.
class PropertySearchScreen extends ConsumerStatefulWidget {
  const PropertySearchScreen({super.key, this.initialTab = 0, this.city});

  /// 0 : louer, 1 : acheter, 2 : programmes neufs.
  final int initialTab;
  final String? city;

  @override
  ConsumerState<PropertySearchScreen> createState() => _PropertySearchScreenState();
}

class _PropertySearchScreenState extends ConsumerState<PropertySearchScreen> with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 3, vsync: this, initialIndex: widget.initialTab)
    ..addListener(() => setState(() => _query = _query.copyWith(maxPrice: () => null)));
  late PropertyQuery _query = PropertyQuery(
    transactionType: widget.initialTab == 1 ? TransactionType.sale : TransactionType.rent,
    city: widget.city,
  );

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _filters(List<PropertyType> types) async {
    final l10n = AppLocalizations.of(context);
    final sale = _tabs.index == 1;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) {
          void update(PropertyQuery q) {
            setSheet(() {});
            setState(() => _query = q);
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.propertyType, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.allTypes),
                        selected: _query.propertyType == null,
                        onSelected: (_) => update(_query.copyWith(propertyType: () => null)),
                      ),
                      for (final t in types)
                        ChoiceChip(
                          label: Text(t.label),
                          selected: _query.propertyType == t.id,
                          onSelected: (_) => update(_query.copyWith(propertyType: () => t.id)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.maxBudget, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.anyBudget),
                        selected: _query.maxPrice == null,
                        onSelected: (_) => update(_query.copyWith(maxPrice: () => null)),
                      ),
                      for (final b in sale ? _saleBudgets : _rentBudgets)
                        ChoiceChip(
                          label: Text(Money(b).format()),
                          selected: _query.maxPrice == b,
                          onSelected: (_) => update(_query.copyWith(maxPrice: () => b)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.minRooms, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final n in [null, 1, 2, 3, 4, 5])
                        ChoiceChip(
                          label: Text(n == null ? l10n.any : '$n+'),
                          selected: _query.minRooms == n,
                          onSelected: (_) => update(_query.copyWith(minRooms: () => n)),
                        ),
                    ],
                  ),
                  if (!sale) ...[
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.furnishedOnly),
                      value: _query.furnished,
                      onChanged: (v) => update(_query.copyWith(furnished: v)),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(onPressed: () => Navigator.pop(context), child: Text(l10n.showResults)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cities = ref.watch(citiesProvider).value ?? const <City>[];
    final types = ref.watch(propertyTypesProvider).value ?? const <PropertyType>[];
    final projectsTab = _tabs.index == 2;
    final query = _query.copyWith(transactionType: _tabs.index == 1 ? TransactionType.sale : TransactionType.rent);
    final filterCount =
        (query.propertyType == null ? 0 : 1) +
        (query.maxPrice == null ? 0 : 1) +
        (query.minRooms == null ? 0 : 1) +
        (query.furnished ? 1 : 0);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, _) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: Text(l10n.navRealEstate),
            bottom: TabBar(
              controller: _tabs,
              tabs: [Tab(text: l10n.rent), Tab(text: l10n.buy), Tab(text: l10n.newProjects)],
            ),
          ),
        ],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Readable(
                maxWidth: 1200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CityPicker(
                          value: _query.city,
                          cities: cities,
                          onChanged: (c) => setState(() => _query = _query.copyWith(city: () => c)),
                        ),
                      ),
                      if (!projectsTab) ...[
                        const SizedBox(width: 8),
                        Badge.count(
                          count: filterCount,
                          isLabelVisible: filterCount > 0,
                          child: IconButton.filledTonal(
                            tooltip: l10n.filters,
                            onPressed: () => _filters(types),
                            icon: const Icon(Icons.tune),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (projectsTab) ..._projects(context, l10n) else ..._properties(context, l10n, query),
          ],
        ),
      ),
    );
  }

  List<Widget> _properties(BuildContext context, AppLocalizations l10n, PropertyQuery query) =>
      ref.watch(propertySearchProvider(query)).when(
        loading: () => [const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))],
        error: (e, _) => [SliverFillRemaining(child: Center(child: Text(l10n.genericError)))],
        data: (items) => items.isEmpty
            ? [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(icon: Icons.home_work_outlined, title: l10n.noPropertyFound, body: l10n.noPropertyFoundHint),
                ),
              ]
            : [
                SliverCrossAxisConstrained(
                  maxCrossAxisExtent: 1200,
                  child: ListingGrid(children: [for (final p in items) propertyCard(context, p)]),
                ),
              ],
      );

  List<Widget> _projects(BuildContext context, AppLocalizations l10n) =>
      ref.watch(projectSearchProvider(_query.city)).when(
        loading: () => [const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))],
        error: (e, _) => [SliverFillRemaining(child: Center(child: Text(l10n.genericError)))],
        data: (items) => items.isEmpty
            ? [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(icon: Icons.domain, title: l10n.noProjectFound),
                ),
              ]
            : [
                SliverCrossAxisConstrained(
                  maxCrossAxisExtent: 1200,
                  child: ListingGrid(children: [for (final p in items) projectCard(context, p)]),
                ),
              ],
      );
}

/// Paramètres d'URL : /immobilier?type=rent|sale|projets&ville=…
PropertySearchScreen propertySearchFromUri(Uri uri) => PropertySearchScreen(
  initialTab: switch (uri.queryParameters['type']) {
    'sale' => 1,
    'projets' => 2,
    _ => 0,
  },
  city: uri.queryParameters['ville'],
);
