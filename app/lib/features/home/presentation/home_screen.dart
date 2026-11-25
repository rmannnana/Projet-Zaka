import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/catalog.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../account/data/account_requests_repository.dart';
import '../../account/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/presentation/cards.dart';

enum _SearchMode { hotels, rent, sale, projects }

String _searchPath(_SearchMode mode, String? city) {
  final c = city == null ? '' : 'ville=${Uri.encodeComponent(city)}';
  return switch (mode) {
    _SearchMode.hotels => '/hotels?$c',
    _SearchMode.rent => '/immobilier?type=rent&$c',
    _SearchMode.sale => '/immobilier?type=sale&$c',
    _SearchMode.projects => '/immobilier?type=projets&$c',
  };
}

/// Accueil : salutation, recherche, catégories, annonces à la une, invitation aux pros.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cities = ref.watch(citiesProvider).value ?? const <City>[];
    final hotels = ref.watch(featuredHotelsProvider).value ?? const [];
    final properties = ref.watch(featuredPropertiesProvider).value ?? const [];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Readable(
                maxWidth: 1100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _TopBar(),
                    const _Greeting(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                      child: _SearchBar(onTap: () => _openSearch(context, cities)),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(16, 22, 16, 0), child: _Categories()),
                    const Padding(padding: EdgeInsets.fromLTRB(16, 24, 16, 0), child: _ProBanner()),
                    if (cities.isNotEmpty) ...[
                      SectionTitle(l10n.homePopularCities),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            for (final c in cities.where((c) => c.country == 'BF').take(10))
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ActionChip(
                                  avatar: const Icon(Icons.location_on_outlined),
                                  label: Text(c.name),
                                  onPressed: () => context.go('/hotels?ville=${Uri.encodeComponent(c.name)}'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    SectionTitle(
                      l10n.homeFeaturedHotels,
                      actionLabel: l10n.seeAll,
                      onAction: () => context.go('/hotels'),
                    ),
                    if (hotels.isEmpty)
                      _Placeholder(l10n.homeNoHotelsYet, icon: Icons.hotel_outlined)
                    else
                      HorizontalCards(
                        children: [for (final h in hotels) hotelCard(context, h, width: 272, imageHeight: 160)],
                      ),
                    SectionTitle(
                      l10n.homeFeaturedProperties,
                      actionLabel: l10n.seeAll,
                      onAction: () => context.go('/immobilier'),
                    ),
                    if (properties.isEmpty)
                      _Placeholder(l10n.homeNoPropertiesYet, icon: Icons.home_work_outlined)
                    else
                      HorizontalCards(
                        children: [for (final p in properties) propertyCard(context, p, width: 272, imageHeight: 160)],
                      ),
                    const _Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSearch(BuildContext context, List<City> cities) => showModalBottomSheet<void>(
    useRootNavigator: true,
    context: context,
    isScrollControlled: true,
    builder: (_) => _SearchSheet(cities: cities),
  );
}

class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final signedIn = ref.watch(authStateProvider).value != null;
    final unread = signedIn ? ref.watch(unreadNotificationsProvider) : 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 0),
      child: Row(
        children: [
          const ZakaLogo(size: 30, withName: true),
          const Spacer(),
          _RoundIcon(icon: Icons.favorite_border, tooltip: l10n.favorites, onTap: () => context.push('/favoris')),
          const SizedBox(width: 8),
          _RoundIcon(
            icon: Icons.notifications_none_rounded,
            tooltip: l10n.notifications,
            badge: unread,
            onTap: () => context.push(signedIn ? '/compte/notifications' : '/connexion'),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.tooltip, required this.onTap, this.badge = 0});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    return Badge(
      isLabelVisible: badge > 0,
      label: Text('$badge'),
      offset: const Offset(-2, 2),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onTap,
        icon: Icon(icon),
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          side: BorderSide(color: palette.line),
          shape: const CircleBorder(),
          minimumSize: const Size(44, 44),
        ),
      ),
    );
  }
}

