import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/catalog.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/presentation/cards.dart';

enum _SearchMode { hotels, rent, sale }

/// Accueil : recherche rapide, annonces à la une, invitation aux professionnels.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  _SearchMode _mode = _SearchMode.hotels;
  String? _city;

  void _search() {
    final city = _city == null ? '' : 'ville=${Uri.encodeComponent(_city!)}';
    switch (_mode) {
      case _SearchMode.hotels:
        context.go('/hotels?$city');
      case _SearchMode.rent:
        context.go('/immobilier?type=rent&$city');
      case _SearchMode.sale:
        context.go('/immobilier?type=sale&$city');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cities = ref.watch(citiesProvider).value ?? const <City>[];
    final hotels = ref.watch(featuredHotelsProvider).value ?? const [];
    final properties = ref.watch(featuredPropertiesProvider).value ?? const [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(
              l10n.appTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.primary,
                letterSpacing: 2,
              ),
            ),
            actions: [
              IconButton(
                tooltip: l10n.favorites,
                icon: const Icon(Icons.favorite_border),
                onPressed: () => context.push('/favoris'),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Readable(
              maxWidth: 1100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: _Hero(
                  mode: _mode,
                  city: _city,
                  cities: cities,
                  onMode: (m) => setState(() => _mode = m),
                  onCity: (c) => setState(() => _city = c),
                  onSearch: _search,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Readable(
              maxWidth: 1100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cities.isNotEmpty)
                    SizedBox(
                      height: 56,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        children: [
                          for (final c in cities.where((c) => c.country == 'BF').take(8))
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ActionChip(
                                avatar: const Icon(Icons.place_outlined, size: 18),
                                label: Text(c.name),
                                onPressed: () => context.go('/hotels?ville=${Uri.encodeComponent(c.name)}'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  SectionTitle(l10n.homeFeaturedHotels, actionLabel: l10n.seeAll, onAction: () => context.go('/hotels')),
                  if (hotels.isEmpty)
                    _Placeholder(l10n.homeNoHotelsYet)
                  else
                    HorizontalCards(children: [for (final h in hotels) hotelCard(context, h, width: 290)]),
                  SectionTitle(
                    l10n.homeFeaturedProperties,
                    actionLabel: l10n.seeAll,
                    onAction: () => context.go('/immobilier'),
                  ),
                  if (properties.isEmpty)
                    _Placeholder(l10n.homeNoPropertiesYet)
                  else
                    HorizontalCards(children: [for (final p in properties) propertyCard(context, p, width: 290)]),
                  const SizedBox(height: 24),
                  const _ProCallToAction(),
                  const _Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.mode,
    required this.city,
    required this.cities,
    required this.onMode,
    required this.onCity,
    required this.onSearch,
  });

  final _SearchMode mode;
  final String? city;
  final List<City> cities;
  final ValueChanged<_SearchMode> onMode;
  final ValueChanged<String?> onCity;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [ZakaColors.brand, Color(0xFF2E6FD8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.homeHeadline,
              style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(l10n.homeSubtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<_SearchMode>(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(value: _SearchMode.hotels, icon: const Icon(Icons.hotel), label: Text(l10n.navHotels)),
                        ButtonSegment(value: _SearchMode.rent, icon: const Icon(Icons.key_outlined), label: Text(l10n.rent)),
                        ButtonSegment(value: _SearchMode.sale, icon: const Icon(Icons.sell_outlined), label: Text(l10n.buy)),
                      ],
                      selected: {mode},
                      onSelectionChanged: (s) => onMode(s.first),
                    ),
                    const SizedBox(height: 12),
                    CityPicker(value: city, cities: cities, onChanged: onCity),
                    const SizedBox(height: 12),
                    FilledButton.icon(onPressed: onSearch, icon: const Icon(Icons.search), label: Text(l10n.search)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Choix d'une ville du catalogue (« Toutes les villes » par défaut).
class CityPicker extends StatelessWidget {
  const CityPicker({super.key, required this.value, required this.cities, required this.onChanged, this.allLabel});

  final String? value;
  final List<City> cities;
  final ValueChanged<String?> onChanged;
  final String? allLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DropdownMenu<String>(
      key: ValueKey(cities.length),
      expandedInsets: EdgeInsets.zero,
      enableFilter: true,
      requestFocusOnTap: true,
      leadingIcon: const Icon(Icons.place_outlined),
      label: Text(l10n.city),
      initialSelection: value ?? '',
      dropdownMenuEntries: [
        DropdownMenuEntry(value: '', label: allLabel ?? l10n.allCities),
        for (final c in cities) DropdownMenuEntry(value: c.name, label: c.name),
      ],
      onSelected: (v) => onChanged(v == null || v.isEmpty ? null : v),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
  );
}

class _ProCallToAction extends StatelessWidget {
  const _ProCallToAction();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card.filled(
        color: scheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.storefront, size: 40, color: scheme.onSecondaryContainer),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeProTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.homeProBody),
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: () => context.push('/pro'), child: Text(l10n.homeProAction)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('© ZAKA ${DateTime.now().year}', style: Theme.of(context).textTheme.bodySmall),
          TextButton(onPressed: () => context.push('/cgu'), child: Text(l10n.legalTerms)),
          TextButton(onPressed: () => context.push('/confidentialite'), child: Text(l10n.legalPrivacy)),
        ],
      ),
    );
  }
}
