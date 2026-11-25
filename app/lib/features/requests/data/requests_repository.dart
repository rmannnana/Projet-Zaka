import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firestore_json.dart';
import '../../account/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/requests.dart';

/// Discussion attachée à une réservation ou à une demande de contact.
enum Thread {
  booking('bookingRequests'),
  lead('leads');

  const Thread(this.collection);

  final String collection;
}

/// Jour calendaire « AAAA-MM-JJ » attendu par la fonction createBookingRequest.
String dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class RequestsRepository {
  RequestsRepository(this._db, this._functions);

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  // ---------- Réservations ----------

  /// Envoie une demande ; renvoie son identifiant et l'heure limite de réponse de l'hôtel.
  Future<({String id, DateTime expiresAt})> createBooking({
    required String hotelId,
    required String roomTypeId,
    required DateTime checkIn,
    required DateTime checkOut,
    required int adults,
    required int children,
    required int rooms,
    required String message,
  }) async {
    final result = await _functions.httpsCallable('createBookingRequest').call<Map<String, dynamic>>({
      'hotelId': hotelId,
      'roomTypeId': roomTypeId,
      'checkIn': dayKey(checkIn),
      'checkOut': dayKey(checkOut),
      'adults': adults,
      'children': children,
      'rooms': rooms,
      'message': message.trim(),
    });
    return (
      id: result.data['requestId'] as String,
      expiresAt: DateTime.parse(result.data['expiresAt'] as String).toLocal(),
    );
  }

  Future<void> updateBooking(String id, BookingAction action, {String? note}) =>
      _functions.httpsCallable('updateBookingStatus').call<void>({
        'requestId': id,
        'action': action.key,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      });

  /// Démarre le paiement en ligne (simulé) d'une réservation acceptée ; renvoie l'identifiant du paiement.
  Future<String> startBookingPayment(String bookingId) async {
    final result = await _functions.httpsCallable('startPayment').call<Map<String, dynamic>>({
      'purpose': {'type': 'booking', 'bookingRequestId': bookingId},
    });
    return result.data['paymentId'] as String;
  }

  Stream<BookingRequest?> watchBooking(String id) => _db
      .doc('bookingRequests/$id')
      .snapshots()
      .map((s) => s.exists ? fromDoc(s, BookingRequest.fromJson) : null);

  Stream<List<BookingRequest>> watchMyBookings(String uid) => _db
      .collection('bookingRequests')
      .where('clientUid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, BookingRequest.fromJson)).toList());

  Stream<List<BookingRequest>> watchOrgBookings(String orgId) => _db
      .collection('bookingRequests')
      .where('orgId', isEqualTo: orgId)
      .orderBy('createdAt', descending: true)
      .limit(200)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, BookingRequest.fromJson)).toList());

  // ---------- Demandes de contact et de visite ----------

  Future<String> createLead({
    required String targetType,
    required String targetId,
    String? unitId,
    required LeadType type,
    required String message,
    String preferredDates = '',
    String? phone,
  }) async {
    final result = await _functions.httpsCallable('createLead').call<Map<String, dynamic>>({
      'targetType': targetType,
      'targetId': targetId,
      'unitId': ?unitId,
      'type': type.name,
      'message': message.trim(),
      'preferredDates': preferredDates.trim(),
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
    });
    return result.data['leadId'] as String;
  }

  Stream<Lead?> watchLead(String id) =>
      _db.doc('leads/$id').snapshots().map((s) => s.exists ? fromDoc(s, Lead.fromJson) : null);

  Stream<List<Lead>> watchMyLeads(String uid) => _db
      .collection('leads')
      .where('clientUid', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Lead.fromJson)).toList());

  Stream<List<Lead>> watchOrgLeads(String orgId) => _db
      .collection('leads')
      .where('orgId', isEqualTo: orgId)
      .orderBy('createdAt', descending: true)
      .limit(200)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Lead.fromJson)).toList());

  /// Suivi par le pro : prise en charge, visite programmée, clôture.
  Future<void> updateLead(String id, LeadStatus status, {DateTime? visitAt}) => _db.doc('leads/$id').update({
    'status': status.key,
    if (status == LeadStatus.visitScheduled) 'visitAt': visitAt == null ? null : Timestamp.fromDate(visitAt),
    'updatedAt': FieldValue.serverTimestamp(),
  });

  // ---------- Discussions ----------

  Stream<List<ChatMessage>> watchMessages(Thread thread, String id) => _db
      .collection(thread.collection)
      .doc(id)
      .collection('messages')
      .orderBy('createdAt')
      .limit(300)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, ChatMessage.fromJson)).toList());

  Future<void> sendMessage(Thread thread, String id, {required String fromUid, required String role, required String text}) =>
      _db.collection(thread.collection).doc(id).collection('messages').add({
        'fromUid': fromUid,
        'fromRole': role,
        'text': text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
}

final requestsRepositoryProvider = Provider<RequestsRepository>(
  (ref) => RequestsRepository(ref.watch(firestoreProvider), ref.watch(functionsProvider)),
);

final bookingProvider = StreamProvider.autoDispose.family<BookingRequest?, String>(
  (ref, id) => ref.watch(requestsRepositoryProvider).watchBooking(id),
);

final myBookingsProvider = StreamProvider.autoDispose<List<BookingRequest>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(requestsRepositoryProvider).watchMyBookings(uid);
});

final orgBookingsProvider = StreamProvider.autoDispose.family<List<BookingRequest>, String>(
  (ref, orgId) => ref.watch(requestsRepositoryProvider).watchOrgBookings(orgId),
);

final leadProvider = StreamProvider.autoDispose.family<Lead?, String>(
  (ref, id) => ref.watch(requestsRepositoryProvider).watchLead(id),
);

final myLeadsProvider = StreamProvider.autoDispose<List<Lead>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(requestsRepositoryProvider).watchMyLeads(uid);
});

final orgLeadsProvider = StreamProvider.autoDispose.family<List<Lead>, String>(
  (ref, orgId) => ref.watch(requestsRepositoryProvider).watchOrgLeads(orgId),
);

final messagesProvider = StreamProvider.autoDispose.family<List<ChatMessage>, ({Thread thread, String id})>(
  (ref, k) => ref.watch(requestsRepositoryProvider).watchMessages(k.thread, k.id),
);
