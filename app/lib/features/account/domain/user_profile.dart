import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore_json.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Document `users/{uid}`. Créé par la Cloud Function `onUserCreated`.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(includeToJson: false) @Default('') String id,
    @Default('') String displayName,
    String? email,
    String? phone,
    String? photoUrl,
    @Default('BF') String country,
    @Default('fr') String locale,
    @Default(<String>[]) List<String> orgIds,
    @Default(<String>[]) List<String> fcmTokens,
    @Default(UserStatus.active) UserStatus status,
    /// Rôle staff (copie lisible du custom claim, écrite par setUserRole).
    String? staffRole,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum UserStatus { active, suspended }
