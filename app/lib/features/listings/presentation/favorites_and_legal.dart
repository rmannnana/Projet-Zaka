import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../data/listings_repository.dart';
import '../domain/listing.dart';
import 'cards.dart';

/// Annonces mises de côté par l'utilisateur, filtrables par type.
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  ListingKind? _kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final favorites = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: favorites.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (all) {
          if (all.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: l10n.noFavorite,
              body: l10n.noFavoriteHint,
              action: FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(180, 48)),
                onPressed: () => context.go('/'),
                child: Text(l10n.explore),
              ),
            );
          }
          final items = _kind == null ? all : all.where((f) => f.targetType == _kind).toList();
          final filters = [
            (null, l10n.all),
            (ListingKind.hotel, l10n.homeCategoryHotels),
            (ListingKind.property, l10n.navRealEstate),
            (ListingKind.project, l10n.homeCategoryProjects),
          ];
          return Readable(
            maxWidth: 760,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final (kind, label) in filters)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(label),
                            selected: _kind == kind,
                            onSelected: (_) => setState(() => _kind = kind),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: EmptyState(icon: Icons.favorite_border, title: l10n.noFavorite),
                  ),
                for (final f in items)
                  ListingTile(
                    title: f.title,
                    photo: f.photo,
                    location: f.city ?? '',
                    price: f.price?.format(),
                    icon: switch (f.targetType) {
                      ListingKind.hotel => Icons.hotel,
                      ListingKind.property => Icons.home_work_outlined,
                      ListingKind.project => Icons.domain,
                    },
                    trailing: FavoriteButton(targetId: f.id, favorite: f),
                    onTap: () => openFavorite(context, f),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

enum LegalDocument { terms, privacy }

/// CGU et politique de confidentialité (exigées par Google Play), lues depuis les fichiers de l'app.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asset = document == LegalDocument.terms ? 'assets/legal/cgu.txt' : 'assets/legal/confidentialite.txt';
    return Scaffold(
      appBar: AppBar(title: Text(document == LegalDocument.terms ? l10n.legalTerms : l10n.legalPrivacy)),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(asset),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          return Readable(
            maxWidth: 760,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: SelectableText(snap.data!, style: const TextStyle(height: 1.5)),
            ),
          );
        },
      ),
    );
  }
}
