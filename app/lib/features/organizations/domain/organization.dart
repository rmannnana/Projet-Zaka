import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore_json.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

/// Document `organizations/{orgId}` : un compte publieur (hôtel, agence,
/// promoteur ou particulier propriétaire).
@freezed
abstract class Organization with _$Organization {
  const Organization._();

  const factory Organization({
    @JsonKey(includeToJson: false) @Default('') String id,
    required OrgType type,
    required String name,
    @Default('') String description,
    String? logoUrl,
    required OrgContact contact,
    OrgLegal? legal,
    @Default(Verification()) Verification verification,
    @Default(PublishingMode.direct) PublishingMode publishingMode,
    String? subscriptionId,
    String? createdBy,
    @TimestampConverter() DateTime? deletedAt,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

  bool get isVerified => verification.status == VerificationStatus.verified;

  /// Les annonces d'un particulier passent par la validation ZAKA.
  bool get requiresListingReview => publishingMode == PublishingMode.review;

  bool get canPublishHotels => type == OrgType.hotel;
  bool get canPublishProjects => type == OrgType.developer;
  bool get canPublishProperties => type != OrgType.hotel;

  /// Un pro peut compléter et (re)envoyer son dossier.
  bool get canEditVerification =>
      type.requiresDocuments &&
      (verification.status == VerificationStatus.draft ||
          verification.status == VerificationStatus.rejected);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum OrgType {
  hotel,
  individualOwner,
  agency,
  developer;

  /// Seuls les professionnels fournissent IFU, RCCM et justificatif de résidence.
  bool get requiresDocuments => this != OrgType.individualOwner;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum VerificationStatus { draft, pending, verified, rejected, suspended }

@JsonEnum(fieldRename: FieldRename.snake)
enum PublishingMode { direct, review }

@freezed
abstract class OrgContact with _$OrgContact {
  const factory OrgContact({
    // Valeurs par défaut : un espace particulier anonymisé n'a plus de contact.
    @Default('') String phone,
    String? email,
    String? address,
    @Default('') String city,
    @Default('BF') String country,
  }) = _OrgContact;

  factory OrgContact.fromJson(Map<String, dynamic> json) => _$OrgContactFromJson(json);
}

@freezed
abstract class OrgLegal with _$OrgLegal {
  const factory OrgLegal({
    String? ifuNumber,
    String? rccmNumber,
    String? representativeName,
  }) = _OrgLegal;

  factory OrgLegal.fromJson(Map<String, dynamic> json) => _$OrgLegalFromJson(json);
}

/// Pièces exigées des professionnels : IFU, RCCM, contrat de bail ou autre
/// justificatif de résidence. Chemins Storage privés.
@freezed
abstract class VerificationDocuments with _$VerificationDocuments {
  const factory VerificationDocuments({
    String? ifu,
    String? rccm,
    String? proofOfAddress,
  }) = _VerificationDocuments;

  factory VerificationDocuments.fromJson(Map<String, dynamic> json) =>
      _$VerificationDocumentsFromJson(json);
}

@freezed
abstract class Verification with _$Verification {
  const factory Verification({
    @Default(VerificationStatus.draft) VerificationStatus status,
    @Default(VerificationDocuments()) VerificationDocuments documents,
    @TimestampConverter() DateTime? submittedAt,
    String? reviewedBy,
    @TimestampConverter() DateTime? reviewedAt,
    String? note,
  }) = _Verification;

  factory Verification.fromJson(Map<String, dynamic> json) => _$VerificationFromJson(json);
}

/// Document `organizations/{orgId}/members/{uid}`.
@freezed
abstract class OrgMember with _$OrgMember {
  const factory OrgMember({
    @JsonKey(includeToJson: false) @Default('') String id,
    required OrgRole role,
    String? displayName,
    String? email,
    @TimestampConverter() DateTime? addedAt,
  }) = _OrgMember;

  factory OrgMember.fromJson(Map<String, dynamic> json) => _$OrgMemberFromJson(json);
}

enum OrgRole { owner, editor }
