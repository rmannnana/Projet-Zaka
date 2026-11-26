import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/catalog.dart';
import '../../../core/links.dart';
import '../../../core/open_bytes.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../listings/domain/listing.dart';
import '../../listings/presentation/listing_labels.dart';
import '../data/admin_repository.dart';
import '../data/moderation_repository.dart';
import 'admin_shell.dart';

final _date = DateFormat('d MMM yyyy, HH:mm', 'fr');

/// File de validation des annonces de particuliers : publier, ou refuser avec motif.
class ListingReviewScreen extends ConsumerWidget {
  const ListingReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingListingsProvider);
    return pending.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Chargement impossible : $e')),
      data: (items) => items.isEmpty
          ? const EmptyState(icon: Icons.fact_check_outlined, title: 'Aucune annonce à valider.')
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "Vérifiez que l'annonce est réaliste (photos, prix, adresse), sans coordonnées "
                  'dans le texte ni contenu trompeur. Un refus est motivé : le propriétaire peut corriger.',
                ),
                const SizedBox(height: 12),
                for (final p in items) _ReviewCard(property: p),
              ],
            ),
    );
  }
}

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({required this.property});

  final Property property;

  Future<void> _decide(BuildContext context, WidgetRef ref, bool publish) async {
    String? note;
    if (!publish) {
      note = await askNote(
        context,
        title: "Refuser l'annonce",
        confirmLabel: 'Refuser',
        help: 'Le motif est envoyé au propriétaire.',
      );
      if (note == null) return;
    }
    try {
      await ref.read(moderationRepositoryProvider).reviewListing(property.id, publish: publish, note: note);
      ref.invalidate(activityCountersProvider);
    } catch (e) {
      if (context.mounted) showAdminError(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final p = property;
    final types = ref.watch(propertyTypesProvider).value ?? const <PropertyType>[];
    final amenities = ref.watch(amenitiesProvider).value ?? const <Amenity>[];
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final url in p.photos)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(width: 200, child: NetImage(url)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(p.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text(
              [
                p.transactionLabel(l10n),
                if (p.propertyType.isNotEmpty) types.label(p.propertyType),
                p.priceLabel(l10n),
                placeOf(p.district, p.city),
              ].join(' · '),
            ),
            Text('Par ${p.orgName ?? p.orgId}', style: Theme.of(context).textTheme.bodySmall),
            if (p.description.isNotEmpty) ...[const SizedBox(height: 8), Text(p.description)],
            if (p.features.isNotEmpty) Text('Atouts : ${p.features.map(amenities.label).join(', ')}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                  onPressed: () => _decide(context, ref, true),
                  icon: const Icon(Icons.check),
                  label: const Text('Publier'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _decide(context, ref, false),
                  icon: const Icon(Icons.close),
                  label: const Text('Refuser'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Suspension (ou rétablissement) d'une annonce signalée.
Future<void> moderateFromReport(BuildContext context, WidgetRef ref, ListingKind kind, String id) async {
  final repo = ref.read(moderationRepositoryProvider);
  try {
    final status = await repo.listingStatus(kind, id);
    if (status == null) {
      if (context.mounted) showAdminError(context, 'Annonce introuvable (supprimée ?).');
      return;
    }
    if (!context.mounted) return;
    final suspended = status == 'suspended';
    final note = await askNote(
      context,
      title: suspended ? "Rétablir l'annonce" : "Suspendre l'annonce",
      confirmLabel: suspended ? 'Rétablir' : 'Suspendre',
      help: suspended
          ? "L'annonce retrouvera son état précédent."
          : "L'annonce est retirée du site et le publieur est prévenu avec ce motif.",
      required: !suspended,
    );
    if (note == null) return;
    await repo.moderateListing(kind, id, suspend: !suspended, note: note);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(suspended ? 'Annonce rétablie.' : 'Annonce suspendue.')));
    }
  } catch (e) {
    if (context.mounted) showAdminError(context, e);
  }
}

/// Lien public d'une annonce.
String publicListingUrl(ListingKind kind, String id) => '$publicSiteUrl/${switch (kind) {
  ListingKind.hotel => 'hotel',
  ListingKind.property => 'bien',
  ListingKind.project => 'programme',
}}/$id';

/// Litiges : export du dossier d'une réservation ou d'une demande de contact (tracé).
class DisputesScreen extends ConsumerStatefulWidget {
  const DisputesScreen({super.key});

  @override
  ConsumerState<DisputesScreen> createState() => _DisputesScreenState();
}

class _DisputesScreenState extends ConsumerState<DisputesScreen> {
  final _id = TextEditingController();
  bool _booking = true;
  AdminRecord? _found;
  bool _busy = false;

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    setState(() => _busy = true);
    try {
      final record = await ref
          .read(moderationRepositoryProvider)
          .request(_booking ? 'bookingRequests' : 'leads', _id.text.trim());
      setState(() => _found = record);
      if (record == null && mounted) showAdminError(context, 'Aucune demande avec cet identifiant.');
    } catch (e) {
      if (mounted) showAdminError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() async {
    final reason = await askNote(
      context,
      title: 'Exporter le dossier',
      confirmLabel: 'Exporter',
      help: "Motif de l'export (réclamation, demande d'une autorité…). Il est tracé.",
    );
    if (reason == null || reason.length < 3) return;
    setState(() => _busy = true);
    try {
      final path = await ref.read(moderationRepositoryProvider).exportDispute(booking: _booking, id: _found!.id, reason: reason);
      await _open(path);
    } catch (e) {
      if (mounted) showAdminError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(String path) async {
    final bytes = await ref.read(moderationRepositoryProvider).exportBytes(path);
    await openBytes(bytes, 'application/json');
  }

  @override
  Widget build(BuildContext context) {
    final exports = ref.watch(disputeExportsProvider).value ?? const <AdminRecord>[];
    final found = _found;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "ZAKA n'arbitre pas les litiges entre clients et professionnels : elle fournit les informations "
          'utiles (historique, messages, dates). Chaque export est tracé.',
        ),
        const SizedBox(height: 16),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('Réservation')),
            ButtonSegment(value: false, label: Text('Demande de contact')),
          ],
          selected: {_booking},
          onSelectionChanged: (s) => setState(() {
            _booking = s.first;
            _found = null;
          }),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _id,
                decoration: const InputDecoration(labelText: 'Identifiant de la demande'),
                onSubmitted: (_) => _search(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
              onPressed: _busy ? null : _search,
              child: const Text('Chercher'),
            ),
          ],
        ),
        if (found != null)
          Card.outlined(
            margin: const EdgeInsets.only(top: 16),
            child: ListTile(
              title: Text(_booking
                  ? '${found.str('hotelName')} · ${found.data['clientSnapshot']?['name'] ?? ''}'
                  : '${found.str('targetTitle')} · ${found.data['clientSnapshot']?['name'] ?? ''}'),
              subtitle: Text('Statut : ${found.str('status')} · créée le '
                  '${found.date('createdAt') == null ? '?' : _date.format(found.date('createdAt')!)}'),
              trailing: FilledButton.tonal(onPressed: _busy ? null : _export, child: const Text('Exporter')),
            ),
          ),
        const SizedBox(height: 24),
        Text('Exports récents', style: Theme.of(context).textTheme.titleMedium),
        for (final e in exports)
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(e.str('targetRef') ?? ''),
            subtitle: Text('${e.str('reason') ?? ''}\n'
                '${e.date('at') == null ? '' : _date.format(e.date('at')!)} · par ${e.str('requestedBy')}'),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: 'Ouvrir',
              icon: const Icon(Icons.open_in_new),
              onPressed: () => _open(e.str('path')!).catchError((Object err) {
                if (context.mounted) showAdminError(context, err);
              }),
            ),
          ),
      ],
    );
  }
}

/// Ouvre l'annonce publique dans un nouvel onglet.
Future<void> openPublicListing(ListingKind kind, String id) => openExternal(publicListingUrl(kind, id));
