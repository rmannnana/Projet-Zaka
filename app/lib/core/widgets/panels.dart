import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'listing_widgets.dart';

/// Teinte d'une tuile, d'un encadré ou d'un chiffre clé : fond doux et couleur vive.
enum Tone { brand, mint, peach, sage, sky, lavender, danger, neutral }

extension ToneColors on Tone {
  /// (fond, premier plan).
  (Color, Color) colors(BuildContext context) {
    final p = ZakaPalette.of(context);
    final s = Theme.of(context).colorScheme;
    return switch (this) {
      Tone.brand => (s.primaryContainer, s.onPrimaryContainer),
      Tone.mint => (p.mint, p.onMint),
      Tone.peach => (p.peach, p.onPeach),
      Tone.sage => (p.sage, p.onSage),
      Tone.sky => (p.sky, p.onSky),
      Tone.lavender => (p.lavender, p.onLavender),
      Tone.danger => (s.errorContainer, s.onErrorContainer),
      Tone.neutral => (s.surfaceContainerHighest, s.onSurfaceVariant),
    };
  }
}

/// Tuile d'icône teintée selon un [Tone].
class ToneIcon extends StatelessWidget {
  const ToneIcon(this.icon, {super.key, this.tone = Tone.mint, this.size = 44});

  final IconData icon;
  final Tone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = tone.colors(context);
    return IconTile(icon: icon, background: bg, foreground: fg, size: size);
  }
}

/// Avatar rond avec les initiales (membres, clients, équipe).
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(this.name, {super.key, this.size = 44, this.tone = Tone.mint});

  final String name;
  final double size;
  final Tone tone;

  static String initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'[\s@.]+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first.characters.first;
    final second = parts.length > 1 ? parts[1].characters.first : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = tone.colors(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(
        initialsOf(name),
        style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: size * 0.36),
      ),
    );
  }
}

/// Bandeau vert dégradé avec le logo en filigrane (en-tête d'espace pro, plan en cours).
class BrandCard extends StatelessWidget {
  const BrandCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.onTap});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
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
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              right: -18,
              bottom: -26,
              child: ZakaLogo(size: 140, color: Colors.white.withValues(alpha: 0.08)),
            ),
            Padding(
              padding: padding,
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.white),
                child: child,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Pastille sur fond vert (statut dans un [BrandCard]).
class OnBrandPill extends StatelessWidget {
  const OnBrandPill(this.label, {super.key, this.icon, this.gold = false});

  final String label;
  final IconData? icon;

  /// Doré plein (mise en avant) plutôt que blanc translucide.
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    final fg = gold ? palette.onGold : Colors.white;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: gold ? palette.gold : Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 14, color: fg), const SizedBox(width: 5)],
            Text(
              label,
              style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chiffre clé : icône teintée, valeur en grand et libellé.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.tone = Tone.mint,
    this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final Tone tone;
  final VoidCallback? onTap;

  /// Bordure de couleur : il y a quelque chose à traiter.
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);
    final (_, fg) = tone.colors(context);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ZakaRadius.card),
        side: BorderSide(color: highlight ? fg.withValues(alpha: 0.6) : palette.line, width: highlight ? 1.5 : 1),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ToneIcon(icon, tone: tone, size: 40),
                  const Spacer(),
                  if (onTap != null) Icon(Icons.arrow_forward, size: 18, color: palette.muted),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: highlight ? fg : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(color: palette.muted, height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grille de [StatCard] : 2 colonnes sur téléphone, plus sur grand écran.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.children, this.minWidth = 160});

  final List<Widget> children;
  final double minWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final columns = (c.maxWidth / minWidth).floor().clamp(2, 4);
      final w = (c.maxWidth - (columns - 1) * 12) / columns;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [for (final child in children) SizedBox(width: w, child: child)],
      );
    },
  );
}

