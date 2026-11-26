import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firestore_json.dart';
import '../../../core/money.dart';
import '../../account/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../organizations/data/organization_repository.dart';
import '../domain/billing.dart';

/// Paiement démarré par la fonction `startPayment`.
class PaymentCheckout {
  const PaymentCheckout({required this.paymentId, required this.amount, required this.provider});

  final String paymentId;
  final Money amount;
  final String provider;
}

/// Résultat du simulateur du back-office (fonction `previewCommission`).
class CommissionPreview {
  const CommissionPreview({this.commission, this.rateLabel, this.specific = false});

  /// null : aucune règle ne s'applique.
  final Money? commission;
  final String? rateLabel;
  final bool specific;
}

class BillingRepository {
  BillingRepository(this._db, this._functions);

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;

  // ---------- Plans ----------

  /// Plans triés par prix. [activeOnly] : ceux proposés aux pros.
  Stream<List<SubscriptionPlan>> watchPlans({bool activeOnly = true}) {
    Query<Map<String, dynamic>> q = _db.collection('subscriptionPlans');
    if (activeOnly) q = q.where('active', isEqualTo: true);
    return q.snapshots().map((s) {
      final plans = s.docs.map((d) => fromDoc(d, SubscriptionPlan.fromJson)).toList();
      plans.sort((a, b) {
        final byPrice = a.price.amount.compareTo(b.price.amount);
        return byPrice != 0 ? byPrice : a.name.compareTo(b.name);
      });
      return plans;
    });
  }

  Stream<SubscriptionPlan?> watchPlan(String planId) => _db
      .doc('subscriptionPlans/$planId')
      .snapshots()
      .map((s) => s.exists ? fromDoc(s, SubscriptionPlan.fromJson) : null);

  // ---------- Abonnements et paiements d'un compte ----------

  Stream<Subscription?> watchSubscription(String id) => _db
      .doc('subscriptions/$id')
      .snapshots()
      .map((s) => s.exists ? fromDoc(s, Subscription.fromJson) : null);

  Stream<List<Payment>> watchOrgPayments(String orgId) => _db
      .collection('payments')
      .where('payerOrgId', isEqualTo: orgId)
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots()
      .map((q) => q.docs.map((d) => fromDoc(d, Payment.fromJson)).toList());

  Stream<Payment?> watchPayment(String id) => _db
      .doc('payments/$id')
      .snapshots()
      .map((s) => s.exists ? fromDoc(s, Payment.fromJson) : null);

  Stream<List<Commission>> watchOrgCommissions(String orgId) => _db
      .collection('commissions')
      .where('orgId', isEqualTo: orgId)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => q.docs.map((d) => fromDoc(d, Commission.fromJson)).toList());

  /// Démarre le paiement d'un abonnement. Le montant est fixé par le serveur.
  Future<PaymentCheckout> startSubscriptionPayment(String orgId, String planId) async {
    final result = await _functions.httpsCallable('startPayment').call<Map<String, dynamic>>({
      'orgId': orgId,
      'purpose': {'type': 'subscription', 'planId': planId},
    });
    final data = result.data;
    return PaymentCheckout(
      paymentId: data['paymentId'] as String,
      amount: Money.fromJson(Map<String, dynamic>.from(data['amount'] as Map)),
      provider: data['provider'] as String,
    );
  }

  Future<void> confirmSimulatedPayment(String paymentId, SimulatedOutcome outcome) => _functions
      .httpsCallable('confirmSimulatedPayment')
      .call<void>({'paymentId': paymentId, 'outcome': outcome.name});

  // ---------- Back-office ----------

  /// [plan] : champs du plan ; [planId] absent pour un nouveau plan.
  Future<String> savePlan(Map<String, dynamic> plan, {String? planId}) async {
    final result = await _functions.httpsCallable('upsertSubscriptionPlan').call<Map<String, dynamic>>({
      ...plan,
      'planId': ?planId,
    });
    return result.data['planId'] as String;
  }

  Stream<List<CommissionRule>> watchRules() => _db
      .collection('commissionRules')
      .snapshots()
      .map((q) => q.docs.map((d) => fromDoc(d, CommissionRule.fromJson)).toList());

  /// [rule] : champs de la règle (dates en millisecondes) ; [ruleId] absent pour une nouvelle règle.
  Future<void> saveRule(Map<String, dynamic> rule, {String? ruleId}) => _functions
      .httpsCallable('upsertCommissionRule')
      .call<void>({...rule, 'ruleId': ?ruleId});

  Future<CommissionPreview> previewCommission({
    required CommissionScope scope,
    String? orgId,
    required int amount,
    DateTime? at,
  }) async {
    final result = await _functions.httpsCallable('previewCommission').call<Map<String, dynamic>>({
      'scope': scopeKey(scope),
      'orgId': ?orgId,
      'amount': amount,
      'at': ?at?.millisecondsSinceEpoch,
    });
    final data = result.data;
    if (data['commission'] == null) return const CommissionPreview();
    final rule = CommissionRule(
      scope: scope,
      rateType: data['rateType'] == 'fixed' ? RateType.fixed : RateType.percent,
      rate: (data['rate'] as num?)?.toDouble(),
      fixedAmount: data['fixedAmount'] == null
          ? null
          : Money.fromJson(Map<String, dynamic>.from(data['fixedAmount'] as Map)),
    );
    return CommissionPreview(
      commission: Money.fromJson(Map<String, dynamic>.from(data['commission'] as Map)),
      rateLabel: rule.rateLabel,
      specific: data['specific'] == true,
    );
  }

  Stream<List<Commission>> watchCommissions(CommissionStatus status) => _db
      .collection('commissions')
      .where('status', isEqualTo: status.name)
      .orderBy('createdAt', descending: true)
      .limit(200)
      .snapshots()
      .map((q) => q.docs.map((d) => fromDoc(d, Commission.fromJson)).toList());

  Future<void> updateCommissionStatus(List<String> ids, CommissionStatus status, {String? note}) =>
      _functions.httpsCallable('updateCommissionStatus').call<void>({
        'commissionIds': ids,
        'status': status.name,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      });

  Stream<List<Subscription>> watchActiveSubscriptions() => _db
      .collection('subscriptions')
      .where('status', isEqualTo: 'active')
      .orderBy('currentPeriodEnd')
      .limit(200)
      .snapshots()
      .map((q) => q.docs.map((d) => fromDoc(d, Subscription.fromJson)).toList());

  Stream<List<Payment>> watchRecentPayments() => _db
      .collection('payments')
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots()
      .map((q) => q.docs.map((d) => fromDoc(d, Payment.fromJson)).toList());
}

