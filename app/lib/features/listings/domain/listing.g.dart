// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListingStats _$ListingStatsFromJson(Map<String, dynamic> json) =>
    _ListingStats(
      views: (json['views'] as num?)?.toInt() ?? 0,
      requests: (json['requests'] as num?)?.toInt() ?? 0,
      accepted: (json['accepted'] as num?)?.toInt() ?? 0,
      rejected: (json['rejected'] as num?)?.toInt() ?? 0,
      expired: (json['expired'] as num?)?.toInt() ?? 0,
      leads: (json['leads'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ListingStatsToJson(_ListingStats instance) =>
    <String, dynamic>{
      'views': instance.views,
      'requests': instance.requests,
      'accepted': instance.accepted,
      'rejected': instance.rejected,
      'expired': instance.expired,
      'leads': instance.leads,
    };

_Moderation _$ModerationFromJson(Map<String, dynamic> json) => _Moderation(
  reviewedBy: json['reviewedBy'] as String?,
  reviewedAt: const TimestampConverter().fromJson(json['reviewedAt']),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$ModerationToJson(_Moderation instance) =>
    <String, dynamic>{
      'reviewedBy': ?instance.reviewedBy,
      'reviewedAt': ?const TimestampConverter().toJson(instance.reviewedAt),
      'reason': ?instance.reason,
    };

_HotelRules _$HotelRulesFromJson(Map<String, dynamic> json) => _HotelRules(
  checkIn: json['checkIn'] as String? ?? '',
  checkOut: json['checkOut'] as String? ?? '',
  pets: json['pets'] as bool? ?? false,
  cancellationPolicy: json['cancellationPolicy'] as String? ?? '',
  other: json['other'] as String? ?? '',
);

Map<String, dynamic> _$HotelRulesToJson(_HotelRules instance) =>
    <String, dynamic>{
      'checkIn': instance.checkIn,
      'checkOut': instance.checkOut,
      'pets': instance.pets,
      'cancellationPolicy': instance.cancellationPolicy,
      'other': instance.other,
    };

_Hotel _$HotelFromJson(Map<String, dynamic> json) => _Hotel(
  id: json['id'] as String? ?? '',
  orgId: json['orgId'] as String,
  orgName: json['orgName'] as String?,
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  city: json['city'] as String? ?? '',
  district: json['district'] as String? ?? '',
  address: json['address'] as String? ?? '',
  country: json['country'] as String? ?? 'BF',
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  stars: (json['stars'] as num?)?.toInt(),
  phone: json['phone'] as String? ?? '',
  rules: json['rules'] == null
      ? const HotelRules()
      : HotelRules.fromJson(json['rules'] as Map<String, dynamic>),
  minPricePerNight: json['minPricePerNight'] == null
      ? null
      : Money.fromJson(json['minPricePerNight'] as Map<String, dynamic>),
  maxGuests: (json['maxGuests'] as num?)?.toInt() ?? 0,
  roomTypesCount: (json['roomTypesCount'] as num?)?.toInt() ?? 0,
  featured: json['featured'] as bool? ?? false,
  status:
      $enumDecodeNullable(_$ListingStatusEnumMap, json['status']) ??
      ListingStatus.draft,
  stats: json['stats'] == null
      ? const ListingStats()
      : ListingStats.fromJson(json['stats'] as Map<String, dynamic>),
  moderation: json['moderation'] == null
      ? null
      : Moderation.fromJson(json['moderation'] as Map<String, dynamic>),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$HotelToJson(_Hotel instance) => <String, dynamic>{
  'orgId': instance.orgId,
  'orgName': ?instance.orgName,
  'name': instance.name,
  'description': instance.description,
  'city': instance.city,
  'district': instance.district,
  'address': instance.address,
  'country': instance.country,
  'photos': instance.photos,
  'amenities': instance.amenities,
  'stars': ?instance.stars,
  'phone': instance.phone,
  'rules': instance.rules.toJson(),
  'status': _$ListingStatusEnumMap[instance.status]!,
};

const _$ListingStatusEnumMap = {
  ListingStatus.draft: 'draft',
  ListingStatus.pendingReview: 'pending_review',
  ListingStatus.published: 'published',
  ListingStatus.rejected: 'rejected',
  ListingStatus.underOffer: 'under_offer',
  ListingStatus.rented: 'rented',
  ListingStatus.sold: 'sold',
  ListingStatus.inactive: 'inactive',
  ListingStatus.inProgress: 'in_progress',
  ListingStatus.delivered: 'delivered',
  ListingStatus.suspended: 'suspended',
};

_RoomType _$RoomTypeFromJson(Map<String, dynamic> json) => _RoomType(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  description: json['description'] as String? ?? '',
  capacityAdults: (json['capacityAdults'] as num?)?.toInt() ?? 2,
  capacityChildren: (json['capacityChildren'] as num?)?.toInt() ?? 0,
  beds: json['beds'] as String? ?? '',
  pricePerNight: json['pricePerNight'] == null
      ? Money.zero
      : Money.fromJson(json['pricePerNight'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  active: json['active'] as bool? ?? true,
);

Map<String, dynamic> _$RoomTypeToJson(_RoomType instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'capacityAdults': instance.capacityAdults,
  'capacityChildren': instance.capacityChildren,
  'beds': instance.beds,
  'pricePerNight': instance.pricePerNight.toJson(),
  'quantity': instance.quantity,
  'photos': instance.photos,
  'amenities': instance.amenities,
  'active': instance.active,
};

_HotelOffer _$HotelOfferFromJson(Map<String, dynamic> json) => _HotelOffer(
  id: json['id'] as String? ?? '',
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
  roomTypeIds:
      (json['roomTypeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  validFrom: const TimestampConverter().fromJson(json['validFrom']),
  validTo: const TimestampConverter().fromJson(json['validTo']),
  active: json['active'] as bool? ?? true,
);

Map<String, dynamic> _$HotelOfferToJson(_HotelOffer instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'discountPercent': instance.discountPercent,
      'roomTypeIds': instance.roomTypeIds,
      'validFrom': ?const TimestampConverter().toJson(instance.validFrom),
      'validTo': ?const TimestampConverter().toJson(instance.validTo),
      'active': instance.active,
    };

_PropertyConditions _$PropertyConditionsFromJson(Map<String, dynamic> json) =>
    _PropertyConditions(
      deposit: json['deposit'] as String? ?? '',
      advance: json['advance'] as String? ?? '',
      agencyFees: json['agencyFees'] as String? ?? '',
    );

Map<String, dynamic> _$PropertyConditionsToJson(_PropertyConditions instance) =>
    <String, dynamic>{
      'deposit': instance.deposit,
      'advance': instance.advance,
      'agencyFees': instance.agencyFees,
    };

_Property _$PropertyFromJson(Map<String, dynamic> json) => _Property(
  id: json['id'] as String? ?? '',
  orgId: json['orgId'] as String,
  orgName: json['orgName'] as String?,
  orgType: json['orgType'] as String?,
  transactionType:
      $enumDecodeNullable(_$TransactionTypeEnumMap, json['transactionType']) ??
      TransactionType.rent,
  propertyType: json['propertyType'] as String? ?? '',
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  city: json['city'] as String? ?? '',
  district: json['district'] as String? ?? '',
  address: json['address'] as String? ?? '',
  country: json['country'] as String? ?? 'BF',
  price: json['price'] == null
      ? Money.zero
      : Money.fromJson(json['price'] as Map<String, dynamic>),
  rentPeriod: $enumDecodeNullable(_$RentPeriodEnumMap, json['rentPeriod']),
  surface: (json['surface'] as num?)?.toInt(),
  rooms: (json['rooms'] as num?)?.toInt(),
  bedrooms: (json['bedrooms'] as num?)?.toInt(),
  bathrooms: (json['bathrooms'] as num?)?.toInt(),
  features:
      (json['features'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  conditions: json['conditions'] == null
      ? const PropertyConditions()
      : PropertyConditions.fromJson(json['conditions'] as Map<String, dynamic>),
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  featured: json['featured'] as bool? ?? false,
  status:
      $enumDecodeNullable(_$ListingStatusEnumMap, json['status']) ??
      ListingStatus.draft,
  stats: json['stats'] == null
      ? const ListingStats()
      : ListingStats.fromJson(json['stats'] as Map<String, dynamic>),
  moderation: json['moderation'] == null
      ? null
      : Moderation.fromJson(json['moderation'] as Map<String, dynamic>),
  publishedAt: const TimestampConverter().fromJson(json['publishedAt']),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$PropertyToJson(_Property instance) => <String, dynamic>{
  'orgId': instance.orgId,
  'orgName': ?instance.orgName,
  'orgType': ?instance.orgType,
  'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
  'propertyType': instance.propertyType,
  'title': instance.title,
  'description': instance.description,
  'city': instance.city,
  'district': instance.district,
  'address': instance.address,
  'country': instance.country,
  'price': instance.price.toJson(),
  'rentPeriod': ?_$RentPeriodEnumMap[instance.rentPeriod],
  'surface': ?instance.surface,
  'rooms': ?instance.rooms,
  'bedrooms': ?instance.bedrooms,
  'bathrooms': ?instance.bathrooms,
  'features': instance.features,
  'conditions': instance.conditions.toJson(),
  'photos': instance.photos,
  'status': _$ListingStatusEnumMap[instance.status]!,
};

const _$TransactionTypeEnumMap = {
  TransactionType.rent: 'rent',
  TransactionType.sale: 'sale',
};

const _$RentPeriodEnumMap = {RentPeriod.month: 'month', RentPeriod.day: 'day'};

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  id: json['id'] as String? ?? '',
  orgId: json['orgId'] as String,
  orgName: json['orgName'] as String?,
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  city: json['city'] as String? ?? '',
  district: json['district'] as String? ?? '',
  address: json['address'] as String? ?? '',
  country: json['country'] as String? ?? 'BF',
  photos:
      (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  estimatedBudget: json['estimatedBudget'] == null
      ? null
      : Money.fromJson(json['estimatedBudget'] as Map<String, dynamic>),
  deliveryDate: json['deliveryDate'] as String? ?? '',
  priceFrom: json['priceFrom'] == null
      ? null
      : Money.fromJson(json['priceFrom'] as Map<String, dynamic>),
  unitsCount: (json['unitsCount'] as num?)?.toInt() ?? 0,
  unitsAvailable: (json['unitsAvailable'] as num?)?.toInt() ?? 0,
  featured: json['featured'] as bool? ?? false,
  status:
      $enumDecodeNullable(_$ListingStatusEnumMap, json['status']) ??
      ListingStatus.draft,
  stats: json['stats'] == null
      ? const ListingStats()
      : ListingStats.fromJson(json['stats'] as Map<String, dynamic>),
  moderation: json['moderation'] == null
      ? null
      : Moderation.fromJson(json['moderation'] as Map<String, dynamic>),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'orgId': instance.orgId,
  'orgName': ?instance.orgName,
  'title': instance.title,
  'description': instance.description,
  'city': instance.city,
  'district': instance.district,
  'address': instance.address,
  'country': instance.country,
  'photos': instance.photos,
  'estimatedBudget': ?instance.estimatedBudget?.toJson(),
  'deliveryDate': instance.deliveryDate,
  'status': _$ListingStatusEnumMap[instance.status]!,
};

_ProjectUnit _$ProjectUnitFromJson(Map<String, dynamic> json) => _ProjectUnit(
  id: json['id'] as String? ?? '',
  label: json['label'] as String? ?? '',
  propertyType: json['propertyType'] as String? ?? '',
  surface: (json['surface'] as num?)?.toInt(),
  rooms: (json['rooms'] as num?)?.toInt(),
  price: json['price'] == null
      ? Money.zero
      : Money.fromJson(json['price'] as Map<String, dynamic>),
  status:
      $enumDecodeNullable(_$UnitStatusEnumMap, json['status']) ??
      UnitStatus.available,
);

Map<String, dynamic> _$ProjectUnitToJson(_ProjectUnit instance) =>
    <String, dynamic>{
      'label': instance.label,
      'propertyType': instance.propertyType,
      'surface': ?instance.surface,
      'rooms': ?instance.rooms,
      'price': instance.price.toJson(),
      'status': _$UnitStatusEnumMap[instance.status]!,
    };

const _$UnitStatusEnumMap = {
  UnitStatus.available: 'available',
  UnitStatus.reserved: 'reserved',
  UnitStatus.sold: 'sold',
};

_Favorite _$FavoriteFromJson(Map<String, dynamic> json) => _Favorite(
  id: json['id'] as String? ?? '',
  targetType: $enumDecode(_$ListingKindEnumMap, json['targetType']),
  title: json['title'] as String? ?? '',
  photo: json['photo'] as String?,
  city: json['city'] as String?,
  price: json['price'] == null
      ? null
      : Money.fromJson(json['price'] as Map<String, dynamic>),
  addedAt: const TimestampConverter().fromJson(json['addedAt']),
);

Map<String, dynamic> _$FavoriteToJson(_Favorite instance) => <String, dynamic>{
  'targetType': _$ListingKindEnumMap[instance.targetType]!,
  'title': instance.title,
  'photo': ?instance.photo,
  'city': ?instance.city,
  'price': ?instance.price?.toJson(),
  'addedAt': ?const TimestampConverter().toJson(instance.addedAt),
};

const _$ListingKindEnumMap = {
  ListingKind.hotel: 'hotel',
  ListingKind.property: 'property',
  ListingKind.project: 'project',
};
