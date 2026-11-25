import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/listings/data/listings_repository.dart';
import '../../features/listings/domain/listing.dart';
import '../../l10n/app_localizations.dart';

export 'panels.dart';

/// Logo ZAKA (symbole seul ou avec le nom), dans la couleur demandée.
class ZakaLogo extends StatelessWidget {
  const ZakaLogo({super.key, this.size = 32, this.color, this.withName = false});

  final double size;
  final Color? color;

  /// Symbole + « ZAKA » écrit à côté.
  final bool withName;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    final mark = Image.asset('assets/brand/zaka_mark.png', height: size, color: c, semanticLabel: 'ZAKA');
    if (!withName) return mark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: size * 0.3),
        Text(
          'ZAKA',
          style: TextStyle(
            fontFamily: ZakaTheme.fontFamily,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.62,
            letterSpacing: 1.5,
            color: c,
          ),
        ),
      ],
    );
  }
}

/// Image distante mise en cache, avec un fond teinté pendant le chargement.
class NetImage extends StatelessWidget {
  const NetImage(this.url, {super.key, this.fit = BoxFit.cover, this.icon = Icons.image_outlined});

  final String? url;
  final BoxFit fit;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    final placeholder = ColoredBox(
      color: palette.mint,
      child: Center(child: Icon(icon, color: palette.onMint.withValues(alpha: 0.45), size: 40)),
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

/// Bouton rond posé sur une photo (retour, favori, partage…).
class CircleAction extends StatelessWidget {
  const CircleAction({super.key, required this.icon, required this.onPressed, this.tooltip, this.color});

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLow.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 1,
      shadowColor: Colors.black26,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 21, color: color ?? scheme.onSurface),
        style: IconButton.styleFrom(shape: const CircleBorder(), minimumSize: const Size(42, 42)),
      ),
    );
  }
}

/// Galerie de photos défilante, compteur « 1/8 » et plein écran au toucher.
class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key, required this.photos, this.icon = Icons.image_outlined, this.counterBottom = 16});

  final List<String> photos;
  final IconData icon;

  /// Distance du compteur au bas de la galerie (pour passer au-dessus d'une feuille arrondie).
  final double counterBottom;

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
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAction(icon: Icons.close, onPressed: () => Navigator.pop(context)),
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
        // Dégradé bas pour garder les boutons et le compteur lisibles.
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x55000000), Color(0x00000000), Color(0x00000000), Color(0x40000000)],
                stops: [0, 0.3, 0.7, 1],
              ),
            ),
          ),
        ),
        if (widget.photos.length > 1)
          Positioned(
            right: 16,
            bottom: widget.counterBottom,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  '${_index + 1}/${widget.photos.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// En-tête des fiches détaillées : galerie plein cadre, boutons ronds et
/// bord arrondi sur lequel vient se poser le contenu.
class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key, required this.photos, required this.icon, this.actions = const []});

  final List<String> photos;
  final IconData icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final height = (MediaQuery.sizeOf(context).height * 0.42).clamp(260.0, 420.0);
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: height,
      automaticallyImplyLeading: false,
      backgroundColor: scheme.surface,
      leading: Navigator.of(context).canPop()
          ? Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAction(
                icon: Icons.arrow_back,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            )
          : null,
      actions: [
        for (final a in actions) Padding(padding: const EdgeInsets.only(right: 8), child: a),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: PhotoGallery(photos: photos, icon: icon, counterBottom: 36),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(24),
        child: Container(
          height: 24,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(ZakaRadius.sheet)),
          ),
        ),
      ),
    );
  }
}

