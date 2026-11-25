import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/catalog.dart';
import '../../../core/money.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/presentation/home_screen.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/presentation/cards.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../requests/data/requests_repository.dart';

const _budgets = [10000, 20000, 35000, 50000, 75000, 100000];

/// Recherche d'hôtels : ville, dates, voyageurs, budget par nuit, équipements.
class HotelSearchScreen extends ConsumerStatefulWidget {
  const HotelSearchScreen({super.key, this.city, this.checkIn, this.checkOut, this.guests});

  final String? city;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guests;

  @override
  ConsumerState<HotelSearchScreen> createState() => _HotelSearchScreenState();
}

class _HotelSearchScreenState extends ConsumerState<HotelSearchScreen> {
  late String? _city = widget.city;
  late DateTimeRange? _dates = widget.checkIn != null && widget.checkOut != null
      ? DateTimeRange(start: widget.checkIn!, end: widget.checkOut!)
      : null;
  late int _guests = widget.guests ?? 2;
  int? _maxPrice;
  final _amenities = <String>{};

  String get _detailQuery {
    final params = {
      if (_dates != null) 'arrivee': dayKey(_dates!.start),
      if (_dates != null) 'depart': dayKey(_dates!.end),
      'voyageurs': '$_guests',
    };
    return '?${Uri(queryParameters: params).query}';
  }

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _dates,
    );
    if (picked != null) setState(() => _dates = picked);
  }

  Future<void> _pickGuests() async {
    final l10n = AppLocalizations.of(context);
    var value = _guests;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.guests),
          content: CountStepper(label: l10n.guests, value: value, min: 1, onChanged: (v) => setState(() => value = v)),
          actions: [FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.apply))],
        ),
      ),
    );
    if (ok == true) setState(() => _guests = value);
  }

  Future<void> _filters(List<Amenity> amenities) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheet) {
          void update(VoidCallback fn) {
            setSheet(fn);
            setState(() {});
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(l10n.filters, style: Theme.of(context).textTheme.titleLarge)),
                      TextButton(onPressed: () => update(() {
                          _maxPrice = null;
                          _amenities.clear();
                        }), child: Text(l10n.resetFilters)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.maxPricePerNight, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.anyBudget),
                        selected: _maxPrice == null,
                        onSelected: (_) => update(() => _maxPrice = null),
                      ),
                      for (final b in _budgets)
                        ChoiceChip(
                          label: Text(Money(b).format()),
                          selected: _maxPrice == b,
                          onSelected: (_) => update(() => _maxPrice = b),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.amenities, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final a in amenities.where((a) => a.forHotels))
                        FilterChip(
                          label: Text(a.label),
                          selected: _amenities.contains(a.id),
                          onSelected: (v) => update(() => v ? _amenities.add(a.id) : _amenities.remove(a.id)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: () => Navigator.pop(context), child: Text(l10n.showResults)),
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
    final amenities = ref.watch(amenitiesProvider).value ?? const <Amenity>[];
    final query = HotelQuery(city: _city, maxPrice: _maxPrice, amenities: {..._amenities}, guests: _guests);
    final results = ref.watch(hotelSearchProvider(query));
    final filterCount = (_maxPrice == null ? 0 : 1) + _amenities.length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(floating: true, title: Text(l10n.navHotels)),
          SliverToBoxAdapter(
            child: Readable(
              maxWidth: 1200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CityPicker(value: _city, cities: cities, onChanged: (c) => setState(() => _city = c)),
                        ),
                        const SizedBox(width: 8),
                        Badge.count(
                          count: filterCount,
                          isLabelVisible: filterCount > 0,
                          child: IconButton.filled(
                            tooltip: l10n.filters,
                            onPressed: () => _filters(amenities),
                            icon: const Icon(Icons.tune),
                            style: IconButton.styleFrom(minimumSize: const Size(58, 58)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.date_range, size: 18),
                          label: Text(
                            _dates == null
                                ? l10n.chooseDates
                                : '${shortDate.format(_dates!.start)} → ${shortDate.format(_dates!.end)}',
                          ),
                          onPressed: _pickDates,
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.people_outline, size: 18),
                          label: Text(l10n.guestsCount(_guests)),
                          onPressed: _pickGuests,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ...results.when(
            loading: () => [const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))],
            error: (e, _) => [SliverFillRemaining(child: Center(child: Text(l10n.genericError)))],
            data: (hotels) => hotels.isEmpty
                ? [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(
                        icon: Icons.hotel_outlined,
                        title: l10n.noHotelFound,
                        body: l10n.noHotelFoundHint,
                      ),
                    ),
                  ]
                : [
                    SliverToBoxAdapter(
                      child: Readable(
                        maxWidth: 1200,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Text(l10n.hotelsFound(hotels.length)),
                        ),
                      ),
                    ),
                    SliverCrossAxisConstrained(
                      maxCrossAxisExtent: 1200,
                      child: ListingGrid(children: [for (final h in hotels) hotelCard(context, h, query: _detailQuery)]),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

/// Limite la largeur d'un sliver sur les très grands écrans.
class SliverCrossAxisConstrained extends StatelessWidget {
  const SliverCrossAxisConstrained({super.key, required this.maxCrossAxisExtent, required this.child});

  final double maxCrossAxisExtent;
  final Widget child;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final extra = constraints.crossAxisExtent - maxCrossAxisExtent;
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: extra > 0 ? extra / 2 : 0),
        sliver: child,
      );
    },
  );
}

/// Paramètres d'URL de la recherche d'hôtels.
HotelSearchScreen hotelSearchFromUri(Uri uri) {
  DateTime? day(String? s) => s == null ? null : DateTime.tryParse(s);
  return HotelSearchScreen(
    city: uri.queryParameters['ville'],
    checkIn: day(uri.queryParameters['arrivee']),
    checkOut: day(uri.queryParameters['depart']),
    guests: int.tryParse(uri.queryParameters['voyageurs'] ?? ''),
  );
}

/// Ouvre la recherche d'hôtels (utile depuis l'accueil).
void goToHotels(BuildContext context, {String? city}) =>
    context.go(city == null ? '/hotels' : '/hotels?ville=${Uri.encodeComponent(city)}');
