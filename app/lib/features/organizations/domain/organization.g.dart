// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Organization _$OrganizationFromJson(Map<String, dynamic> json) =>
    _Organization(
      id: json['id'] as String? ?? '',
      type: $enumDecode(_$OrgTypeEnumMap, json['type']),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
      contact: OrgContact.fromJson(json['contact'] as Map<String, dynamic>),
      legal: json['legal'] == null
          ? null
          : OrgLegal.fromJson(json['legal'] as Map<String, dynamic>),
      verification: json['verification'] == null
          ? const Verification()
          : Verification.fromJson(json['verification'] as Map<String, dynamic>),
      publishingMode:
          $enumDecodeNullable(
            _$PublishingModeEnumMap,
            json['publishingMode'],
          ) ??
          PublishingMode.direct,
      subscriptionId: json['subscriptionId'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$OrganizationToJson(_Organization instance) =>
    <String, dynamic>{
      'type': _$OrgTypeEnumMap[instance.type]!,
      'name': instance.name,
      'description': instance.description,
      'logoUrl': ?instance.logoUrl,
      'contact': instance.contact.toJson(),
      'legal': ?instance.legal?.toJson(),
      'verification': instance.verification.toJson(),
      'publishingMode': _$PublishingModeEnumMap[instance.publishingMode]!,
      'subscriptionId': ?instance.subscriptionId,
      'createdAt': ?const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': ?const TimestampConverter().toJson(instance.updatedAt),
    };

const _$OrgTypeEnumMap = {
  OrgType.hotel: 'hotel',
  OrgType.individualOwner: 'individual_owner',
  OrgType.agency: 'agency',
  OrgType.developer: 'developer',
};

const _$PublishingModeEnumMap = {
  PublishingMode.direct: 'direct',
  PublishingMode.review: 'review',
};

_OrgContact _$OrgContactFromJson(Map<String, dynamic> json) => _OrgContact(
  phone: json['phone'] as String,
  email: json['email'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String,
  country: json['country'] as String? ?? 'BF',
);

Map<String, dynamic> _$OrgContactToJson(_OrgContact instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'email': ?instance.email,
      'address': ?instance.address,
      'city': instance.city,
      'country': instance.country,
    };

_OrgLegal _$OrgLegalFromJson(Map<String, dynamic> json) => _OrgLegal(
  ifuNumber: json['ifuNumber'] as String?,
  rccmNumber: json['rccmNumber'] as String?,
  representativeName: json['representativeName'] as String?,
);

Map<String, dynamic> _$OrgLegalToJson(_OrgLegal instance) => <String, dynamic>{
  'ifuNumber': ?instance.ifuNumber,
  'rccmNumber': ?instance.rccmNumber,
  'representativeName': ?instance.representativeName,
};

_VerificationDocuments _$VerificationDocumentsFromJson(
  Map<String, dynamic> json,
) => _VerificationDocuments(
  ifu: json['ifu'] as String?,
  rccm: json['rccm'] as String?,
  proofOfAddress: json['proofOfAddress'] as String?,
);

Map<String, dynamic> _$VerificationDocumentsToJson(
  _VerificationDocuments instance,
) => <String, dynamic>{
  'ifu': ?instance.ifu,
  'rccm': ?instance.rccm,
  'proofOfAddress': ?instance.proofOfAddress,
};

_Verification _$VerificationFromJson(Map<String, dynamic> json) =>
    _Verification(
      status:
          $enumDecodeNullable(_$VerificationStatusEnumMap, json['status']) ??
          VerificationStatus.draft,
      documents: json['documents'] == null
          ? const VerificationDocuments()
          : VerificationDocuments.fromJson(
              json['documents'] as Map<String, dynamic>,
            ),
      reviewedBy: json['reviewedBy'] as String?,
      reviewedAt: const TimestampConverter().fromJson(json['reviewedAt']),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$VerificationToJson(_Verification instance) =>
    <String, dynamic>{
      'status': _$VerificationStatusEnumMap[instance.status]!,
      'documents': instance.documents.toJson(),
      'reviewedBy': ?instance.reviewedBy,
      'reviewedAt': ?const TimestampConverter().toJson(instance.reviewedAt),
      'note': ?instance.note,
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.draft: 'draft',
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
  VerificationStatus.rejected: 'rejected',
  VerificationStatus.suspended: 'suspended',
};
