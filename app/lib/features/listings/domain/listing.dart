import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore_json.dart';
import '../../../core/money.dart';

part 'listing.freezed.dart';
part 'listing.g.dart';

/// Type d'annonce, avec sa collection Firestore et son nom pour les Cloud Functions.
enum ListingKind {
  hotel('hotels', 'hotel'),
  property('properties', 'bien'),
  project('projects', 'programme');

  const ListingKind(this.collection, this.slug);

  final String collection;

  /// Segment d'URL : /pro/{orgId}/annonces/{slug}/{id}.
  final String slug;

  static ListingKind fromSlug(String slug) => values.firstWhere((k) => k.slug == slug);
}

/// Statuts d'annonce (les hôtels et programmes en utilisent une partie).
@JsonEnum(fieldRename: FieldRename.snake)
enum ListingStatus {
  draft,
  pendingReview,
  published,
  rejected,
  underOffer,
  rented,
  sold,
  inactive,
  inProgress,
  delivered,
  suspended;

  /// Visible des visiteurs.
  bool get isPublic => const [published, underOffer, inProgress, delivered].contains(this);

  /// Peut être (re)mise en ligne via publishListing.
  bool get canPublish => const [draft, inactive, rejected, rented, sold].contains(this);

  String get key => switch (this) {
    pendingReview => 'pending_review',
    underOffer => 'under_offer',
    inProgress => 'in_progress',
    _ => name,
  };
}

@freezed
abstract class ListingStats with _$ListingStats {
  const factory ListingStats({
    @Default(0) int views,
    @Default(0) int requests,
    @Default(0) int accepted,
    @Default(0) int rejected,
    @Default(0) int expired,
    @Default(0) int leads,
  }) = _ListingStats;

  factory ListingStats.fromJson(Map<String, dynamic> json) => _$ListingStatsFromJson(json);
}

@freezed
abstract class Moderation with _$Moderation {
  const factory Moderation({
    String? reviewedBy,
    @TimestampConverter() DateTime? reviewedAt,
    String? reason,
  }) = _Moderation;

  factory Moderation.fromJson(Map<String, dynamic> json) => _$ModerationFromJson(json);
}

@freezed
abstract class HotelRules with _$HotelRules {
  const factory HotelRules({
    @Default('') String checkIn,
    @Default('') String checkOut,
    @Default(false) bool pets,
    @Default('') String cancellationPolicy,
    @Default('') String other,
  }) = _HotelRules;

  factory HotelRules.fromJson(Map<String, dynamic> json) => _$HotelRulesFromJson(json);
}

/// Document `hotels/{hotelId}`.
@freezed
abstract class Hotel with _$Hotel {
  const Hotel._();

  const factory Hotel({
    @JsonKey(includeToJson: false) @Default('') String id,
    required String orgId,
    String? orgName,
    @Default('') String name,
    @Default('') String description,
    @Default('') String city,
    @Default('') String district,
    @Default('') String address,
    @Default('BF') String country,
    @Default([]) List<String> photos,
    @Default([]) List<String> amenities,
    int? stars,
    @Default('') String phone,
    @Default(HotelRules()) HotelRules rules,
    @JsonKey(includeToJson: false) Money? minPricePerNight,
    @JsonKey(includeToJson: false) @Default(0) int maxGuests,
    @JsonKey(includeToJson: false) @Default(0) int roomTypesCount,
    @JsonKey(includeToJson: false) @Default(false) bool featured,
    @Default(ListingStatus.draft) ListingStatus status,
    @JsonKey(includeToJson: false) @Default(ListingStats()) ListingStats stats,
    @JsonKey(includeToJson: false) Moderation? moderation,
    @JsonKey(includeToJson: false) @TimestampConverter() DateTime? createdAt,
    @JsonKey(includeToJson: false) @TimestampConverter() DateTime? updatedAt,
  }) = _Hotel;

  factory Hotel.fromJson(Map<String, dynamic> json) => _$HotelFromJson(json);

  String? get cover => photos.isEmpty ? null : photos.first;

  /// Part des demandes acceptées parmi celles qui ont reçu une réponse (ou expiré).
  double? get acceptanceRate {
    final answered = stats.accepted + stats.rejected + stats.expired;
    return answered == 0 ? null : stats.accepted / answered;
  }
}

/// Document `hotels/{hotelId}/roomTypes/{roomTypeId}`.
@freezed
abstract class RoomType with _$RoomType {
  const RoomType._();

  const factory RoomType({
    @JsonKey(includeToJson: false) @Default('') String id,
    @Default('') String name,
    @Default('') String description,
    @Default(2) int capacityAdults,
    @Default(0) int capacityChildren,
    @Default('') String beds,
    @Default(Money.zero) Money pricePerNight,
    @Default(1) int quantity,
    @Default([]) List<String> photos,
    @Default([]) List<String> amenities,
    @Default(true) bool active,
  }) = _RoomType;

  factory RoomType.fromJson(Map<String, dynamic> json) => _$RoomTypeFromJson(json);

  int get capacity => capacityAdults + capacityChildren;
}

/// Document `hotels/{hotelId}/offers/{offerId}` : remise sur une période.
@freezed
abstract class HotelOffer with _$HotelOffer {
  const HotelOffer._();

