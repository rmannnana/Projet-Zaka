import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/catalog.dart';
import '../../../core/money.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/domain/listing.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../organizations/data/organization_repository.dart';
import 'editor_widgets.dart';

/// Bouton « Publier » (ou « Envoyer à la validation ») d'une annonce.
class PublishButton extends ConsumerWidget {
  const PublishButton({super.key, required this.kind, required this.id, required this.status, required this.review});

  final ListingKind kind;
  final String id;
  final ListingStatus status;
  final bool review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (!status.canPublish) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilledButton(
        style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
        onPressed: () async {
          try {
            final result = await ref.read(listingsRepositoryProvider).publish(kind, id);
            if (context.mounted) {
              showResult(context, result == ListingStatus.pendingReview ? l10n.sentForReview : l10n.publishedNow);
            }
          } catch (e) {
            if (context.mounted) showResult(context, functionErrorMessage(e), error: true);
          }
        },
        child: Text(review ? l10n.sendForReview : l10n.publish),
      ),
    );
  }
}

/// Création et modification d'un bien à louer ou à vendre.
class PropertyEditorScreen extends ConsumerWidget {
  const PropertyEditorScreen({super.key, required this.orgId, required this.propertyId});

  final String orgId;
  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final property = ref.watch(propertyProvider(propertyId)).value;
    final org = ref.watch(organizationProvider(orgId)).value;
    if (property == null || org == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(property.title.isEmpty ? l10n.newProperty : property.title),
        actions: [
          Center(child: StatusPill(property.status.label(l10n), property.status.color(scheme))),
          const SizedBox(width: 8),
          PublishButton(
            kind: ListingKind.property,
            id: propertyId,
            status: property.status,
            review: org.requiresListingReview,
          ),
        ],
      ),
      body: _PropertyForm(property: property, review: org.requiresListingReview, orgId: orgId),
    );
  }
}

class _PropertyForm extends ConsumerStatefulWidget {
  const _PropertyForm({required this.property, required this.review, required this.orgId});

  final Property property;
  final bool review;
  final String orgId;