/// Bouton cœur : ajoute ou retire des favoris (connexion demandée si besoin).
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.targetId, required this.favorite, this.onImage = false});

  final String targetId;
  final Favorite favorite;

  /// Posé sur une photo : pastille ronde claire pour rester lisible.
  final bool onImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final palette = ZakaPalette.of(context);
    final isFavorite = ref.watch(favoriteIdsProvider).contains(targetId);
    Future<void> toggle() async {
      final uid = ref.read(authStateProvider).value?.uid;
      if (uid == null) {
        context.push('/connexion?retour=${Uri.encodeComponent(GoRouterState.of(context).uri.toString())}');
        return;
      }
      final repo = ref.read(favoritesRepositoryProvider);
      isFavorite ? await repo.remove(uid, targetId) : await repo.add(uid, targetId, favorite);
    }

    final icon = isFavorite ? Icons.favorite : Icons.favorite_border;
    final tooltip = isFavorite ? l10n.favoriteRemove : l10n.favoriteAdd;
    if (onImage) {
      return CircleAction(icon: icon, tooltip: tooltip, color: isFavorite ? palette.heart : null, onPressed: toggle);
    }
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon),
      color: isFavorite ? palette.heart : palette.muted,
      onPressed: toggle,
    );
  }
}

enum BadgeTone { brand, gold, light }

/// Petite pastille (« À vendre », « À la une », « Particulier »…).
class TagBadge extends StatelessWidget {
  const TagBadge({super.key, required this.label, this.tone = BadgeTone.brand});

  final String label;
  final BadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = ZakaPalette.of(context);
    final (bg, fg) = switch (tone) {
      BadgeTone.brand => (ZakaColors.brand, Colors.white),
      BadgeTone.gold => (palette.gold, palette.onGold),
      BadgeTone.light => (scheme.surfaceContainerLow, scheme.onSurface),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: tone == BadgeTone.light ? Border.all(color: palette.line) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Text(label, style: TextStyle(color: fg, fontSize: 11.5, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

/// Ligne de caractéristiques : icône + valeur (chambres, surface…).
class SpecsRow extends StatelessWidget {
  const SpecsRow(this.specs, {super.key, this.dense = true});

  final List<(IconData, String)> specs;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    final style = TextStyle(fontSize: dense ? 12.5 : 14, color: palette.muted, fontWeight: FontWeight.w500);
    return Wrap(
      spacing: dense ? 12 : 18,
      runSpacing: 6,
      children: [
        for (final (icon, text) in specs)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: dense ? 16 : 19, color: palette.muted),
              const SizedBox(width: 4),
              Text(text, style: style),
            ],
          ),
      ],
    );
  }
}

/// Hauteur de la zone de texte d'une carte, ajustée à la taille de police choisie sur l'appareil.
double _cardTextHeight(BuildContext context, {required bool withSpecs}) =>
    MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.4).scale(withSpecs ? 122 : 96);

