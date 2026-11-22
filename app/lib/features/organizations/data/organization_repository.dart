import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firestore_json.dart';
import '../../account/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/organization.dart';

/// Pièce justificative exigée des pros.
enum DocumentKind {
  ifu('ifu'),
  rccm('rccm'),
  proofOfAddress('proofOfAddress');

  const DocumentKind(this.key);

  /// Nom utilisé dans Firestore et Storage.
  final String key;
}

const allowedDocumentExtensions = ['pdf', 'jpg', 'jpeg', 'png', 'webp'];
const maxDocumentBytes = 10 * 1024 * 1024;

String contentTypeFor(String extension) => switch (extension.toLowerCase()) {
  'pdf' => 'application/pdf',
  'png' => 'image/png',
  'webp' => 'image/webp',
  _ => 'image/jpeg',
};

/// Données saisies à la création d'un espace publieur.
class NewOrganization {
  const NewOrganization({
    required this.type,
    required this.name,
    required this.phone,
    required this.city,
    this.country = 'BF',
    this.description = '',
    this.email,
    this.address,
  });

  final OrgType type;
  final String name;
  final String description;
  final String phone;
  final String? email;
  final String? address;
  final String city;
  final String country;

  Map<String, dynamic> toJson() => {
    'type': type == OrgType.individualOwner ? 'individual_owner' : type.name,
    'name': name.trim(),
    'description': description.trim(),
    'contact': {
      'phone': phone.trim(),
      if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
      if (address != null && address!.trim().isNotEmpty) 'address': address!.trim(),
      'city': city.trim(),
      'country': country,
    },
  };
}

class OrganizationRepository {
  OrganizationRepository(this._db, this._functions, this._storage);

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _orgs => _db.collection('organizations');

  Stream<Organization?> watch(String orgId) => _orgs
      .doc(orgId)
      .snapshots()
      .map((snap) => snap.exists ? fromDoc(snap, Organization.fromJson) : null);

  /// Organisations dont l'utilisateur est membre (30 au plus, limite de `whereIn`).
  Stream<List<Organization>> watchMany(List<String> orgIds) {
    if (orgIds.isEmpty) return Stream.value(const []);
    return _orgs
        .where(FieldPath.documentId, whereIn: orgIds.take(30).toList())
        .snapshots()
        .map((q) => q.docs.map((d) => fromDoc(d, Organization.fromJson)).toList());
  }

  Stream<List<OrgMember>> watchMembers(String orgId) => _orgs
      .doc(orgId)
      .collection('members')
      .snapshots()
      .map((q) => q.docs.map((d) => fromDoc(d, OrgMember.fromJson)).toList());

  /// Crée l'espace via la Cloud Function `createOrganization`.
  Future<String> create(NewOrganization org) async {
    final result = await _functions
        .httpsCallable('createOrganization')
        .call<Map<String, dynamic>>(org.toJson());
    return result.data['orgId'] as String;
  }

  /// Modifie le profil public (nom, description, contact).
  Future<void> updateProfile(
    String orgId, {
    required String name,
    required String description,
    required OrgContact contact,
  }) => _orgs.doc(orgId).update({
    'name': name.trim(),
    'description': description.trim(),
    'contact': contact.toJson(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  /// Données légales : modifiables tant que le dossier n'est pas envoyé.
  Future<void> updateLegal(String orgId, OrgLegal legal) => _orgs.doc(orgId).update({
    'legal': legal.toJson(),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  /// Envoie une pièce dans l'espace privé du compte et renvoie son chemin.
  /// Chaque envoi crée un nouveau fichier : les pièces ne sont jamais écrasées.
  Future<String> uploadDocument(
    String orgId,
    DocumentKind kind, {
    required Uint8List bytes,
    required String extension,
  }) async {
    final ext = extension.toLowerCase();
    final path = 'private/verification/$orgId/${kind.key}_${DateTime.now().millisecondsSinceEpoch}.$ext';
    await _storage.ref(path).putData(bytes, SettableMetadata(contentType: contentTypeFor(ext)));
    return path;
  }

  Future<void> submitVerification(String orgId, Map<DocumentKind, String> documents) =>
      _functions.httpsCallable('submitOrgVerification').call<void>({
        'orgId': orgId,
        'documents': {for (final e in documents.entries) e.key.key: e.value},
      });

  Future<void> addMember(String orgId, {required String email, required OrgRole role}) =>
      _functions.httpsCallable('addOrgMember').call<void>({
        'orgId': orgId,
        'email': email.trim(),
        'role': role.name,
      });

  Future<void> removeMember(String orgId, String uid) =>
      _functions.httpsCallable('removeOrgMember').call<void>({'orgId': orgId, 'uid': uid});
}

final storageProvider = Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

final organizationRepositoryProvider = Provider<OrganizationRepository>(
  (ref) => OrganizationRepository(
    ref.watch(firestoreProvider),
    ref.watch(functionsProvider),
    ref.watch(storageProvider),
  ),
);

final organizationProvider = StreamProvider.family<Organization?, String>(
  (ref, orgId) => ref.watch(organizationRepositoryProvider).watch(orgId),
);

final orgMembersProvider = StreamProvider.family<List<OrgMember>, String>(
  (ref, orgId) => ref.watch(organizationRepositoryProvider).watchMembers(orgId),
);

/// Espaces publieurs de l'utilisateur connecté.
final myOrganizationsProvider = StreamProvider<List<Organization>>((ref) {
  final orgIds = ref.watch(currentUserProfileProvider.select((p) => p.value?.orgIds ?? const []));
  return ref.watch(organizationRepositoryProvider).watchMany(orgIds);
});

/// Message lisible pour une erreur de Cloud Function.
String functionErrorMessage(Object error) {
  if (error is FirebaseFunctionsException) {
    return switch (error.code) {
      'unavailable' || 'deadline-exceeded' => 'Service indisponible. Vérifiez votre connexion.',
      'internal' => 'Une erreur est survenue. Réessayez.',
      _ => error.message ?? 'Une erreur est survenue. Réessayez.',
    };
  }
  if (error is FirebaseException) {
    return switch (error.code) {
      'unauthorized' || 'permission-denied' => "Action non autorisée.",
      'unavailable' => 'Service indisponible. Vérifiez votre connexion.',
      _ => error.message ?? 'Une erreur est survenue. Réessayez.',
    };
  }
  return 'Une erreur est survenue. Réessayez.';
}
