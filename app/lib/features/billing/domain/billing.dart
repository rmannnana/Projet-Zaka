import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../core/firestore_json.dart';
import '../../../core/money.dart';
import '../../organizations/domain/organization.dart';

part 'billing.freezed.dart';
part 'billing.g.dart';

/// Plan de base, appliqué d'office à tout compte sans abonnement payant en cours.
const freePlanId = 'free';

@JsonEnum(fieldRename: FieldRename.snake)
enum PlanPeriod { month, year }

@JsonEnum(fieldRename: FieldRename.snake)
enum PlanTarget {
  hotel,
  realEstate,
  all;

  /// Un plan « hôtel » ne concerne que les hôtels, un plan « immobilier » les autres publieurs.
  bool fits(OrgType type) => switch (this) {
    PlanTarget.all => true,
    PlanTarget.hotel => type == OrgType.hotel,
    PlanTarget.realEstate => type != OrgType.hotel,
  };
}

@freezed
abstract class PlanFeatures with _$PlanFeatures {
  const factory PlanFeatures({
    /// Annonces publiées en même temps ; null = illimité.
    int? maxListings,
    @Default(0) int featuredListings,
    @Default(false) bool advancedStats,
  }) = _PlanFeatures;

  factory PlanFeatures.fromJson(Map<String, dynamic> json) => _$PlanFeaturesFromJson(json);
}

/// Document `subscriptionPlans/{planId}`, aussi copié dans chaque abonnement.
@freezed
abstract class SubscriptionPlan with _$SubscriptionPlan {
  const SubscriptionPlan._();

  const factory SubscriptionPlan({
    @JsonKey(includeToJson: false) @Default('') String id,
    required String name,
    @Default('') String description,
    @Default(Money.zero) Money price,
    @Default(PlanPeriod.month) PlanPeriod period,
    @Default(PlanTarget.all) PlanTarget target,
    @Default(PlanFeatures()) PlanFeatures features,
    @Default(true) bool active,
    @TimestampConverter() DateTime? updatedAt,
  }) = _SubscriptionPlan;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanFromJson(json);

  bool get isFree => id == freePlanId;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum SubscriptionStatus { active, expired, cancelled }

/// Document `subscriptions/{id}` (écrit par les Cloud Functions).
@freezed
abstract class Subscription with _$Subscription {
  const Subscription._();

  const factory Subscription({
    @JsonKey(includeToJson: false) @Default('') String id,
    required String orgId,
    String? orgName,
    required String planId,
    required SubscriptionPlan planSnapshot,
    @Default(SubscriptionStatus.active) SubscriptionStatus status,
    @TimestampConverter() DateTime? currentPeriodStart,
    @TimestampConverter() DateTime? currentPeriodEnd,
    String? lastPaymentId,
    @TimestampConverter() DateTime? createdAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);

  bool isRunningAt(DateTime now) =>
      status == SubscriptionStatus.active &&
      currentPeriodEnd != null &&
      currentPeriodEnd!.isAfter(now);
}

/// Plan en vigueur pour un compte : l'abonnement payé tant qu'il court, sinon le plan Gratuit.
SubscriptionPlan? effectivePlan(Subscription? subscription, SubscriptionPlan? freePlan, DateTime now) =>
    subscription != null && subscription.isRunningAt(now) ? subscription.planSnapshot : freePlan;

@JsonEnum(fieldRename: FieldRename.snake)
enum PaymentStatus { pending, succeeded, failed, cancelled }

/// Issue choisie dans l'écran de paiement simulé.
enum SimulatedOutcome { success, failure, cancelled }

@freezed
abstract class PaymentPurpose with _$PaymentPurpose {
  const factory PaymentPurpose({
    required String type,
    String? planId,
    String? subscriptionId,
  }) = _PaymentPurpose;

  factory PaymentPurpose.fromJson(Map<String, dynamic> json) => _$PaymentPurposeFromJson(json);
}

/// Document `payments/{id}` (écrit par les Cloud Functions).
@freezed
abstract class Payment with _$Payment {
  const Payment._();

