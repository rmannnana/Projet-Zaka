import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/phone.dart';
import '../data/admin_repository.dart';
import 'admin_shell.dart';

/// Champ d'une entrée de catalogue : texte libre ou liste de choix.
class _Field {
  const _Field(this.key, this.label, {this.choices});

  final String key;
  final String label;
  final Map<String, String>? choices;
}

class _Catalog {
  const _Catalog(this.name, this.title, this.fields, {this.withId = true});

  /// Document `catalog/{name}`.
  final String name;
  final String title;
  final List<_Field> fields;

  /// Ajoute un identifiant stable dérivé du libellé (utilisé dans les annonces).
  final bool withId;
}

final _countries = {for (final c in uemoaCountries) c.code: '${c.flag} ${c.name}'};

final _catalogs = [
  _Catalog('cities', 'Villes', [
    const _Field('name', 'Ville'),
    _Field('country', 'Pays', choices: _countries),
  ], withId: false),
  const _Catalog('amenities', 'Équipements', [
    _Field('label', 'Libellé'),
    _Field('scope', 'Pour', choices: {'hotel': 'Hôtels', 'property': 'Biens', 'both': 'Les deux'}),
  ]),
  const _Catalog('propertyTypes', 'Types de biens', [_Field('label', 'Libellé')]),
];

/// Listes de référence utilisées dans les formulaires et la recherche.
class CatalogsScreen extends StatelessWidget {
  const CatalogsScreen({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: _catalogs.length,
    child: Column(
      children: [
        TabBar(tabs: [for (final c in _catalogs) Tab(text: c.title)]),
        Expanded(child: TabBarView(children: [for (final c in _catalogs) _CatalogEditor(catalog: c)])),
      ],
    ),
  );
}

String slug(String label) => label
    .toLowerCase()
    .replaceAll(RegExp('[àâä]'), 'a')
    .replaceAll(RegExp('[éèêë]'), 'e')
    .replaceAll(RegExp('[îï]'), 'i')
    .replaceAll(RegExp('[ôö]'), 'o')
    .replaceAll(RegExp('[ùûü]'), 'u')
    .replaceAll('ç', 'c')
    .replaceAll(RegExp('[^a-z0-9]+'), '_')
    .replaceAll(RegExp(r'^_+|_+$'), '');

class _CatalogEditor extends ConsumerWidget {
  const _CatalogEditor({required this.catalog});

  final _Catalog catalog;

  Future<void> _save(BuildContext context, WidgetRef ref, List<Map<String, dynamic>> items) async {
    try {
      await ref.read(adminRepositoryProvider).saveCatalog(catalog.name, items);
    } catch (e) {
      if (context.mounted) showAdminError(context, e);
    }
  }

  Future<void> _add(BuildContext context, WidgetRef ref, List<Map<String, dynamic>> items) async {
    final values = <String, String>{
      for (final f in catalog.fields)
        if (f.choices != null) f.key: f.choices!.keys.first,
    };
    final controllers = {
      for (final f in catalog.fields)
        if (f.choices == null) f.key: TextEditingController(),
    };
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Ajouter · ${catalog.title}'),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final f in catalog.fields)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: f.choices == null
                        ? TextField(
                            controller: controllers[f.key],
                            autofocus: f == catalog.fields.first,
                            decoration: InputDecoration(labelText: f.label),
                          )
                        : DropdownButtonFormField<String>(
                            initialValue: values[f.key],
                            decoration: InputDecoration(labelText: f.label),
                            items: [
                              for (final e in f.choices!.entries)
                                DropdownMenuItem(value: e.key, child: Text(e.value)),
                            ],
                            onChanged: (v) => setState(() => values[f.key] = v!),
                          ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ajouter')),
          ],
        ),
      ),
    );
    for (final e in controllers.entries) {
      values[e.key] = e.value.text.trim();
      e.value.dispose();
    }
    if (ok != true || values.values.any((v) => v.isEmpty)) return;

    final item = <String, dynamic>{...values};
    if (catalog.withId) {
      final id = slug(values[catalog.fields.first.key]!);
      if (items.any((i) => i['id'] == id)) {
        if (context.mounted) showAdminError(context, 'Cette entrée existe déjà.');
        return;
      }
      item['id'] = id;
    }
    if (!context.mounted) return;
    await _save(context, ref, [...items, item]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(catalogProvider(catalog.name));
    return items.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Chargement impossible : $e')),
      data: (items) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _add(context, ref, items),
          icon: const Icon(Icons.add),
          label: const Text('Ajouter'),
        ),
        body: items.isEmpty
            ? const Center(child: Text('Liste vide. Lancez le script seed-catalog ou ajoutez des entrées.'))
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  final first = catalog.fields.first;
                  final others = catalog.fields.skip(1).map((f) => f.choices?[item[f.key]] ?? item[f.key]);
                  return ListTile(
                    title: Text('${item[first.key]}'),
                    subtitle: Text([...others, if (item['id'] != null) 'id : ${item['id']}'].join(' · ')),
                    trailing: IconButton(
                      tooltip: 'Retirer',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _save(context, ref, [...items]..removeAt(i)),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