/// Carte d'annonce : photo, pastilles, cœur, titre, lieu, prix et caractéristiques.
class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.title,
    required this.photo,
    required this.location,
    required this.price,
    required this.onTap,
    this.badges = const [],
    this.specs = const [],
    this.favorite,
    this.icon = Icons.image_outlined,
    this.width,
    this.imageHeight = 180,
  });

  final String title;
  final String? photo;
  final String location;
  final String? price;
  final VoidCallback onTap;
  final List<TagBadge> badges;
  final List<(IconData, String)> specs;
  final FavoriteButton? favorite;
  final IconData icon;
  final double? width;
  final double imageHeight;

  /// Hauteur totale de la carte (grilles et listes horizontales).
  static double heightFor(BuildContext context, {double imageHeight = 180, bool withSpecs = true}) =>
      imageHeight + _cardTextHeight(context, withSpecs: withSpecs);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);
    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ZakaRadius.card),
          boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 18, offset: const Offset(0, 6))],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      NetImage(photo, icon: icon),
                      if (badges.isNotEmpty)
                        Positioned(
                          left: 10,
                          top: 10,
                          right: 56,
                          child: Wrap(spacing: 6, runSpacing: 6, children: badges),
                        ),
                      if (favorite != null) Positioned(right: 8, top: 8, child: favorite!),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(fontSize: 15.5),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 15, color: palette.muted),
                          const SizedBox(width: 3),
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
                        const SizedBox(height: 7),
                        Text(
                          price!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                      if (specs.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        SizedBox(height: 20, child: ClipRect(child: SpecsRow(specs))),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Version compacte en ligne (favoris, listes) : photo à gauche, texte à droite.
class ListingTile extends StatelessWidget {
  const ListingTile({
    super.key,
    required this.title,
    required this.photo,
    required this.location,
    required this.price,
    required this.onTap,
    this.icon = Icons.image_outlined,
    this.badge,
    this.trailing,
  });

  final String title;
  final String? photo;
  final String location;
  final String? price;
  final VoidCallback onTap;
  final IconData icon;
  final TagBadge? badge;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(ZakaRadius.medium),
                child: SizedBox(
                  width: 104,
                  height: 92,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      NetImage(photo, icon: icon),
                      if (badge != null) Positioned(left: 6, top: 6, child: badge!),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    if (location.isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: palette.muted),
                          const SizedBox(width: 3),
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
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Grille de cartes qui s'adapte à la largeur (1 colonne sur téléphone, plusieurs sur le web).
class ListingGrid extends StatelessWidget {
  const ListingGrid({super.key, required this.children, this.padding = const EdgeInsets.all(16), this.withSpecs = true});

  final List<Widget> children;
  final EdgeInsets padding;

  /// Les cartes ont une ligne de caractéristiques.
  final bool withSpecs;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: padding,
    sliver: SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 420,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        mainAxisExtent: ListingCard.heightFor(context, imageHeight: 190, withSpecs: withSpecs),
      ),
      delegate: SliverChildListDelegate(children),
    ),
  );
}

/// Liste horizontale de cartes (accueil).
class HorizontalCards extends StatelessWidget {
  const HorizontalCards({super.key, required this.children, this.imageHeight = 160});

  final List<Widget> children;
  final double imageHeight;

  @override
  Widget build(BuildContext context) => SizedBox(
    // Marge pour l'ombre portée des cartes.
    height: ListingCard.heightFor(context, imageHeight: imageHeight) + 22,
    child: ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
      scrollDirection: Axis.horizontal,
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(width: 14),
      itemBuilder: (_, i) => children[i],
    ),
  );
}

/// Carré arrondi teinté portant une icône (catégories, menus, équipements).
class IconTile extends StatelessWidget {
  const IconTile({super.key, required this.icon, required this.background, required this.foreground, this.size = 44});

  final IconData icon;
  final Color background;
  final Color foreground;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(size * 0.32)),
    child: Icon(icon, color: foreground, size: size * 0.5),
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
    final palette = ZakaPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(color: palette.mint, shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: palette.onMint),
            ),
            const SizedBox(height: 18),
            Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            if (body != null) ...[
              const SizedBox(height: 6),
              Text(body!, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted)),
            ],
            if (action != null) ...[const SizedBox(height: 20), action!],
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
    padding: const EdgeInsets.fromLTRB(16, 24, 6, 10),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontFamily: ZakaTheme.fontFamily, fontWeight: FontWeight.w700, fontSize: 13),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text(actionLabel!), const SizedBox(width: 4), const Icon(Icons.arrow_forward, size: 16)],
            ),
          ),
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
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ZakaRadius.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            IconTile(icon: icon, background: palette.mint, foreground: palette.onMint, size: 36),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
            if (onTap != null) Icon(Icons.chevron_right, color: palette.muted),
          ],
        ),
      ),
    );
  }
}

/// Grille d'atouts sur deux colonnes (équipements, points forts).
class FeatureGrid extends StatelessWidget {
  const FeatureGrid(this.items, {super.key});