  const factory Payment({
    @JsonKey(includeToJson: false) @Default('') String id,
    @Default('simulation') String provider,
    required PaymentPurpose purpose,
    required String payerUid,
    String? payerOrgId,
    String? orgName,
    required Money amount,
    @Default('') String description,
    @Default(PaymentStatus.pending) PaymentStatus status,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? completedAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  bool get isSimulated => provider == 'simulation';
}

@JsonEnum(fieldRename: FieldRename.snake)
enum CommissionScope { hotelBooking, propertyRent, propertySale }

@JsonEnum(fieldRename: FieldRename.snake)
enum RateType { percent, fixed }

/// Situation d'une règle à une date donnée.
enum RuleState { inForce, scheduled, ended, disabled }

final _rateFormat = NumberFormat('#,##0.##', 'fr');

/// Document `commissionRules/{id}` (lu par l'équipe ZAKA, écrit par les Cloud Functions).
@freezed
abstract class CommissionRule with _$CommissionRule {
  const CommissionRule._();

  const factory CommissionRule({
    @JsonKey(includeToJson: false) @Default('') String id,
    required CommissionScope scope,
    @Default(RateType.percent) RateType rateType,
    double? rate,
    Money? fixedAmount,

    /// null : règle par défaut ; sinon règle propre à un partenaire.
    String? orgId,
    String? orgName,
    @TimestampConverter() DateTime? validFrom,
    @TimestampConverter() DateTime? validTo,
    @Default(true) bool active,
    String? updatedBy,
    @TimestampConverter() DateTime? updatedAt,
  }) = _CommissionRule;

  factory CommissionRule.fromJson(Map<String, dynamic> json) => _$CommissionRuleFromJson(json);

  RuleState stateAt(DateTime now) {
    if (!active) return RuleState.disabled;
    if (validFrom != null && now.isBefore(validFrom!)) return RuleState.scheduled;
    if (validTo != null && !now.isBefore(validTo!)) return RuleState.ended;
    return RuleState.inForce;
  }

  /// « 7,5 % » ou « 2 000 FCFA ».
  String get rateLabel => rateType == RateType.percent
      ? '${_rateFormat.format(rate ?? 0)} %'
      : (fixedAmount ?? Money.zero).format();
}

@JsonEnum(fieldRename: FieldRename.snake)
enum CommissionStatus {
  due,
  invoiced,
  paid,
  waived;

  /// Mêmes transitions que la fonction `updateCommissionStatus`.
  bool canMoveTo(CommissionStatus to) => switch (this) {
    CommissionStatus.due => to != CommissionStatus.due,
    CommissionStatus.invoiced => to != CommissionStatus.invoiced,
    CommissionStatus.paid || CommissionStatus.waived => false,
  };

  /// Reste à régler par le partenaire.
  bool get isOutstanding => this == CommissionStatus.due || this == CommissionStatus.invoiced;
}

@freezed
abstract class CommissionSource with _$CommissionSource {
  const factory CommissionSource({required String type, required String id}) = _CommissionSource;

  factory CommissionSource.fromJson(Map<String, dynamic> json) => _$CommissionSourceFromJson(json);
}

/// Document `commissions/{id}` : registre des commissions dues (écrit par les Cloud Functions).
@freezed
abstract class Commission with _$Commission {
  const factory Commission({
    @JsonKey(includeToJson: false) @Default('') String id,
    required String orgId,
    String? orgName,
    CommissionSource? source,
    @Default(Money.zero) Money baseAmount,
    required Money amount,
    @Default(CommissionStatus.due) CommissionStatus status,
    String? statusNote,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? statusChangedAt,
  }) = _Commission;

  factory Commission.fromJson(Map<String, dynamic> json) => _$CommissionFromJson(json);
}

/// Somme des montants d'une liste de commissions.
Money totalOf(Iterable<Commission> commissions) =>
    commissions.fold(Money.zero, (sum, c) => sum + c.amount);
