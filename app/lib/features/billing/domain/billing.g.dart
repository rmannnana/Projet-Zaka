// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanFeatures _$PlanFeaturesFromJson(Map<String, dynamic> json) =>
    _PlanFeatures(
      maxListings: (json['maxListings'] as num?)?.toInt(),
      featuredListings: (json['featuredListings'] as num?)?.toInt() ?? 0,
      advancedStats: json['advancedStats'] as bool? ?? false,
    );

Map<String, dynamic> _$PlanFeaturesToJson(_PlanFeatures instance) =>
    <String, dynamic>{
      'maxListings': ?instance.maxListings,
      'featuredListings': instance.featuredListings,
      'advancedStats': instance.advancedStats,
    };

_SubscriptionPlan _$SubscriptionPlanFromJson(Map<String, dynamic> json) =>
    _SubscriptionPlan(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: json['price'] == null
          ? Money.zero
          : Money.fromJson(json['price'] as Map<String, dynamic>),
      period:
          $enumDecodeNullable(_$PlanPeriodEnumMap, json['period']) ??
          PlanPeriod.month,
      target:
          $enumDecodeNullable(_$PlanTargetEnumMap, json['target']) ??
          PlanTarget.all,
      features: json['features'] == null
          ? const PlanFeatures()
          : PlanFeatures.fromJson(json['features'] as Map<String, dynamic>),
      active: json['active'] as bool? ?? true,
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$SubscriptionPlanToJson(_SubscriptionPlan instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'price': instance.price.toJson(),
      'period': _$PlanPeriodEnumMap[instance.period]!,
      'target': _$PlanTargetEnumMap[instance.target]!,
      'features': instance.features.toJson(),
      'active': instance.active,
      'updatedAt': ?const TimestampConverter().toJson(instance.updatedAt),
    };

const _$PlanPeriodEnumMap = {
  PlanPeriod.month: 'month',
  PlanPeriod.year: 'year',
};

const _$PlanTargetEnumMap = {
  PlanTarget.hotel: 'hotel',
  PlanTarget.realEstate: 'real_estate',
  PlanTarget.all: 'all',
};

_Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    _Subscription(
      id: json['id'] as String? ?? '',
      orgId: json['orgId'] as String,
      orgName: json['orgName'] as String?,
      planId: json['planId'] as String,
      planSnapshot: SubscriptionPlan.fromJson(
        json['planSnapshot'] as Map<String, dynamic>,
      ),
      status:
          $enumDecodeNullable(_$SubscriptionStatusEnumMap, json['status']) ??
          SubscriptionStatus.active,
      currentPeriodStart: const TimestampConverter().fromJson(
        json['currentPeriodStart'],
      ),
      currentPeriodEnd: const TimestampConverter().fromJson(
        json['currentPeriodEnd'],
      ),
      lastPaymentId: json['lastPaymentId'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$SubscriptionToJson(_Subscription instance) =>
    <String, dynamic>{
      'orgId': instance.orgId,
      'orgName': ?instance.orgName,
      'planId': instance.planId,
      'planSnapshot': instance.planSnapshot.toJson(),
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'currentPeriodStart': ?const TimestampConverter().toJson(
        instance.currentPeriodStart,
      ),
      'currentPeriodEnd': ?const TimestampConverter().toJson(
        instance.currentPeriodEnd,
      ),
      'lastPaymentId': ?instance.lastPaymentId,
      'createdAt': ?const TimestampConverter().toJson(instance.createdAt),
    };

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.expired: 'expired',
  SubscriptionStatus.cancelled: 'cancelled',
};

_PaymentPurpose _$PaymentPurposeFromJson(Map<String, dynamic> json) =>
    _PaymentPurpose(
      type: json['type'] as String,
      planId: json['planId'] as String?,
      subscriptionId: json['subscriptionId'] as String?,
    );

Map<String, dynamic> _$PaymentPurposeToJson(_PaymentPurpose instance) =>
    <String, dynamic>{
      'type': instance.type,
      'planId': ?instance.planId,
      'subscriptionId': ?instance.subscriptionId,
    };

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String? ?? '',
  provider: json['provider'] as String? ?? 'simulation',
  purpose: PaymentPurpose.fromJson(json['purpose'] as Map<String, dynamic>),
  payerUid: json['payerUid'] as String,
  payerOrgId: json['payerOrgId'] as String?,
  orgName: json['orgName'] as String?,
  amount: Money.fromJson(json['amount'] as Map<String, dynamic>),
  description: json['description'] as String? ?? '',
  status:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['status']) ??
      PaymentStatus.pending,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  completedAt: const TimestampConverter().fromJson(json['completedAt']),
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'provider': instance.provider,
  'purpose': instance.purpose.toJson(),
  'payerUid': instance.payerUid,
  'payerOrgId': ?instance.payerOrgId,
  'orgName': ?instance.orgName,
  'amount': instance.amount.toJson(),
  'description': instance.description,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'createdAt': ?const TimestampConverter().toJson(instance.createdAt),
  'completedAt': ?const TimestampConverter().toJson(instance.completedAt),
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.succeeded: 'succeeded',
  PaymentStatus.failed: 'failed',
  PaymentStatus.cancelled: 'cancelled',
};

