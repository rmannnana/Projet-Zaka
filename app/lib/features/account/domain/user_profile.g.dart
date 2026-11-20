// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String? ?? '',
  displayName: json['displayName'] as String? ?? '',
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  photoUrl: json['photoUrl'] as String?,
  country: json['country'] as String? ?? 'BF',
  locale: json['locale'] as String? ?? 'fr',
  orgIds:
      (json['orgIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  fcmTokens:
      (json['fcmTokens'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  status:
      $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ??
      UserStatus.active,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'email': ?instance.email,
      'phone': ?instance.phone,
      'photoUrl': ?instance.photoUrl,
      'country': instance.country,
      'locale': instance.locale,
      'orgIds': instance.orgIds,
      'fcmTokens': instance.fcmTokens,
      'status': _$UserStatusEnumMap[instance.status]!,
      'createdAt': ?const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': ?const TimestampConverter().toJson(instance.updatedAt),
    };

const _$UserStatusEnumMap = {
  UserStatus.active: 'active',
  UserStatus.suspended: 'suspended',
};