  @override
  ConsumerState<_PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends ConsumerState<_PropertyForm> {
  final _form = GlobalKey<FormState>();
  late final p = widget.property;
  late final _title = TextEditingController(text: p.title);
  late final _description = TextEditingController(text: p.description);
  late final _district = TextEditingController(text: p.district);
  late final _address = TextEditingController(text: p.address);
  late final _price = TextEditingController(text: p.price.amount == 0 ? '' : '${p.price.amount}');
  late final _surface = TextEditingController(text: p.surface?.toString() ?? '');
  late final _rooms = TextEditingController(text: p.rooms?.toString() ?? '');
  late final _bedrooms = TextEditingController(text: p.bedrooms?.toString() ?? '');
  late final _bathrooms = TextEditingController(text: p.bathrooms?.toString() ?? '');
  late final _deposit = TextEditingController(text: p.conditions.deposit);
  late final _advance = TextEditingController(text: p.conditions.advance);
  late final _fees = TextEditingController(text: p.conditions.agencyFees);
  late TransactionType _transaction = p.transactionType;
  late String _type = p.propertyType;
  late String _city = p.city;
  late RentPeriod _period = p.rentPeriod ?? RentPeriod.month;
  late Set<String> _features = {...p.features};
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [
      _title,
      _description,
      _district,
      _address,
      _price,
      _surface,
      _rooms,
      _bedrooms,
      _bathrooms,
      _deposit,
      _advance,
      _fees,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_form.currentState!.validate()) return;
    final current = ref.read(propertyProvider(p.id)).value ?? p;
    ListingStatus? status;
    if (widget.review && current.status == ListingStatus.published) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.reviewAgainTitle),
          content: Text(l10n.reviewAgainBody),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.save)),
          ],
        ),
      );
      if (ok != true) return;
      status = ListingStatus.pendingReview;
    }
    setState(() => _saving = true);
    try {
      await ref.read(listingsRepositoryProvider).update(ListingKind.property, p.id, {
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        'transactionType': _transaction.name,
        'propertyType': _type,
        'city': _city,
        'district': _district.text.trim(),
        'address': _address.text.trim(),
        'price': Money(intOf(_price) ?? 0).toJson(),
        'rentPeriod': _transaction == TransactionType.rent ? _period.name : null,
        'surface': intOf(_surface),
        'rooms': intOf(_rooms),
        'bedrooms': intOf(_bedrooms),
        'bathrooms': intOf(_bathrooms),
        'features': _features.toList(),
        'conditions': PropertyConditions(
          deposit: _deposit.text.trim(),
          advance: _advance.text.trim(),
          agencyFees: _fees.text.trim(),
        ).toJson(),
      }, status: status);
      if (mounted) showResult(context, l10n.saved);
    } catch (e) {
      if (mounted) showResult(context, functionErrorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final types = ref.watch(propertyTypesProvider).value ?? const <PropertyType>[];
    final live = ref.watch(propertyProvider(p.id)).value ?? p;
    return Form(
      key: _form,
      child: Readable(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.review) ...[
              NoticeCard(text: l10n.listingsReviewedByZaka, icon: Icons.fact_check_outlined),
              const SizedBox(height: 14),
            ],
            if (live.moderation?.reason != null && live.status == ListingStatus.rejected) ...[
              NoticeCard(
                text: l10n.moderationReason(live.moderation!.reason!),
                icon: Icons.feedback_outlined,
                tone: Tone.danger,
              ),
              const SizedBox(height: 14),
            ],
            FormSection(
              title: l10n.listingMain,
              children: [
                SegmentedButton<TransactionType>(
                  segments: [
                    ButtonSegment(value: TransactionType.rent, label: Text(l10n.forRent)),
                    ButtonSegment(value: TransactionType.sale, label: Text(l10n.forSale)),
                  ],
                  selected: {_transaction},
                  onSelectionChanged: (s) => setState(() => _transaction = s.first),
                ),
                DropdownButtonFormField<String>(
                  initialValue: _type.isEmpty ? null : _type,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.propertyType),
                  items: [for (final t in types) DropdownMenuItem(value: t.id, child: Text(t.label))],
                  onChanged: (v) => setState(() => _type = v ?? ''),
                  validator: (v) => v == null ? l10n.requiredField : null,
                ),
                TextFormField(
                  controller: _title,
                  maxLength: 120,
                  decoration: InputDecoration(labelText: l10n.listingTitle, hintText: l10n.listingTitleHint),
                  validator: (v) => (v ?? '').trim().length < 5 ? l10n.requiredField : null,
                ),
                TextFormField(
                  controller: _description,
                  maxLines: 6,
                  maxLength: 5000,
                  decoration: InputDecoration(labelText: l10n.description, alignLabelWithHint: true),
                ),
              ],
            ),
            FormSection(
              title: l10n.priceSection,
              children: [
                FieldRow(
                  children: [
                    IntField(controller: _price, label: l10n.price, suffix: 'FCFA', required: true),
                    if (_transaction == TransactionType.rent)
                      DropdownButtonFormField<RentPeriod>(
                        initialValue: _period,
                        decoration: InputDecoration(labelText: l10n.rentPeriod),
                        items: [
                          DropdownMenuItem(value: RentPeriod.month, child: Text(l10n.perMonth)),
                          DropdownMenuItem(value: RentPeriod.day, child: Text(l10n.perDay)),
                        ],
                        onChanged: (v) => setState(() => _period = v ?? RentPeriod.month),
                      ),
                  ],
                ),
                if (_transaction == TransactionType.rent) ...[
                  FieldRow(
                    children: [
                      TextFormField(
                        controller: _deposit,
                        decoration: InputDecoration(labelText: l10n.deposit, hintText: l10n.depositHint),
                      ),
                      TextFormField(
                        controller: _advance,
                        decoration: InputDecoration(labelText: l10n.advance, hintText: l10n.advanceHint),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _fees,
                    decoration: InputDecoration(labelText: l10n.agencyFees),
                  ),
                ],
              ],
            ),
            FormSection(
              title: l10n.characteristics,
              children: [
                FieldRow(
                  children: [
                    IntField(controller: _surface, label: l10n.surface, suffix: 'm²'),
                    IntField(controller: _rooms, label: l10n.roomsLabel),
                  ],
                ),
                FieldRow(
                  children: [
                    IntField(controller: _bedrooms, label: l10n.bedrooms),
                    IntField(controller: _bathrooms, label: l10n.bathrooms),
                  ],
                ),
                AmenitySelector(selected: _features, forHotels: false, onChanged: (v) => setState(() => _features = v)),
              ],
            ),
            FormSection(
              title: l10n.location,
              children: [
                FieldRow(
                  children: [
                    CityFormField(value: _city, onChanged: (v) => setState(() => _city = v)),
                    TextFormField(
                      controller: _district,
                      decoration: InputDecoration(labelText: l10n.district),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _address,
                  decoration: InputDecoration(labelText: l10n.address, helperText: l10n.addressHelp),
                ),
              ],
            ),
            FormSection(
              title: l10n.tabPhotos,
              children: [
                PhotosEditor(
                  orgId: widget.orgId,
                  listingId: p.id,
                  photos: live.photos,
                  onChanged: (photos) => ref.read(listingsRepositoryProvider).update(
                    ListingKind.property,
                    p.id,
                    {'photos': photos},
                    status: widget.review && live.status == ListingStatus.published
                        ? ListingStatus.pendingReview
                        : null,
                  ),
                ),
              ],
            ),
            FilledButton(
              onPressed: _saving || live.status == ListingStatus.pendingReview ? null : _save,
              child: Text(live.status == ListingStatus.pendingReview ? l10n.waitingForReview : l10n.save),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Création et modification d'un programme immobilier et de ses lots.
class ProjectEditorScreen extends ConsumerWidget {
  const ProjectEditorScreen({super.key, required this.orgId, required this.projectId});

  final String orgId;
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final project = ref.watch(projectProvider(projectId)).value;
    if (project == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title.isEmpty ? l10n.newProjectListing : project.title),
        actions: [
          Center(child: StatusPill(project.status.label(l10n), project.status.color(scheme))),
          const SizedBox(width: 8),
          PublishButton(kind: ListingKind.project, id: projectId, status: project.status, review: false),
        ],
      ),
      body: _ProjectForm(project: project, orgId: orgId),
    );
  }
}

class _ProjectForm extends ConsumerStatefulWidget {
  const _ProjectForm({required this.project, required this.orgId});

  final Project project;
  final String orgId;

  @override
  ConsumerState<_ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<_ProjectForm> {
  final _form = GlobalKey<FormState>();
  late final p = widget.project;
  late final _title = TextEditingController(text: p.title);
  late final _description = TextEditingController(text: p.description);
  late final _district = TextEditingController(text: p.district);
  late final _address = TextEditingController(text: p.address);
  late final _delivery = TextEditingController(text: p.deliveryDate);
  late final _budget = TextEditingController(text: p.estimatedBudget?.amount.toString() ?? '');
  late String _city = p.city;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_title, _description, _district, _address, _delivery, _budget]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final budget = intOf(_budget);
      await ref.read(listingsRepositoryProvider).update(ListingKind.project, p.id, {
        'title': _title.text.trim(),
        'description': _description.text.trim(),
        'city': _city,
        'district': _district.text.trim(),
        'address': _address.text.trim(),
        'deliveryDate': _delivery.text.trim(),
        'estimatedBudget': budget == null ? null : Money(budget).toJson(),
      });
      if (mounted) showResult(context, l10n.saved);
    } catch (e) {
      if (mounted) showResult(context, functionErrorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final live = ref.watch(projectProvider(p.id)).value ?? p;
    final units = ref.watch(unitsProvider(p.id)).value ?? const <ProjectUnit>[];
    final types = ref.watch(propertyTypesProvider).value ?? const <PropertyType>[];
    final scheme = Theme.of(context).colorScheme;
    return Form(
      key: _form,
      child: Readable(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FormSection(
              title: l10n.listingMain,
              children: [
                TextFormField(
                  controller: _title,
                  maxLength: 120,
                  decoration: InputDecoration(labelText: l10n.projectName),
                  validator: (v) => (v ?? '').trim().length < 3 ? l10n.requiredField : null,
                ),
                TextFormField(
                  controller: _description,
                  maxLines: 6,
                  maxLength: 5000,
                  decoration: InputDecoration(labelText: l10n.description, alignLabelWithHint: true),
                ),
                FieldRow(
                  children: [
                    TextFormField(
                      controller: _delivery,
                      decoration: InputDecoration(labelText: l10n.deliveryDate, hintText: l10n.deliveryDateHint),
                    ),
                    IntField(controller: _budget, label: l10n.estimatedBudget, suffix: 'FCFA'),
                  ],
                ),
              ],
            ),
            FormSection(
              title: l10n.location,
              children: [
                FieldRow(
                  children: [
                    CityFormField(value: _city, onChanged: (v) => setState(() => _city = v)),
                    TextFormField(
                      controller: _district,
                      decoration: InputDecoration(labelText: l10n.district),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _address,
                  decoration: InputDecoration(labelText: l10n.address),
                ),
              ],
            ),
            FilledButton(onPressed: _saving ? null : _save, child: Text(l10n.save)),
            const SizedBox(height: 24),
            FormSection(
              title: l10n.tabPhotos,
              children: [
                PhotosEditor(
                  orgId: widget.orgId,
                  listingId: p.id,
                  photos: live.photos,
                  onChanged: (photos) =>
                      ref.read(listingsRepositoryProvider).update(ListingKind.project, p.id, {'photos': photos}),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.units,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => _UnitDialog(projectId: p.id),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addUnit),
                ),
              ],
            ),
            if (units.isEmpty) Text(l10n.noUnitYet),
            for (final u in units)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  leading: const ToneIcon(Icons.apartment, tone: Tone.lavender),
                  title: Text(
                    [u.label, if (u.propertyType.isNotEmpty) types.label(u.propertyType)].join(' · '),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    [
                      if (u.surface != null) l10n.surfaceValue(u.surface!),
                      if (u.rooms != null) l10n.roomsValue(u.rooms!),
                      u.price.format(),
                    ].join(' · '),
                  ),
                  trailing: StatusPill(u.status.label(l10n), u.status.color(scheme)),
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (_) => _UnitDialog(projectId: p.id, unit: u),
                  ),
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _UnitDialog extends ConsumerStatefulWidget {
  const _UnitDialog({required this.projectId, this.unit});

  final String projectId;
  final ProjectUnit? unit;

  @override
  ConsumerState<_UnitDialog> createState() => _UnitDialogState();
}

class _UnitDialogState extends ConsumerState<_UnitDialog> {
  late final u = widget.unit ?? const ProjectUnit();
  late final _label = TextEditingController(text: u.label);
  late final _surface = TextEditingController(text: u.surface?.toString() ?? '');
  late final _rooms = TextEditingController(text: u.rooms?.toString() ?? '');
  late final _price = TextEditingController(text: u.price.amount == 0 ? '' : '${u.price.amount}');
  late String _type = u.propertyType;
  late UnitStatus _status = u.status;

  @override
  void dispose() {
    for (final c in [_label, _surface, _rooms, _price]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_label.text.trim().isEmpty || (intOf(_price) ?? 0) <= 0) return;
    await ref
        .read(listingsRepositoryProvider)
        .saveUnit(
          widget.projectId,
          ProjectUnit(
            label: _label.text.trim(),
            propertyType: _type,
            surface: intOf(_surface),
            rooms: intOf(_rooms),
            price: Money(intOf(_price)!),
            status: _status,
          ).toJson(),
          id: widget.unit?.id,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final types = ref.watch(propertyTypesProvider).value ?? const <PropertyType>[];
    return AlertDialog(
      title: Text(widget.unit == null ? l10n.addUnit : l10n.editUnit),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _label,
                decoration: InputDecoration(labelText: l10n.unitName, hintText: 'A1'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _type.isEmpty ? null : _type,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.propertyType),
                items: [for (final t in types) DropdownMenuItem(value: t.id, child: Text(t.label))],
                onChanged: (v) => setState(() => _type = v ?? ''),
              ),
              const SizedBox(height: 12),
              FieldRow(
                children: [
                  IntField(controller: _surface, label: l10n.surface, suffix: 'm²'),
                  IntField(controller: _rooms, label: l10n.roomsLabel),
                ],
              ),
              const SizedBox(height: 12),
              IntField(controller: _price, label: l10n.price, suffix: 'FCFA', required: true),
              const SizedBox(height: 12),
              SegmentedButton<UnitStatus>(
                segments: [for (final s in UnitStatus.values) ButtonSegment(value: s, label: Text(s.label(l10n)))],
                selected: {_status},
                onSelectionChanged: (s) => setState(() => _status = s.first),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.unit != null)
          TextButton(
            onPressed: () async {
              await ref.read(listingsRepositoryProvider).deleteUnit(widget.projectId, widget.unit!.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.delete),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