_CommissionRule _$CommissionRuleFromJson(Map<String, dynamic> json) =>
    _CommissionRule(
      id: json['id'] as String? ?? '',
      scope: $enumDecode(_$CommissionScopeEnumMap, json['scope']),
      rateType:
          $enumDecodeNullable(_$RateTypeEnumMap, json['rateType']) ??
          RateType.percent,
      rate: (json['rate'] as num?)?.toDouble(),
      fixedAmount: json['fixedAmount'] == null
          ? null
          : Money.fromJson(json['fixedAmount'] as Map<String, dynamic>),
      orgId: json['orgId'] as String?,
      orgName: json['orgName'] as String?,
      validFrom: const TimestampConverter().fromJson(json['validFrom']),
      validTo: const TimestampConverter().fromJson(json['validTo']),
      active: json['active'] as bool? ?? true,
      updatedBy: json['updatedBy'] as String?,
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$CommissionRuleToJson(_CommissionRule instance) =>
    <String, dynamic>{
      'scope': _$CommissionScopeEnumMap[instance.scope]!,
      'rateType': _$RateTypeEnumMap[instance.rateType]!,
      'rate': ?instance.rate,
      'fixedAmount': ?instance.fixedAmount?.toJson(),
      'orgId': ?instance.orgId,
      'orgName': ?instance.orgName,
      'validFrom': ?const TimestampConverter().toJson(instance.validFrom),
      'validTo': ?const TimestampConverter().toJson(instance.validTo),
      'active': instance.active,
      'updatedBy': ?instance.updatedBy,
      'updatedAt': ?const TimestampConverter().toJson(instance.updatedAt),
    };

const _$CommissionScopeEnumMap = {
  CommissionScope.hotelBooking: 'hotel_booking',
  CommissionScope.propertyRent: 'property_rent',
  CommissionScope.propertySale: 'property_sale',
};

const _$RateTypeEnumMap = {
  RateType.percent: 'percent',
  RateType.fixed: 'fixed',
};

_CommissionSource _$CommissionSourceFromJson(Map<String, dynamic> json) =>
    _CommissionSource(type: json['type'] as String, id: json['id'] as String);

Map<String, dynamic> _$CommissionSourceToJson(_CommissionSource instance) =>
    <String, dynamic>{'type': instance.type, 'id': instance.id};

_Commission _$CommissionFromJson(Map<String, dynamic> json) => _Commission(
  id: json['id'] as String? ?? '',
  orgId: json['orgId'] as String,
  orgName: json['orgName'] as String?,
  source: json['source'] == null
      ? null
      : CommissionSource.fromJson(json['source'] as Map<String, dynamic>),
  baseAmount: json['baseAmount'] == null
      ? Money.zero
      : Money.fromJson(json['baseAmount'] as Map<String, dynamic>),
  amount: Money.fromJson(json['amount'] as Map<String, dynamic>),
  status:
      $enumDecodeNullable(_$CommissionStatusEnumMap, json['status']) ??
      CommissionStatus.due,
  statusNote: json['statusNote'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  statusChangedAt: const TimestampConverter().fromJson(json['statusChangedAt']),
);

Map<String, dynamic> _$CommissionToJson(_Commission instance) =>
    <String, dynamic>{
      'orgId': instance.orgId,
      'orgName': ?instance.orgName,
      'source': ?instance.source?.toJson(),
      'baseAmount': instance.baseAmount.toJson(),
      'amount': instance.amount.toJson(),
      'status': _$CommissionStatusEnumMap[instance.status]!,
      'statusNote': ?instance.statusNote,
      'createdAt': ?const TimestampConverter().toJson(instance.createdAt),
      'statusChangedAt': ?const TimestampConverter().toJson(
        instance.statusChangedAt,
      ),
    };

const _$CommissionStatusEnumMap = {
  CommissionStatus.due: 'due',
  CommissionStatus.invoiced: 'invoiced',
  CommissionStatus.paid: 'paid',
  CommissionStatus.waived: 'waived',
};
