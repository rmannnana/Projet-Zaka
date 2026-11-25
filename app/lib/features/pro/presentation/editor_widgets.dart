import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/catalog.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../listings/data/listings_repository.dart';
import '../../organizations/data/organization_repository.dart';

/// Photos d'une annonce : ajout (plusieurs à la fois), suppression, choix de la couverture.
class PhotosEditor extends ConsumerStatefulWidget {
  const PhotosEditor({
    super.key,
    required this.orgId,
    required this.listingId,
    required this.photos,
    required this.onChanged,
  });

  final String orgId;
  final String listingId;
  final List<String> photos;

  /// Nouvelle liste (la première photo sert de couverture).
  final Future<void> Function(List<String> photos) onChanged;

  @override
  ConsumerState<PhotosEditor> createState() => _PhotosEditorState();
}

class _PhotosEditorState extends ConsumerState<PhotosEditor> {
  bool _uploading = false;

  Future<void> _add() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _uploading = true);
    try {
      final urls = await ref
          .read(listingsRepositoryProvider)
          .pickAndUploadPhotos(widget.orgId, widget.listingId, max: maxPhotos - widget.photos.length);
      if (urls.isNotEmpty) await widget.onChanged([...widget.photos, ...urls]);
    } on PhotoTooLargeException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.photoTooLarge(e.fileName))));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(functionErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _remove(String url) async {
    await widget.onChanged([...widget.photos]..remove(url));
    await ref.read(listingsRepositoryProvider).deletePhoto(url);
  }

  Future<void> _makeCover(String url) => widget.onChanged([url, ...widget.photos.where((p) => p != url)]);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.photosHelp, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final (i, url) in widget.photos.indexed)
              SizedBox(
                width: 160,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ZakaRadius.medium),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      NetImage(url),
                      if (i == 0) Positioned(left: 6, top: 6, child: TagBadge(label: l10n.cover)),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: PopupMenuButton<String>(
                          iconColor: Colors.white,
                          style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha: 0.35)),
                          onSelected: (v) => v == 'cover' ? _makeCover(url) : _remove(url),
                          itemBuilder: (_) => [
                            if (i > 0) PopupMenuItem(value: 'cover', child: Text(l10n.makeCover)),
                            PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.photos.length < maxPhotos)
              SizedBox(
                width: 160,
                height: 120,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: ZakaPalette.of(context).mint.withValues(alpha: 0.5),
                    side: BorderSide(color: scheme.primary.withValues(alpha: 0.35), width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZakaRadius.medium)),
                  ),
                  onPressed: _uploading ? null : _add,
                  child: _uploading
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_a_photo_outlined, color: scheme.primary),
                            const SizedBox(height: 6),
                            Text(l10n.addPhotos, textAlign: TextAlign.center),
                          ],
                        ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Choix des équipements du catalogue (hôtels ou biens).
class AmenitySelector extends ConsumerWidget {
  const AmenitySelector({super.key, required this.selected, required this.forHotels, required this.onChanged});

  final Set<String> selected;
  final bool forHotels;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amenities = ref.watch(amenitiesProvider).value ?? const <Amenity>[];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final a in amenities.where((a) => forHotels ? a.forHotels : a.forProperties))
          FilterChip(
            label: Text(a.label),
            selected: selected.contains(a.id),
            onSelected: (v) => onChanged(v ? {...selected, a.id} : ({...selected}..remove(a.id))),
          ),
      ],
    );
  }
}

/// Ville du catalogue, pour les formulaires.
class CityFormField extends ConsumerWidget {
  const CityFormField({super.key, required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cities = ref.watch(citiesProvider).value ?? const <City>[];
    final names = {for (final c in cities) c.name, if (value.isNotEmpty) value};
    return DropdownButtonFormField<String>(
      initialValue: value.isEmpty ? null : value,
      isExpanded: true,
      decoration: InputDecoration(labelText: l10n.city),
      items: [for (final n in names) DropdownMenuItem(value: n, child: Text(n))],
      onChanged: (v) => onChanged(v ?? ''),
      validator: (v) => v == null || v.isEmpty ? l10n.requiredField : null,
    );
  }
}

/// Champ numérique entier.
class IntField extends StatelessWidget {
  const IntField({super.key, required this.controller, required this.label, this.suffix, this.required = false});

  final TextEditingController controller;
  final String label;
  final String? suffix;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: label, suffixText: suffix),
      validator: required ? (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? l10n.requiredField : null : null,
    );
  }
}

int? intOf(TextEditingController c) => int.tryParse(c.text.trim());

/// Bloc titré d'un formulaire.
class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SectionCard(
    title: title,
    children: [
      for (final (i, c) in children.indexed) ...[if (i > 0) const SizedBox(height: 12), c],
    ],
  );
}

/// Deux champs côte à côte sur grand écran, l'un sous l'autre sur téléphone.
class FieldRow extends StatelessWidget {
  const FieldRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => constraints.maxWidth < 520
        ? Column(
            children: [
              for (final (i, c) in children.indexed) ...[if (i > 0) const SizedBox(height: 12), c],
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, c) in children.indexed) ...[if (i > 0) const SizedBox(width: 12), Expanded(child: c)],
            ],
          ),
  );
}

/// Message d'erreur ou de confirmation après une action.
void showResult(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: error ? Theme.of(context).colorScheme.error : null));
}
