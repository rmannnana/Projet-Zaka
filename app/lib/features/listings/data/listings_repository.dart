import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firestore_json.dart';
import '../../account/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../organizations/data/organization_repository.dart';
import '../../organizations/domain/organization.dart';
import '../domain/listing.dart';

const maxPhotoBytes = 8 * 1024 * 1024;
const maxPhotos = 12;

/// Critères de recherche d'hôtels.
class HotelQuery {
  const HotelQuery({this.city, this.maxPrice, this.amenities = const {}, this.guests = 1});

  final String? city;
  final int? maxPrice;
  final Set<String> amenities;
  final int guests;

  @override
  bool operator ==(Object other) =>
      other is HotelQuery &&
      other.city == city &&
      other.maxPrice == maxPrice &&
      other.guests == guests &&
      other.amenities.length == amenities.length &&
      other.amenities.containsAll(amenities);

  @override
  int get hashCode => Object.hash(city, maxPrice, guests, Object.hashAllUnordered(amenities));
}

/// Critères de recherche de biens.
class PropertyQuery {
  const PropertyQuery({
    this.transactionType = TransactionType.rent,
    this.city,
    this.propertyType,
    this.maxPrice,
    this.minRooms,
    this.furnished = false,
  });

  final TransactionType transactionType;
  final String? city;
  final String? propertyType;
  final int? maxPrice;
  final int? minRooms;
  final bool furnished;

  PropertyQuery copyWith({
    TransactionType? transactionType,
    String? Function()? city,
    String? Function()? propertyType,
    int? Function()? maxPrice,
    int? Function()? minRooms,
    bool? furnished,
  }) => PropertyQuery(
    transactionType: transactionType ?? this.transactionType,
    city: city == null ? this.city : city(),
    propertyType: propertyType == null ? this.propertyType : propertyType(),
    maxPrice: maxPrice == null ? this.maxPrice : maxPrice(),
    minRooms: minRooms == null ? this.minRooms : minRooms(),
    furnished: furnished ?? this.furnished,
  );

  @override
  bool operator ==(Object other) =>
      other is PropertyQuery &&
      other.transactionType == transactionType &&
      other.city == city &&
      other.propertyType == propertyType &&
      other.maxPrice == maxPrice &&
      other.minRooms == minRooms &&
      other.furnished == furnished;

  @override
  int get hashCode => Object.hash(transactionType, city, propertyType, maxPrice, minRooms, furnished);
}

class ListingsRepository {
  ListingsRepository(this._db, this._functions, this._storage);

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> _col(ListingKind kind) => _db.collection(kind.collection);

  // ---------- Recherche (visiteurs) ----------

  /// Hôtels publiés, du moins cher au plus cher ; équipements et capacité filtrés ici.
  Stream<List<Hotel>> searchHotels(HotelQuery q) {
    Query<Map<String, dynamic>> query = _col(ListingKind.hotel).where('status', isEqualTo: 'published');
    if (q.city != null) query = query.where('city', isEqualTo: q.city);
    if (q.maxPrice != null) query = query.where('minPricePerNight.amount', isLessThanOrEqualTo: q.maxPrice);
    return query.orderBy('minPricePerNight.amount').limit(60).snapshots().map((s) {
      final hotels = s.docs.map((d) => fromDoc(d, Hotel.fromJson)).where((h) {
        return q.amenities.every(h.amenities.contains) && (h.maxGuests == 0 || q.guests <= h.maxGuests * 4);
      }).toList();
      hotels.sort((a, b) => (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0));
      return hotels;
    });
  }

  Stream<List<Property>> searchProperties(PropertyQuery q) {
    Query<Map<String, dynamic>> query = _col(ListingKind.property)
        .where('status', isEqualTo: 'published')
        .where('transactionType', isEqualTo: q.transactionType.name);
    if (q.propertyType != null) query = query.where('propertyType', isEqualTo: q.propertyType);
    if (q.city != null) query = query.where('city', isEqualTo: q.city);
    if (q.maxPrice != null) query = query.where('price.amount', isLessThanOrEqualTo: q.maxPrice);
    return query.orderBy('price.amount').limit(60).snapshots().map((s) {
      final items = s.docs.map((d) => fromDoc(d, Property.fromJson)).where((p) {
        if (q.minRooms != null && (p.rooms ?? 0) < q.minRooms!) return false;
        if (q.furnished && !p.features.contains('furnished')) return false;
        return true;
      }).toList();
      items.sort((a, b) => (b.featured ? 1 : 0).compareTo(a.featured ? 1 : 0));
      return items;
    });
  }