  final List<(IconData, String)> items;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    return LayoutBuilder(
      builder: (context, c) {
        final columns = c.maxWidth > 560 ? 3 : 2;
        final w = (c.maxWidth - (columns - 1) * 12) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (icon, label) in items)
              SizedBox(
                width: w,
                child: Row(
                  children: [
                    IconTile(icon: icon, background: palette.mint, foreground: palette.onMint, size: 34),
                    const SizedBox(width: 10),
                    Expanded(child: Text(label, style: const TextStyle(fontSize: 13.5))),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Encadré des caractéristiques principales (chambres, salles de bain, surface).
class SpecsPanel extends StatelessWidget {
  const SpecsPanel(this.specs, {super.key});

  final List<(IconData, String)> specs;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: palette.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < specs.length; i++) ...[
            if (i > 0) Container(width: 1, height: 40, color: palette.line),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Icon(specs[i].$1, size: 22, color: theme.colorScheme.primary),
                    const SizedBox(height: 4),
                    Text(
                      specs[i].$2,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.25),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Groupe de lignes de menu dans une carte (profil, réglages).
class MenuGroup extends StatelessWidget {
  const MenuGroup({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
          child: Text(
            title!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ZakaPalette.of(context).muted),
          ),
        ),
      Card(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) Divider(height: 1, indent: 64, color: ZakaPalette.of(context).line),
              children[i],
            ],
          ],
        ),
      ),
    ],
  );
}

/// Ligne de menu : icône teintée, titre, sous-titre et chevron.
class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.destructive = false,
    this.badge = 0,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool destructive;

  /// Pastille de compteur (notifications non lues).
  final int badge;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    final fg = destructive ? scheme.error : palette.onMint;
    final bg = destructive ? scheme.error.withValues(alpha: 0.1) : palette.mint;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Badge(
        isLabelVisible: badge > 0,
        label: Text('$badge'),
        child: IconTile(icon: icon, background: bg, foreground: fg, size: 40),
      ),
      title: Text(title, style: destructive ? TextStyle(color: scheme.error) : null),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing ?? (onTap == null ? null : Icon(Icons.chevron_right, color: palette.muted)),
      enabled: onTap != null || trailing != null,
      onTap: onTap,
    );
  }
}

/// Onglets en pastilles dans un cadre arrondi (Louer / Acheter / Neuf…).
class PillTabBar extends StatelessWidget implements PreferredSizeWidget {
  const PillTabBar({super.key, this.controller, required this.labels, this.scrollable = false});

  /// Null : celui du [DefaultTabController] parent.
  final TabController? controller;
  final List<String> labels;

  /// Onglets à leur largeur naturelle, défilants (listes longues du back-office).
  final bool scrollable;

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = ZakaPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: palette.line),
        ),
        child: TabBar(
          controller: controller,
          isScrollable: scrollable,
          tabAlignment: scrollable ? TabAlignment.start : null,
          labelPadding: scrollable ? const EdgeInsets.symmetric(horizontal: 18) : null,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(color: scheme.primary, borderRadius: BorderRadius.circular(22)),
          labelColor: scheme.onPrimary,
          unselectedLabelColor: scheme.onSurface,
          splashBorderRadius: BorderRadius.circular(22),
          labelStyle: const TextStyle(fontFamily: ZakaTheme.fontFamily, fontWeight: FontWeight.w700, fontSize: 13.5),
          unselectedLabelStyle: const TextStyle(fontFamily: ZakaTheme.fontFamily, fontWeight: FontWeight.w600, fontSize: 13.5),
          tabs: [for (final l in labels) Tab(text: l, height: 40)],
        ),
      ),
    );
  }
}

/// Contenu centré, limité en largeur sur les grands écrans.
class Readable extends StatelessWidget {
  const Readable({super.key, required this.child, this.maxWidth = 900, this.shrinkHeight = false});

  final Widget child;
  final double maxWidth;

  /// Prend seulement la hauteur du contenu (barres du bas : sinon elles occupent tout l'écran).
  final bool shrinkHeight;

  @override
  Widget build(BuildContext context) => Center(
    heightFactor: shrinkHeight ? 1 : null,
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
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
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
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    final scheme = Theme.of(context).colorScheme;
    Widget button(IconData icon, VoidCallback? onPressed) => IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(color: palette.line, width: 1.2),
        shape: const CircleBorder(),
      ),
    );
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        button(Icons.remove, value > min ? () => onChanged(value - 1) : null),
        SizedBox(
          width: 40,
          child: Text('$value', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ),
        button(Icons.add, value < max ? () => onChanged(value + 1) : null),
      ],
    );
  }
}