/// Encadré d'information teinté : aide, avertissement, motif de refus.
class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.text,
    this.title,
    this.icon = Icons.info_outline,
    this.tone = Tone.mint,
    this.action,
  });

  final String text;
  final String? title;
  final IconData icon;
  final Tone tone;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = tone.colors(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(ZakaRadius.medium)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(color: fg, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(text, style: theme.textTheme.bodyMedium?.copyWith(height: 1.4)),
                if (action != null) ...[const SizedBox(height: 10), action!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte blanche titrée qui regroupe un bloc (formulaire, fiche, liste).
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    required this.children,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 14),
  });

  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);
    return Card(
      margin: margin,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: palette.muted)),
                          ),
                      ],
                    ),
                  ),
                  ?trailing,
                ],
              ),
              const SizedBox(height: 12),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Lignes séparées par un trait fin, dans une carte blanche (listes de demandes, de comptes…).
class CardList extends StatelessWidget {
  const CardList({super.key, required this.children, this.indent = 16, this.margin = EdgeInsets.zero});

  final List<Widget> children;
  final double indent;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final line = ZakaPalette.of(context).line;
    return Card(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, indent: indent, endIndent: indent, color: line),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Libellé + valeur, pour les fiches (back-office, dossier de vérification).
class FieldLine extends StatelessWidget {
  const FieldLine(this.label, this.value, {super.key, this.selectable = false});

  final String label;
  final String? value;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    final text = value == null || value!.isEmpty ? '-' : value!;
    const style = TextStyle(fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: LayoutBuilder(
        builder: (context, c) {
          final label = Text(this.label, style: TextStyle(color: palette.muted, fontSize: 13));
          final value = selectable ? SelectableText(text, style: style) : Text(text, style: style);
          if (c.maxWidth < 420) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [label, const SizedBox(height: 2), value],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 170, child: label),
              Expanded(child: value),
            ],
          );
        },
      ),
    );
  }
}

/// Rangée de filtres en pastilles, défilante.
class FilterChipsBar<T> extends StatelessWidget {
  const FilterChipsBar({
    super.key,
    required this.values,
    required this.selected,
    required this.label,
    required this.onSelected,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) label;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: Row(
      children: [
        for (final v in values)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(label: Text(label(v)), selected: v == selected, onSelected: (_) => onSelected(v)),
          ),
      ],
    ),
  );
}

/// Titre de page avec une phrase d'explication (écrans pros et back-office).
class PageIntro extends StatelessWidget {
  const PageIntro({super.key, this.title, required this.text, this.padding = const EdgeInsets.only(bottom: 16)});

  final String? title;
  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
          ],
          Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: ZakaPalette.of(context).muted, height: 1.45)),
        ],
      ),
    );
  }
}

/// Ligne d'une demande (réservation ou contact) : icône teintée par statut, textes, statut.
class RequestRow extends StatelessWidget {
  const RequestRow({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.lines,
    required this.status,
    this.onTap,
    this.leading,
  });

  final IconData icon;

  /// Couleur du statut : teinte l'icône.
  final Color color;
  final String title;
  final List<String> lines;
  final String status;
  final VoidCallback? onTap;

  /// Remplace l'icône (photo de l'annonce côté client).
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading ?? IconTile(icon: icon, background: color.withValues(alpha: 0.12), foreground: color, size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusPill(status, color),
                    ],
                  ),
                  for (final line in lines.where((l) => l.isNotEmpty))
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        line,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: palette.muted, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
            if (onTap != null)
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 10),
                child: Icon(Icons.chevron_right, color: palette.muted, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}

/// Carte du client d'une demande : initiales, coordonnées, appel et WhatsApp.
class ClientCard extends StatelessWidget {
  const ClientCard({super.key, required this.name, this.subtitle, this.trailing, this.actions = const []});

  final String name;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                InitialsAvatar(name, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      if (subtitle != null && subtitle!.isNotEmpty)
                        Text(subtitle!, style: TextStyle(color: palette.muted, fontSize: 13)),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final (i, a) in actions.indexed) ...[if (i > 0) const SizedBox(width: 8), Expanded(child: a)],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