  Stream<List<Project>> searchProjects({String? city}) {
    Query<Map<String, dynamic>> query = _col(ListingKind.project)
        .where('status', whereIn: ['published', 'in_progress', 'delivered']);
    if (city != null) query = query.where('city', isEqualTo: city);
    return query
        .orderBy('createdAt', descending: true)
        .limit(40)
        .snapshots()
        .map((s) => s.docs.map((d) => fromDoc(d, Project.fromJson)).toList());
  }

  Stream<List<Hotel>> featuredHotels() => _col(ListingKind.hotel)
      .where('status', isEqualTo: 'published')
      .where('featured', isEqualTo: true)
      .limit(10)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Hotel.fromJson)).toList());

  Stream<List<Hotel>> cheapestHotels() => _col(ListingKind.hotel)
      .where('status', isEqualTo: 'published')
      .orderBy('minPricePerNight.amount')
      .limit(10)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Hotel.fromJson)).toList());

  Stream<List<Property>> latestProperties() => _col(ListingKind.property)
      .where('status', isEqualTo: 'published')
      .orderBy('createdAt', descending: true)
      .limit(10)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Property.fromJson)).toList());

  Stream<List<Property>> featuredProperties() => _col(ListingKind.property)
      .where('status', isEqualTo: 'published')
      .where('featured', isEqualTo: true)
      .limit(10)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Property.fromJson)).toList());

  // ---------- Fiches ----------

  Stream<Hotel?> watchHotel(String id) => _col(ListingKind.hotel)
      .doc(id)
      .snapshots()
      .map((s) => s.exists ? fromDoc(s, Hotel.fromJson) : null);

  Stream<List<RoomType>> watchRoomTypes(String hotelId) => _col(ListingKind.hotel)
      .doc(hotelId)
      .collection('roomTypes')
      .snapshots()
      .map((s) {
        final rooms = s.docs.map((d) => fromDoc(d, RoomType.fromJson)).toList();
        rooms.sort((a, b) => a.pricePerNight.amount.compareTo(b.pricePerNight.amount));
        return rooms;
      });

  Stream<List<HotelOffer>> watchOffers(String hotelId) => _col(ListingKind.hotel)
      .doc(hotelId)
      .collection('offers')
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, HotelOffer.fromJson)).toList());

  /// Disponibilités déclarées d'un type de chambre pour un mois « AAAA-MM » : jour → chambres libres.
  Stream<Map<String, int>> watchAvailability(String hotelId, String roomTypeId, String month) => _col(
    ListingKind.hotel,
  ).doc(hotelId).collection('roomTypes').doc(roomTypeId).collection('availability').doc(month).snapshots().map(
    (s) => {
      for (final e in ((s.data()?['days'] as Map?) ?? const {}).entries) '${e.key}': (e.value as num).toInt(),
    },
  );

  Stream<Property?> watchProperty(String id) => _col(ListingKind.property)
      .doc(id)
      .snapshots()
      .map((s) => s.exists ? fromDoc(s, Property.fromJson) : null);

  Stream<Project?> watchProject(String id) => _col(ListingKind.project)
      .doc(id)
      .snapshots()
      .map((s) => s.exists ? fromDoc(s, Project.fromJson) : null);

  Stream<List<ProjectUnit>> watchUnits(String projectId) => _col(ListingKind.project)
      .doc(projectId)
      .collection('units')
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, ProjectUnit.fromJson)).toList()
        ..sort((a, b) => a.label.compareTo(b.label)));

  /// Compteur de vues (statistiques des pros) ; sans effet si l'annonce n'est pas publique.
  Future<void> recordView(ListingKind kind, String id) async {
    try {
      await _functions.httpsCallable('recordView').call<void>({'kind': kind.name, 'id': id});
    } catch (_) {
      // Une vue non comptée n'empêche pas la consultation.
    }
  }

  // ---------- Espace pro ----------

  Stream<List<Hotel>> watchOrgHotels(String orgId) => _col(ListingKind.hotel)
      .where('orgId', isEqualTo: orgId)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Hotel.fromJson)).toList());

  Stream<List<Property>> watchOrgProperties(String orgId) => _col(ListingKind.property)
      .where('orgId', isEqualTo: orgId)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Property.fromJson)).toList()
        ..sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0))));

  Stream<List<Project>> watchOrgProjects(String orgId) => _col(ListingKind.project)
      .where('orgId', isEqualTo: orgId)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Project.fromJson)).toList());

  /// Nouvelle annonce en brouillon ; renvoie son identifiant.
  Future<String> createDraft(ListingKind kind, Organization org, Map<String, dynamic> fields) async {
    final ref = await _col(kind).add({
      ...fields,
      'orgId': org.id,
      'orgName': org.name,
      if (kind == ListingKind.property) 'orgType': org.type == OrgType.individualOwner ? 'individual_owner' : org.type.name,
      'country': org.contact.country,
      'status': 'draft',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  /// Enregistre le contenu. Particulier : une annonce publiée repasse en validation.
  Future<void> update(ListingKind kind, String id, Map<String, dynamic> fields, {ListingStatus? status}) =>
      _col(kind).doc(id).update({
        ...fields,
        'status': ?status?.key,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  /// Retire une annonce (brouillon, hors ligne) ou change son état (loué, vendu, sous offre, travaux, livré).
  Future<void> setStatus(ListingKind kind, String id, ListingStatus status) =>
      _col(kind).doc(id).update({'status': status.key, 'updatedAt': FieldValue.serverTimestamp()});

  /// Mise en ligne (pro) ou envoi à la validation (particulier) ; renvoie le nouveau statut.
  Future<ListingStatus> publish(ListingKind kind, String id) async {
    final result = await _functions.httpsCallable('publishListing').call<Map<String, dynamic>>({
      'kind': kind.name,
      'id': id,
    });
    return result.data['status'] == 'pending_review' ? ListingStatus.pendingReview : ListingStatus.published;
  }

  Future<void> setFeatured(ListingKind kind, String id, bool featured) =>
      _functions.httpsCallable('setFeatured').call<void>({'kind': kind.name, 'id': id, 'featured': featured});

  Future<String> saveRoomType(String hotelId, Map<String, dynamic> fields, {String? id}) async {
    final rooms = _col(ListingKind.hotel).doc(hotelId).collection('roomTypes');
    if (id == null) return (await rooms.add(fields)).id;
    await rooms.doc(id).set(fields);
    return id;
  }

  Future<void> deleteRoomType(String hotelId, String id) =>
      _col(ListingKind.hotel).doc(hotelId).collection('roomTypes').doc(id).delete();

  Future<void> saveOffer(String hotelId, Map<String, dynamic> fields, {String? id}) {
    final offers = _col(ListingKind.hotel).doc(hotelId).collection('offers');
    return id == null ? offers.add(fields) : offers.doc(id).set(fields);
  }

  Future<void> deleteOffer(String hotelId, String id) =>
      _col(ListingKind.hotel).doc(hotelId).collection('offers').doc(id).delete();

  /// Disponibilités d'un mois ; un jour retiré de la liste redevient « toutes les chambres ».
  Future<void> saveAvailability(String hotelId, String roomTypeId, String month, Map<String, int> days) =>
      _col(ListingKind.hotel)
          .doc(hotelId)
          .collection('roomTypes')
          .doc(roomTypeId)
          .collection('availability')
          .doc(month)
          .set({'days': days, 'updatedAt': FieldValue.serverTimestamp()});

  Future<void> saveUnit(String projectId, Map<String, dynamic> fields, {String? id}) {
    final units = _col(ListingKind.project).doc(projectId).collection('units');
    return id == null ? units.add(fields) : units.doc(id).set(fields);
  }

  Future<void> deleteUnit(String projectId, String id) =>
      _col(ListingKind.project).doc(projectId).collection('units').doc(id).delete();

  // ---------- Photos ----------

  /// Choisit des images et les envoie dans l'espace public du compte ; renvoie leurs URL.
  Future<List<String>> pickAndUploadPhotos(String orgId, String listingId, {int max = maxPhotos}) async {
    // Compression des images là où la plateforme le permet (Android) : connexions mobiles lentes.
    final files = await FilePicker.pickFiles(type: FileType.image, compressionQuality: 75);
    final urls = <String>[];
    for (final file in files.take(max)) {
      final bytes = await file.readAsBytes();
      if (bytes.length > maxPhotoBytes) {
        throw PhotoTooLargeException(file.name);
      }
      final ext = (file.extension ?? 'jpg').toLowerCase();
      final path = 'public/orgs/$orgId/listings/$listingId/${DateTime.now().microsecondsSinceEpoch}.$ext';
      final ref = _storage.ref(path);
      await ref.putData(bytes, SettableMetadata(contentType: contentTypeFor(ext), cacheControl: 'public,max-age=31536000'));
      urls.add(await ref.getDownloadURL());
    }
    return urls;
  }

  Future<void> deletePhoto(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {
      // Déjà supprimée : rien à faire.
    }
  }
}

class PhotoTooLargeException implements Exception {
  PhotoTooLargeException(this.fileName);

  final String fileName;
}

final listingsRepositoryProvider = Provider<ListingsRepository>(
  (ref) => ListingsRepository(
    ref.watch(firestoreProvider),
    ref.watch(functionsProvider),
    ref.watch(storageProvider),
  ),
);

final hotelSearchProvider = StreamProvider.autoDispose.family<List<Hotel>, HotelQuery>(
  (ref, q) => ref.watch(listingsRepositoryProvider).searchHotels(q),
);

final propertySearchProvider = StreamProvider.autoDispose.family<List<Property>, PropertyQuery>(
  (ref, q) => ref.watch(listingsRepositoryProvider).searchProperties(q),
);

final projectSearchProvider = StreamProvider.autoDispose.family<List<Project>, String?>(
  (ref, city) => ref.watch(listingsRepositoryProvider).searchProjects(city: city),
);

final featuredHotelsProvider = StreamProvider.autoDispose<List<Hotel>>((ref) {
  final repo = ref.watch(listingsRepositoryProvider);
  return repo.featuredHotels().asyncExpand(
    (featured) => featured.isNotEmpty ? Stream.value(featured) : repo.cheapestHotels(),
  );
});

final featuredPropertiesProvider = StreamProvider.autoDispose<List<Property>>((ref) {
  final repo = ref.watch(listingsRepositoryProvider);
  return repo.featuredProperties().asyncExpand(
    (featured) => featured.isNotEmpty ? Stream.value(featured) : repo.latestProperties(),
  );
});

final hotelProvider = StreamProvider.autoDispose.family<Hotel?, String>(
  (ref, id) => ref.watch(listingsRepositoryProvider).watchHotel(id),
);

final roomTypesProvider = StreamProvider.autoDispose.family<List<RoomType>, String>(
  (ref, hotelId) => ref.watch(listingsRepositoryProvider).watchRoomTypes(hotelId),
);

final offersProvider = StreamProvider.autoDispose.family<List<HotelOffer>, String>(
  (ref, hotelId) => ref.watch(listingsRepositoryProvider).watchOffers(hotelId),
);

final availabilityProvider = StreamProvider.autoDispose
    .family<Map<String, int>, ({String hotelId, String roomTypeId, String month})>(
      (ref, k) => ref.watch(listingsRepositoryProvider).watchAvailability(k.hotelId, k.roomTypeId, k.month),
    );

final propertyProvider = StreamProvider.autoDispose.family<Property?, String>(
  (ref, id) => ref.watch(listingsRepositoryProvider).watchProperty(id),
);

final projectProvider = StreamProvider.autoDispose.family<Project?, String>(
  (ref, id) => ref.watch(listingsRepositoryProvider).watchProject(id),
);

final unitsProvider = StreamProvider.autoDispose.family<List<ProjectUnit>, String>(
  (ref, projectId) => ref.watch(listingsRepositoryProvider).watchUnits(projectId),
);

final orgHotelsProvider = StreamProvider.autoDispose.family<List<Hotel>, String>(
  (ref, orgId) => ref.watch(listingsRepositoryProvider).watchOrgHotels(orgId),
);

final orgPropertiesProvider = StreamProvider.autoDispose.family<List<Property>, String>(
  (ref, orgId) => ref.watch(listingsRepositoryProvider).watchOrgProperties(orgId),
);

final orgProjectsProvider = StreamProvider.autoDispose.family<List<Project>, String>(
  (ref, orgId) => ref.watch(listingsRepositoryProvider).watchOrgProjects(orgId),
);

// ---------- Favoris ----------

class FavoritesRepository {
  FavoritesRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _favorites(String uid) =>
      _db.collection('users').doc(uid).collection('favorites');

  Stream<List<Favorite>> watch(String uid) => _favorites(uid)
      .orderBy('addedAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Favorite.fromJson)).toList());

  Future<void> add(String uid, String targetId, Favorite favorite) => _favorites(uid).doc(targetId).set({
    'targetType': favorite.targetType.name,
    'title': favorite.title,
    'photo': favorite.photo,
    'city': favorite.city,
    'price': favorite.price?.toJson(),
    'addedAt': FieldValue.serverTimestamp(),
  });

  Future<void> remove(String uid, String targetId) => _favorites(uid).doc(targetId).delete();
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(ref.watch(firestoreProvider)),
);

final favoritesProvider = StreamProvider<List<Favorite>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(favoritesRepositoryProvider).watch(uid);
});

final favoriteIdsProvider = Provider<Set<String>>(
  (ref) => {for (final f in ref.watch(favoritesProvider).value ?? const <Favorite>[]) f.id},
);
