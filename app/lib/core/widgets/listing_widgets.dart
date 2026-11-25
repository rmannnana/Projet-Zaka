import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/listings/data/listings_repository.dart';
import '../../features/listings/domain/listing.dart';
import '../../l10n/app_localizations.dart';

/// Image distante mise en cache, avec un fond neutre pendant le chargement.
class NetImage extends StatelessWidget {
  const NetImage(this.url, {super.key, this.fit = BoxFit.cover, this.icon = Icons.image_outlined});

  final String? url;
  final BoxFit fit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Center(child: Icon(icon, color: scheme.outline, size: 40)),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return CachedNetworkImage(
      imageUrl: url!,
      fit: fit,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

/// Galerie de photos défilante, avec plein écran au toucher.
class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key, required this.photos, this.icon = Icons.image_outlined});

  final List<String> photos;
  final IconData icon;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open(int index) => showDialog<void>(
    context: context,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          PageView(
            controller: PageController(initialPage: index),
            children: [
              for (final url in widget.photos)
                InteractiveViewer(child: Center(child: NetImage(url, fit: BoxFit.contain))),
            ],
          ),
          SafeArea(
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) return NetImage(null, icon: widget.icon);
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.photos.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (_, i) => GestureDetector(onTap: () => _open(i), child: NetImage(widget.photos[i])),
        ),
        if (widget.photos.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.photos.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _index ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: i == _index ? 1 : 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Bouton cœur : ajoute ou retire des favoris (connexion demandée si besoin).
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.targetId, required this.favorite, this.onImage = false});

  final String targetId;
  final Favorite favorite;

  /// Posé sur une photo : fond sombre pour rester lisible.
  final bool onImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isFavorite = ref.watch(favoriteIdsProvider).contains(targetId);
    final button = IconButton(
      tooltip: isFavorite ? l10n.favoriteRemove : l10n.favoriteAdd,
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      color: isFavorite ? Colors.red.shade400 : (onImage ? Colors.white : null),
      onPressed: () async {
        final uid = ref.read(authStateProvider).value?.uid;
        if (uid == null) {
          context.push('/connexion?retour=${Uri.encodeComponent(GoRouterState.of(context).uri.toString())}');
          return;
        }
        final repo = ref.read(favoritesRepositoryProvider);
        isFavorite ? await repo.remove(uid, targetId) : await repo.add(uid, targetId, favorite);
      },
    );
    if (!onImage) return button;
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
      child: button,
    );
  }
}

/// Carte d'annonce : photo, titre, lieu, prix, pastilles.
class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.title,
    required this.photo,
    required this.location,
    required this.price,
    required this.onTap,
    this.badges = const [],
    this.favorite,
    this.icon = Icons.image_outlined,
    this.width,
  });

  final String title;
  final String? photo;
  final String location;
  final String? price;
  final VoidCallback onTap;
  final List<String> badges;
  final FavoriteButton? favorite;
  final IconData icon;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Card.outlined(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    NetImage(photo, icon: icon),
                    if (badges.isNotEmpty)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Wrap(spacing: 4, children: [for (final b in badges) TagBadge(label: b)]),
                      ),
                    if (favorite != null) Positioned(right: 4, top: 4, child: favorite!),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.place_outlined, size: 16, color: theme.colorScheme.outline),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    if (price != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        price!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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

/// Petite pastille sur une photo (« À la une », « Particulier »…).
class TagBadge extends StatelessWidget {
  const TagBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: TextStyle(color: scheme.onSecondaryContainer, fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Grille de cartes qui s'adapte à la largeur (1 colonne sur téléphone, plusieurs sur le web).
class ListingGrid extends StatelessWidget {
  const ListingGrid({super.key, required this.children, this.padding = const EdgeInsets.all(16)});

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: padding,
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.05,
      ),
      delegate: SliverChildListDelegate(children),
    ),
  );
}

/// Liste horizontale de cartes (accueil).
class HorizontalCards extends StatelessWidget {
  const HorizontalCards({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 268,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(width: 12),
      itemBuilder: (_, i) => children[i],
    ),
  );
}

/// Message quand une liste est vide, avec une action éventuelle.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, this.body, this.action});

  final IconData icon;
  final String title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary.withValues(alpha: 0.7)),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            if (body != null) ...[
              const SizedBox(height: 6),
              Text(body!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            ],
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}

/// Titre de section, avec un lien « Tout voir » éventuel.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (actionLabel != null) TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    ),
  );
}

/// Ligne icône + texte des fiches détaillées.
class InfoRow extends StatelessWidget {
  const InfoRow(this.icon, this.text, {super.key, this.onTap});

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    ),
  );
}

/// Contenu centré, limité en largeur sur les grands écrans.
class Readable extends StatelessWidget {
  const Readable({super.key, required this.child, this.maxWidth = 900});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(constraints: BoxConstraints(maxWidth: maxWidth), child: child),
  );
}

/// Pastille de statut colorée.
class StatusPill extends StatelessWidget {
  const StatusPill(this.label, this.color, {super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      border: Border.all(color: color.withValues(alpha: 0.6)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    ),
  );
}

/// Compteur − / + (personnes, chambres).
class CountStepper extends StatelessWidget {
  const CountStepper({super.key, required this.label, required this.value, required this.onChanged, this.min = 0, this.max = 20});

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label)),
      IconButton.outlined(
        onPressed: value > min ? () => onChanged(value - 1) : null,
        icon: const Icon(Icons.remove),
      ),
      SizedBox(width: 36, child: Text('$value', textAlign: TextAlign.center)),
      IconButton.outlined(
        onPressed: value < max ? () => onChanged(value + 1) : null,
        icon: const Icon(Icons.add),
      ),
    ],
  );
}
