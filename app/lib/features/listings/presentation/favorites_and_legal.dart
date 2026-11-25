import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../hotels/presentation/hotel_search_screen.dart';
import '../data/listings_repository.dart';
import '../domain/listing.dart';
import 'cards.dart';

/// Annonces mises de côté par l'utilisateur.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final favorites = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favorites)),
      body: favorites.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (items) => items.isEmpty
            ? EmptyState(
                icon: Icons.favorite_border,
                title: l10n.noFavorite,
                body: l10n.noFavoriteHint,
                action: FilledButton.tonal(onPressed: () => context.go('/'), child: Text(l10n.explore)),
              )
            : CustomScrollView(
                slivers: [
                  SliverCrossAxisConstrained(
                    maxCrossAxisExtent: 1200,
                    child: ListingGrid(
                      children: [
                        for (final f in items)
                          ListingCard(
                            title: f.title,
                            photo: f.photo,
                            location: f.city ?? '',
                            price: f.price?.format(),
                            icon: switch (f.targetType) {
                              ListingKind.hotel => Icons.hotel,
                              ListingKind.property => Icons.home_work_outlined,
                              ListingKind.project => Icons.domain,
                            },
                            favorite: FavoriteButton(onImage: true, targetId: f.id, favorite: f),
                            onTap: () => openFavorite(context, f),
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