  const factory HotelOffer({
    @JsonKey(includeToJson: false) @Default('') String id,
    @Default('') String title,
    @Default('') String description,
    @Default(0) int discountPercent,
    @Default([]) List<String> roomTypeIds,
    @TimestampConverter() DateTime? validFrom,
    @TimestampConverter() DateTime? validTo,
    @Default(true) bool active,
  }) = _HotelOffer;

  factory HotelOffer.fromJson(Map<String, dynamic> json) => _$HotelOfferFromJson(json);

  /// Même règle que la fonction createBookingRequest : arrivée dans la période, chambre concernée.
  bool appliesTo(String roomTypeId, DateTime checkIn) =>
      active &&
      discountPercent > 0 &&
      (validFrom == null || !checkIn.isBefore(validFrom!)) &&
      (validTo == null || checkIn.isBefore(validTo!)) &&
      (roomTypeIds.isEmpty || roomTypeIds.contains(roomTypeId));

  bool isCurrent(DateTime now) => active && (validTo == null || now.isBefore(validTo!));
}

/// Meilleure remise applicable à une arrivée, comme côté serveur.
HotelOffer? bestOffer(List<HotelOffer> offers, String roomTypeId, DateTime checkIn) {
  final applicable = offers.where((o) => o.appliesTo(roomTypeId, checkIn)).toList()
    ..sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
  return applicable.isEmpty ? null : applicable.first;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum TransactionType { rent, sale }

@JsonEnum(fieldRename: FieldRename.snake)
enum RentPeriod { month, day }

@freezed
abstract class PropertyConditions with _$PropertyConditions {
  const factory PropertyConditions({
    @Default('') String deposit,
    @Default('') String advance,
    @Default('') String agencyFees,
  }) = _PropertyConditions;

  factory PropertyConditions.fromJson(Map<String, dynamic> json) => _$PropertyConditionsFromJson(json);
}

/// Document `properties/{propertyId}`.
@freezed
abstract class Property with _$Property {
  const Property._();

  const factory Property({
    @JsonKey(includeToJson: false) @Default('') String id,
    required String orgId,
    String? orgName,
    String? orgType,
    @Default(TransactionType.rent) TransactionType transactionType,
    @Default('') String propertyType,
    @Default('') String title,
    @Default('') String description,
    @Default('') String city,
    @Default('') String district,
    @Default('') String address,
    @Default('BF') String country,
    @Default(Money.zero) Money price,
    RentPeriod? rentPeriod,
    int? surface,
    int? rooms,
    int? bedrooms,
    int? bathrooms,
    @Default([]) List<String> features,
    @Default(PropertyConditions()) PropertyConditions conditions,
    @Default([]) List<String> photos,
    @JsonKey(includeToJson: false) @Default(false) bool featured,
    @Default(ListingStatus.draft) ListingStatus status,
    @JsonKey(includeToJson: false) @Default(ListingStats()) ListingStats stats,
    @JsonKey(includeToJson: false) Moderation? moderation,
    @JsonKey(includeToJson: false) @TimestampConverter() DateTime? publishedAt,
    @JsonKey(includeToJson: false) @TimestampConverter() DateTime? createdAt,
    @JsonKey(includeToJson: false) @TimestampConverter() DateTime? updatedAt,
  }) = _Property;

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

  String? get cover => photos.isEmpty ? null : photos.first;
  bool get byIndividual => orgType == 'individual_owner';
}

/// Document `projects/{projectId}` : programme immobilier d'un promoteur.
@freezed
abstract class Project with _$Project {
  const Project._();

  const factory Project({
    @JsonKey(includeToJson: false) @Default('') String id,
    required String orgId,
    String? orgName,
    @Default('') String title,
    @Default('') String description,
    @Default('') String city,
    @Default('') String district,
    @Default('') String address,
    @Default('BF') String country,
    @Default([]) List<String> photos,
    Money? estimatedBudget,
    @Default('') String deliveryDate,
    @JsonKey(includeToJson: false) Money? priceFrom,
    @JsonKey(includeToJson: false) @Default(0) int unitsCount,
    @JsonKey(includeToJson: false) @Default(0) int unitsAvailable,
    @JsonKey(includeToJson: false) @Default(false) bool featured,
    @Default(ListingStatus.draft) ListingStatus status,
    @JsonKey(includeToJson: false) @Default(ListingStats()) ListingStats stats,
    @JsonKey(includeToJson: false) Moderation? moderation,
    @JsonKey(includeToJson: false) @TimestampConverter() DateTime? createdAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

  String? get cover => photos.isEmpty ? null : photos.first;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum UnitStatus { available, reserved, sold }

/// Document `projects/{projectId}/units/{unitId}` : lot d'un programme.
@freezed
abstract class ProjectUnit with _$ProjectUnit {
  const factory ProjectUnit({
    @JsonKey(includeToJson: false) @Default('') String id,
    @Default('') String label,
    @Default('') String propertyType,
    int? surface,
    int? rooms,
    @Default(Money.zero) Money price,
    @Default(UnitStatus.available) UnitStatus status,
  }) = _ProjectUnit;

  factory ProjectUnit.fromJson(Map<String, dynamic> json) => _$ProjectUnitFromJson(json);
}

/// Document `users/{uid}/favorites/{targetId}` (données recopiées pour l'affichage).
@freezed
abstract class Favorite with _$Favorite {
  const factory Favorite({
    @JsonKey(includeToJson: false) @Default('') String id,
    required ListingKind targetType,
    @Default('') String title,
    String? photo,
    String? city,
    Money? price,
    @TimestampConverter() DateTime? addedAt,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);
}