/// Valeur Firestore d'un type d'opération (ex. "hotel_booking").
String scopeKey(CommissionScope scope) => switch (scope) {
  CommissionScope.hotelBooking => 'hotel_booking',
  CommissionScope.propertyRent => 'property_rent',
  CommissionScope.propertySale => 'property_sale',
};

final billingRepositoryProvider = Provider<BillingRepository>(
  (ref) => BillingRepository(ref.watch(firestoreProvider), ref.watch(functionsProvider)),
);

/// Plans proposés aux pros.
final activePlansProvider = StreamProvider<List<SubscriptionPlan>>(
  (ref) => ref.watch(billingRepositoryProvider).watchPlans(),
);

final freePlanProvider = StreamProvider<SubscriptionPlan?>(
  (ref) => ref.watch(billingRepositoryProvider).watchPlan(freePlanId),
);

/// Abonnement en cours d'un compte (celui pointé par `organizations.subscriptionId`).
final orgSubscriptionProvider = StreamProvider.family<Subscription?, String>((ref, orgId) {
  final subscriptionId = ref.watch(
    organizationProvider(orgId).select((org) => org.value?.subscriptionId),
  );
  if (subscriptionId == null) return Stream.value(null);
  return ref.watch(billingRepositoryProvider).watchSubscription(subscriptionId);
});

final orgPaymentsProvider = StreamProvider.autoDispose.family<List<Payment>, String>(
  (ref, orgId) => ref.watch(billingRepositoryProvider).watchOrgPayments(orgId),
);

final paymentProvider = StreamProvider.autoDispose.family<Payment?, String>(
  (ref, paymentId) => ref.watch(billingRepositoryProvider).watchPayment(paymentId),
);

final orgCommissionsProvider = StreamProvider.autoDispose.family<List<Commission>, String>(
  (ref, orgId) => ref.watch(billingRepositoryProvider).watchOrgCommissions(orgId),
);

// Back-office

final allPlansProvider = StreamProvider.autoDispose<List<SubscriptionPlan>>(
  (ref) => ref.watch(billingRepositoryProvider).watchPlans(activeOnly: false),
);

final commissionRulesProvider = StreamProvider.autoDispose<List<CommissionRule>>(
  (ref) => ref.watch(billingRepositoryProvider).watchRules(),
);

final commissionsByStatusProvider = StreamProvider.autoDispose.family<List<Commission>, CommissionStatus>(
  (ref, status) => ref.watch(billingRepositoryProvider).watchCommissions(status),
);

final activeSubscriptionsProvider = StreamProvider.autoDispose<List<Subscription>>(
  (ref) => ref.watch(billingRepositoryProvider).watchActiveSubscriptions(),
);

final recentPaymentsProvider = StreamProvider.autoDispose<List<Payment>>(
  (ref) => ref.watch(billingRepositoryProvider).watchRecentPayments(),
);