class _Greeting extends ConsumerWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider).value;
    final profile = ref.watch(currentUserProfileProvider).value;
    final fullName = (profile?.displayName ?? user?.displayName ?? '').trim();
    final firstName = fullName.isEmpty ? null : fullName.split(RegExp(r'\s+')).first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            firstName == null ? l10n.homeGreetingAnonymous : l10n.homeGreeting(firstName),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(l10n.homeTagline, style: theme.textTheme.bodyMedium?.copyWith(color: ZakaPalette.of(context).muted)),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = ZakaPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Material(
            color: scheme.surfaceContainerLow,
            shape: StadiumBorder(side: BorderSide(color: palette.line)),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                child: Row(
                  children: [
                    Icon(Icons.search, color: scheme.onSurface),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.homeSearchHint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: palette.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          tooltip: l10n.filters,
          onPressed: onTap,
          icon: const Icon(Icons.tune),
          style: IconButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            minimumSize: const Size(54, 54),
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = ZakaPalette.of(context);
    final items = [
      (Icons.bed_outlined, l10n.homeCategoryHotels, palette.peach, palette.onPeach, _SearchMode.hotels),
      (Icons.vpn_key_outlined, l10n.rent, palette.sage, palette.onSage, _SearchMode.rent),
      (Icons.sell_outlined, l10n.buy, palette.lavender, palette.onLavender, _SearchMode.sale),
      (Icons.domain_outlined, l10n.homeCategoryProjects, palette.mint, palette.onMint, _SearchMode.projects),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final (icon, label, bg, fg, mode) in items)
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(ZakaRadius.medium),
              onTap: () => context.go(_searchPath(mode, null)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    IconTile(icon: icon, background: bg, foreground: fg, size: 60),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Bannière d'invitation aux professionnels, dans le vert de la marque.
class _ProBanner extends StatelessWidget {
  const _ProBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = ZakaPalette.of(context);
    return Material(
      borderRadius: BorderRadius.circular(ZakaRadius.card + 2),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ZakaColors.brand, Color(0xFF136B55)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: () => context.push('/pro'),
          child: Stack(
            children: [
              Positioned(
                right: -18,
                bottom: -22,
                child: ZakaLogo(size: 150, color: Colors.white.withValues(alpha: 0.1)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.homeProTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.homeProBody,
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 14),
                          DecoratedBox(
                            decoration: BoxDecoration(color: palette.gold, borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              child: Text(
                                l10n.homeProAction,
                                style: TextStyle(color: palette.onGold, fontWeight: FontWeight.w800, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_forward, color: ZakaColors.brand, size: 20),
                    ),
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

/// Recherche rapide : type d'annonce et ville.
class _SearchSheet extends StatefulWidget {
  const _SearchSheet({required this.cities});

  final List<City> cities;

  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  _SearchMode _mode = _SearchMode.hotels;
  String? _city;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final modes = [
      (_SearchMode.hotels, Icons.bed_outlined, l10n.homeCategoryHotels),
      (_SearchMode.rent, Icons.vpn_key_outlined, l10n.rent),
      (_SearchMode.sale, Icons.sell_outlined, l10n.buy),
      (_SearchMode.projects, Icons.domain_outlined, l10n.homeCategoryProjects),
    ];
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.homeSearchTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (mode, icon, label) in modes)
                  ChoiceChip(
                    avatar: Icon(icon, color: _mode == mode ? Colors.white : null),
                    label: Text(label),
                    selected: _mode == mode,
                    onSelected: (_) => setState(() => _mode = mode),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            CityPicker(value: _city, cities: widget.cities, onChanged: (c) => setState(() => _city = c)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.go(_searchPath(_mode, _city));
              },
              icon: const Icon(Icons.search),
              label: Text(l10n.search),
            ),
          ],
        ),
      ),
    );
  }
}

/// Choix d'une ville du catalogue (« Toutes les villes » par défaut), dans une feuille avec recherche.
class CityPicker extends StatelessWidget {
  const CityPicker({super.key, required this.value, required this.cities, required this.onChanged, this.allLabel});

  final String? value;
  final List<City> cities;
  final ValueChanged<String?> onChanged;
  final String? allLabel;

  Future<void> _pick(BuildContext context) async {
    final picked = await showModalBottomSheet<String>(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      builder: (_) => _CitySheet(cities: cities, selected: value, allLabel: allLabel),
    );
    if (picked != null) onChanged(picked.isEmpty ? null : picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = ZakaPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ZakaRadius.medium),
        side: BorderSide(color: palette.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(ZakaRadius.medium),
        onTap: () => _pick(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.location_on_outlined, color: scheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.city, style: TextStyle(fontSize: 12, color: palette.muted)),
                    Text(
                      value ?? allLabel ?? l10n.allCities,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: palette.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _CitySheet extends StatefulWidget {
  const _CitySheet({required this.cities, required this.selected, this.allLabel});

  final List<City> cities;
  final String? selected;
  final String? allLabel;

  @override
  State<_CitySheet> createState() => _CitySheetState();
}

class _CitySheetState extends State<_CitySheet> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    String fold(String s) => s
        .toLowerCase()
        .replaceAll(RegExp('[éèêë]'), 'e')
        .replaceAll(RegExp('[àâä]'), 'a')
        .replaceAll(RegExp('[îï]'), 'i')
        .replaceAll(RegExp('[ôö]'), 'o')
        .replaceAll(RegExp('[ùûü]'), 'u');
    final matches = widget.cities.where((c) => fold(c.name).contains(fold(_filter))).toList();
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.city, style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                TextField(
                  autofocus: false,
                  decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l10n.citySearchHint),
                  onChanged: (v) => setState(() => _filter = v.trim()),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              children: [
                if (_filter.isEmpty)
                  _CityOption(
                    label: widget.allLabel ?? l10n.allCities,
                    icon: Icons.public,
                    selected: widget.selected == null,
                    onTap: () => Navigator.pop(context, ''),
                  ),
                for (final c in matches)
                  _CityOption(
                    label: c.name,
                    icon: Icons.location_on_outlined,
                    selected: widget.selected == c.name,
                    onTap: () => Navigator.pop(context, c.name),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CityOption extends StatelessWidget {
  const _CityOption({required this.label, required this.icon, required this.selected, required this.onTap});

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: selected ? scheme.primary : null),
      title: Text(
        label,
        style: selected ? TextStyle(color: scheme.primary, fontWeight: FontWeight.w700) : null,
      ),
      trailing: selected ? Icon(Icons.check_circle, color: scheme.primary) : null,
      selected: selected,
      selectedTileColor: scheme.primaryContainer.withValues(alpha: 0.5),
      onTap: onTap,
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.text, {required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(ZakaRadius.card),
          border: Border.all(color: palette.line),
        ),
        child: Row(
          children: [
            IconTile(icon: icon, background: palette.mint, foreground: palette.onMint),
            const SizedBox(width: 14),
            Expanded(
              child: Text(text, style: TextStyle(color: palette.muted)),
            ),
          ],
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
    final palette = ZakaPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
      child: Column(
        children: [
          ZakaLogo(size: 26, withName: true, color: palette.muted.withValues(alpha: 0.6)),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('© ZAKA ${DateTime.now().year}', style: Theme.of(context).textTheme.bodySmall),
              TextButton(onPressed: () => context.push('/cgu'), child: Text(l10n.legalTerms)),
              TextButton(onPressed: () => context.push('/confidentialite'), child: Text(l10n.legalPrivacy)),
            ],
          ),
        ],
      ),
    );
  }
}
