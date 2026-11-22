// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Organization {

@JsonKey(includeToJson: false) String get id; OrgType get type; String get name; String get description; String? get logoUrl; OrgContact get contact; OrgLegal? get legal; Verification get verification; PublishingMode get publishingMode; String? get subscriptionId; String? get createdBy;@TimestampConverter() DateTime? get deletedAt;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationCopyWith<Organization> get copyWith => _$OrganizationCopyWithImpl<Organization>(this as Organization, _$identity);

  /// Serializes this Organization to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Organization&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.legal, legal) || other.legal == legal)&&(identical(other.verification, verification) || other.verification == verification)&&(identical(other.publishingMode, publishingMode) || other.publishingMode == publishingMode)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,description,logoUrl,contact,legal,verification,publishingMode,subscriptionId,createdBy,deletedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Organization(id: $id, type: $type, name: $name, description: $description, logoUrl: $logoUrl, contact: $contact, legal: $legal, verification: $verification, publishingMode: $publishingMode, subscriptionId: $subscriptionId, createdBy: $createdBy, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrganizationCopyWith<$Res>  {
  factory $OrganizationCopyWith(Organization value, $Res Function(Organization) _then) = _$OrganizationCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, OrgType type, String name, String description, String? logoUrl, OrgContact contact, OrgLegal? legal, Verification verification, PublishingMode publishingMode, String? subscriptionId, String? createdBy,@TimestampConverter() DateTime? deletedAt,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});


$OrgContactCopyWith<$Res> get contact;$OrgLegalCopyWith<$Res>? get legal;$VerificationCopyWith<$Res> get verification;

}
/// @nodoc
class _$OrganizationCopyWithImpl<$Res>
    implements $OrganizationCopyWith<$Res> {
  _$OrganizationCopyWithImpl(this._self, this._then);

  final Organization _self;
  final $Res Function(Organization) _then;

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? description = null,Object? logoUrl = freezed,Object? contact = null,Object? legal = freezed,Object? verification = null,Object? publishingMode = null,Object? subscriptionId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrgType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as OrgContact,legal: freezed == legal ? _self.legal : legal // ignore: cast_nullable_to_non_nullable
as OrgLegal?,verification: null == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as Verification,publishingMode: null == publishingMode ? _self.publishingMode : publishingMode // ignore: cast_nullable_to_non_nullable
as PublishingMode,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrgContactCopyWith<$Res> get contact {
  
  return $OrgContactCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrgLegalCopyWith<$Res>? get legal {
    if (_self.legal == null) {
    return null;
  }

  return $OrgLegalCopyWith<$Res>(_self.legal!, (value) {
    return _then(_self.copyWith(legal: value));
  });
}/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerificationCopyWith<$Res> get verification {
  
  return $VerificationCopyWith<$Res>(_self.verification, (value) {
    return _then(_self.copyWith(verification: value));
  });
}
}


/// Adds pattern-matching-related methods to [Organization].
extension OrganizationPatterns on Organization {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Organization value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Organization() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Organization value)  $default,){
final _that = this;
switch (_that) {
case _Organization():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Organization value)?  $default,){
final _that = this;
switch (_that) {
case _Organization() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  OrgType type,  String name,  String description,  String? logoUrl,  OrgContact contact,  OrgLegal? legal,  Verification verification,  PublishingMode publishingMode,  String? subscriptionId,  String? createdBy, @TimestampConverter()  DateTime? deletedAt, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Organization() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.description,_that.logoUrl,_that.contact,_that.legal,_that.verification,_that.publishingMode,_that.subscriptionId,_that.createdBy,_that.deletedAt,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  OrgType type,  String name,  String description,  String? logoUrl,  OrgContact contact,  OrgLegal? legal,  Verification verification,  PublishingMode publishingMode,  String? subscriptionId,  String? createdBy, @TimestampConverter()  DateTime? deletedAt, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Organization():
return $default(_that.id,_that.type,_that.name,_that.description,_that.logoUrl,_that.contact,_that.legal,_that.verification,_that.publishingMode,_that.subscriptionId,_that.createdBy,_that.deletedAt,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  OrgType type,  String name,  String description,  String? logoUrl,  OrgContact contact,  OrgLegal? legal,  Verification verification,  PublishingMode publishingMode,  String? subscriptionId,  String? createdBy, @TimestampConverter()  DateTime? deletedAt, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Organization() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.description,_that.logoUrl,_that.contact,_that.legal,_that.verification,_that.publishingMode,_that.subscriptionId,_that.createdBy,_that.deletedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Organization extends Organization {
  const _Organization({@JsonKey(includeToJson: false) this.id = '', required this.type, required this.name, this.description = '', this.logoUrl, required this.contact, this.legal, this.verification = const Verification(), this.publishingMode = PublishingMode.direct, this.subscriptionId, this.createdBy, @TimestampConverter() this.deletedAt, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt}): super._();
  factory _Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  OrgType type;
@override final  String name;
@override@JsonKey() final  String description;
@override final  String? logoUrl;
@override final  OrgContact contact;
@override final  OrgLegal? legal;
@override@JsonKey() final  Verification verification;
@override@JsonKey() final  PublishingMode publishingMode;
@override final  String? subscriptionId;
@override final  String? createdBy;
@override@TimestampConverter() final  DateTime? deletedAt;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationCopyWith<_Organization> get copyWith => __$OrganizationCopyWithImpl<_Organization>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Organization&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.legal, legal) || other.legal == legal)&&(identical(other.verification, verification) || other.verification == verification)&&(identical(other.publishingMode, publishingMode) || other.publishingMode == publishingMode)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,description,logoUrl,contact,legal,verification,publishingMode,subscriptionId,createdBy,deletedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Organization(id: $id, type: $type, name: $name, description: $description, logoUrl: $logoUrl, contact: $contact, legal: $legal, verification: $verification, publishingMode: $publishingMode, subscriptionId: $subscriptionId, createdBy: $createdBy, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrganizationCopyWith<$Res> implements $OrganizationCopyWith<$Res> {
  factory _$OrganizationCopyWith(_Organization value, $Res Function(_Organization) _then) = __$OrganizationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, OrgType type, String name, String description, String? logoUrl, OrgContact contact, OrgLegal? legal, Verification verification, PublishingMode publishingMode, String? subscriptionId, String? createdBy,@TimestampConverter() DateTime? deletedAt,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});


@override $OrgContactCopyWith<$Res> get contact;@override $OrgLegalCopyWith<$Res>? get legal;@override $VerificationCopyWith<$Res> get verification;

}
/// @nodoc
class __$OrganizationCopyWithImpl<$Res>
    implements _$OrganizationCopyWith<$Res> {
  __$OrganizationCopyWithImpl(this._self, this._then);

  final _Organization _self;
  final $Res Function(_Organization) _then;

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? description = null,Object? logoUrl = freezed,Object? contact = null,Object? legal = freezed,Object? verification = null,Object? publishingMode = null,Object? subscriptionId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Organization(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as OrgType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,contact: null == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as OrgContact,legal: freezed == legal ? _self.legal : legal // ignore: cast_nullable_to_non_nullable
as OrgLegal?,verification: null == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as Verification,publishingMode: null == publishingMode ? _self.publishingMode : publishingMode // ignore: cast_nullable_to_non_nullable
as PublishingMode,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrgContactCopyWith<$Res> get contact {
  
  return $OrgContactCopyWith<$Res>(_self.contact, (value) {
    return _then(_self.copyWith(contact: value));
  });
}/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrgLegalCopyWith<$Res>? get legal {
    if (_self.legal == null) {
    return null;
  }

  return $OrgLegalCopyWith<$Res>(_self.legal!, (value) {
    return _then(_self.copyWith(legal: value));
  });
}/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerificationCopyWith<$Res> get verification {
  
  return $VerificationCopyWith<$Res>(_self.verification, (value) {
    return _then(_self.copyWith(verification: value));
  });
}
}


/// @nodoc
mixin _$OrgContact {

// Valeurs par défaut : un espace particulier anonymisé n'a plus de contact.
 String get phone; String? get email; String? get address; String get city; String get country;
/// Create a copy of OrgContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrgContactCopyWith<OrgContact> get copyWith => _$OrgContactCopyWithImpl<OrgContact>(this as OrgContact, _$identity);

  /// Serializes this OrgContact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrgContact&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,email,address,city,country);

@override
String toString() {
  return 'OrgContact(phone: $phone, email: $email, address: $address, city: $city, country: $country)';
}


}

/// @nodoc
abstract mixin class $OrgContactCopyWith<$Res>  {
  factory $OrgContactCopyWith(OrgContact value, $Res Function(OrgContact) _then) = _$OrgContactCopyWithImpl;
@useResult
$Res call({
 String phone, String? email, String? address, String city, String country
});




}
/// @nodoc
class _$OrgContactCopyWithImpl<$Res>
    implements $OrgContactCopyWith<$Res> {
  _$OrgContactCopyWithImpl(this._self, this._then);

  final OrgContact _self;
  final $Res Function(OrgContact) _then;

/// Create a copy of OrgContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? email = freezed,Object? address = freezed,Object? city = null,Object? country = null,}) {
  return _then(_self.copyWith(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrgContact].
extension OrgContactPatterns on OrgContact {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrgContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrgContact() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrgContact value)  $default,){
final _that = this;
switch (_that) {
case _OrgContact():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrgContact value)?  $default,){
final _that = this;
switch (_that) {
case _OrgContact() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone,  String? email,  String? address,  String city,  String country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrgContact() when $default != null:
return $default(_that.phone,_that.email,_that.address,_that.city,_that.country);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone,  String? email,  String? address,  String city,  String country)  $default,) {final _that = this;
switch (_that) {
case _OrgContact():
return $default(_that.phone,_that.email,_that.address,_that.city,_that.country);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone,  String? email,  String? address,  String city,  String country)?  $default,) {final _that = this;
switch (_that) {
case _OrgContact() when $default != null:
return $default(_that.phone,_that.email,_that.address,_that.city,_that.country);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrgContact implements OrgContact {
  const _OrgContact({this.phone = '', this.email, this.address, this.city = '', this.country = 'BF'});
  factory _OrgContact.fromJson(Map<String, dynamic> json) => _$OrgContactFromJson(json);

// Valeurs par défaut : un espace particulier anonymisé n'a plus de contact.
@override@JsonKey() final  String phone;
@override final  String? email;
@override final  String? address;
@override@JsonKey() final  String city;
@override@JsonKey() final  String country;

/// Create a copy of OrgContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrgContactCopyWith<_OrgContact> get copyWith => __$OrgContactCopyWithImpl<_OrgContact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrgContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrgContact&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,email,address,city,country);

@override
String toString() {
  return 'OrgContact(phone: $phone, email: $email, address: $address, city: $city, country: $country)';
}


}

/// @nodoc
abstract mixin class _$OrgContactCopyWith<$Res> implements $OrgContactCopyWith<$Res> {
  factory _$OrgContactCopyWith(_OrgContact value, $Res Function(_OrgContact) _then) = __$OrgContactCopyWithImpl;
@override @useResult
$Res call({
 String phone, String? email, String? address, String city, String country
});




}
/// @nodoc
class __$OrgContactCopyWithImpl<$Res>
    implements _$OrgContactCopyWith<$Res> {
  __$OrgContactCopyWithImpl(this._self, this._then);

  final _OrgContact _self;
  final $Res Function(_OrgContact) _then;

/// Create a copy of OrgContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? email = freezed,Object? address = freezed,Object? city = null,Object? country = null,}) {
  return _then(_OrgContact(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OrgLegal {

 String? get ifuNumber; String? get rccmNumber; String? get representativeName;
/// Create a copy of OrgLegal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrgLegalCopyWith<OrgLegal> get copyWith => _$OrgLegalCopyWithImpl<OrgLegal>(this as OrgLegal, _$identity);

  /// Serializes this OrgLegal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrgLegal&&(identical(other.ifuNumber, ifuNumber) || other.ifuNumber == ifuNumber)&&(identical(other.rccmNumber, rccmNumber) || other.rccmNumber == rccmNumber)&&(identical(other.representativeName, representativeName) || other.representativeName == representativeName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ifuNumber,rccmNumber,representativeName);

@override
String toString() {
  return 'OrgLegal(ifuNumber: $ifuNumber, rccmNumber: $rccmNumber, representativeName: $representativeName)';
}


}

/// @nodoc
abstract mixin class $OrgLegalCopyWith<$Res>  {
  factory $OrgLegalCopyWith(OrgLegal value, $Res Function(OrgLegal) _then) = _$OrgLegalCopyWithImpl;
@useResult
$Res call({
 String? ifuNumber, String? rccmNumber, String? representativeName
});




}
/// @nodoc
class _$OrgLegalCopyWithImpl<$Res>
    implements $OrgLegalCopyWith<$Res> {
  _$OrgLegalCopyWithImpl(this._self, this._then);

  final OrgLegal _self;
  final $Res Function(OrgLegal) _then;

/// Create a copy of OrgLegal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ifuNumber = freezed,Object? rccmNumber = freezed,Object? representativeName = freezed,}) {
  return _then(_self.copyWith(
ifuNumber: freezed == ifuNumber ? _self.ifuNumber : ifuNumber // ignore: cast_nullable_to_non_nullable
as String?,rccmNumber: freezed == rccmNumber ? _self.rccmNumber : rccmNumber // ignore: cast_nullable_to_non_nullable
as String?,representativeName: freezed == representativeName ? _self.representativeName : representativeName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrgLegal].
extension OrgLegalPatterns on OrgLegal {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrgLegal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrgLegal() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrgLegal value)  $default,){
final _that = this;
switch (_that) {
case _OrgLegal():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrgLegal value)?  $default,){
final _that = this;
switch (_that) {
case _OrgLegal() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? ifuNumber,  String? rccmNumber,  String? representativeName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrgLegal() when $default != null:
return $default(_that.ifuNumber,_that.rccmNumber,_that.representativeName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? ifuNumber,  String? rccmNumber,  String? representativeName)  $default,) {final _that = this;
switch (_that) {
case _OrgLegal():
return $default(_that.ifuNumber,_that.rccmNumber,_that.representativeName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? ifuNumber,  String? rccmNumber,  String? representativeName)?  $default,) {final _that = this;
switch (_that) {
case _OrgLegal() when $default != null:
return $default(_that.ifuNumber,_that.rccmNumber,_that.representativeName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrgLegal implements OrgLegal {
  const _OrgLegal({this.ifuNumber, this.rccmNumber, this.representativeName});
  factory _OrgLegal.fromJson(Map<String, dynamic> json) => _$OrgLegalFromJson(json);

@override final  String? ifuNumber;
@override final  String? rccmNumber;
@override final  String? representativeName;

/// Create a copy of OrgLegal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrgLegalCopyWith<_OrgLegal> get copyWith => __$OrgLegalCopyWithImpl<_OrgLegal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrgLegalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrgLegal&&(identical(other.ifuNumber, ifuNumber) || other.ifuNumber == ifuNumber)&&(identical(other.rccmNumber, rccmNumber) || other.rccmNumber == rccmNumber)&&(identical(other.representativeName, representativeName) || other.representativeName == representativeName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ifuNumber,rccmNumber,representativeName);

@override
String toString() {
  return 'OrgLegal(ifuNumber: $ifuNumber, rccmNumber: $rccmNumber, representativeName: $representativeName)';
}


}

/// @nodoc
abstract mixin class _$OrgLegalCopyWith<$Res> implements $OrgLegalCopyWith<$Res> {
  factory _$OrgLegalCopyWith(_OrgLegal value, $Res Function(_OrgLegal) _then) = __$OrgLegalCopyWithImpl;
@override @useResult
$Res call({
 String? ifuNumber, String? rccmNumber, String? representativeName
});




}
/// @nodoc
class __$OrgLegalCopyWithImpl<$Res>
    implements _$OrgLegalCopyWith<$Res> {
  __$OrgLegalCopyWithImpl(this._self, this._then);

  final _OrgLegal _self;
  final $Res Function(_OrgLegal) _then;

/// Create a copy of OrgLegal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ifuNumber = freezed,Object? rccmNumber = freezed,Object? representativeName = freezed,}) {
  return _then(_OrgLegal(
ifuNumber: freezed == ifuNumber ? _self.ifuNumber : ifuNumber // ignore: cast_nullable_to_non_nullable
as String?,rccmNumber: freezed == rccmNumber ? _self.rccmNumber : rccmNumber // ignore: cast_nullable_to_non_nullable
as String?,representativeName: freezed == representativeName ? _self.representativeName : representativeName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$VerificationDocuments {

 String? get ifu; String? get rccm; String? get proofOfAddress;
/// Create a copy of VerificationDocuments
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationDocumentsCopyWith<VerificationDocuments> get copyWith => _$VerificationDocumentsCopyWithImpl<VerificationDocuments>(this as VerificationDocuments, _$identity);

  /// Serializes this VerificationDocuments to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerificationDocuments&&(identical(other.ifu, ifu) || other.ifu == ifu)&&(identical(other.rccm, rccm) || other.rccm == rccm)&&(identical(other.proofOfAddress, proofOfAddress) || other.proofOfAddress == proofOfAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ifu,rccm,proofOfAddress);

@override
String toString() {
  return 'VerificationDocuments(ifu: $ifu, rccm: $rccm, proofOfAddress: $proofOfAddress)';
}


}

/// @nodoc
abstract mixin class $VerificationDocumentsCopyWith<$Res>  {
  factory $VerificationDocumentsCopyWith(VerificationDocuments value, $Res Function(VerificationDocuments) _then) = _$VerificationDocumentsCopyWithImpl;
@useResult
$Res call({
 String? ifu, String? rccm, String? proofOfAddress
});




}
/// @nodoc
class _$VerificationDocumentsCopyWithImpl<$Res>
    implements $VerificationDocumentsCopyWith<$Res> {
  _$VerificationDocumentsCopyWithImpl(this._self, this._then);

  final VerificationDocuments _self;
  final $Res Function(VerificationDocuments) _then;

/// Create a copy of VerificationDocuments
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ifu = freezed,Object? rccm = freezed,Object? proofOfAddress = freezed,}) {
  return _then(_self.copyWith(
ifu: freezed == ifu ? _self.ifu : ifu // ignore: cast_nullable_to_non_nullable
as String?,rccm: freezed == rccm ? _self.rccm : rccm // ignore: cast_nullable_to_non_nullable
as String?,proofOfAddress: freezed == proofOfAddress ? _self.proofOfAddress : proofOfAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VerificationDocuments].
extension VerificationDocumentsPatterns on VerificationDocuments {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerificationDocuments value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerificationDocuments() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerificationDocuments value)  $default,){
final _that = this;
switch (_that) {
case _VerificationDocuments():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerificationDocuments value)?  $default,){
final _that = this;
switch (_that) {
case _VerificationDocuments() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? ifu,  String? rccm,  String? proofOfAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerificationDocuments() when $default != null:
return $default(_that.ifu,_that.rccm,_that.proofOfAddress);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? ifu,  String? rccm,  String? proofOfAddress)  $default,) {final _that = this;
switch (_that) {
case _VerificationDocuments():
return $default(_that.ifu,_that.rccm,_that.proofOfAddress);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? ifu,  String? rccm,  String? proofOfAddress)?  $default,) {final _that = this;
switch (_that) {
case _VerificationDocuments() when $default != null:
return $default(_that.ifu,_that.rccm,_that.proofOfAddress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerificationDocuments implements VerificationDocuments {
  const _VerificationDocuments({this.ifu, this.rccm, this.proofOfAddress});
  factory _VerificationDocuments.fromJson(Map<String, dynamic> json) => _$VerificationDocumentsFromJson(json);

@override final  String? ifu;
@override final  String? rccm;
@override final  String? proofOfAddress;

/// Create a copy of VerificationDocuments
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerificationDocumentsCopyWith<_VerificationDocuments> get copyWith => __$VerificationDocumentsCopyWithImpl<_VerificationDocuments>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerificationDocumentsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerificationDocuments&&(identical(other.ifu, ifu) || other.ifu == ifu)&&(identical(other.rccm, rccm) || other.rccm == rccm)&&(identical(other.proofOfAddress, proofOfAddress) || other.proofOfAddress == proofOfAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ifu,rccm,proofOfAddress);

@override
String toString() {
  return 'VerificationDocuments(ifu: $ifu, rccm: $rccm, proofOfAddress: $proofOfAddress)';
}


}

/// @nodoc
abstract mixin class _$VerificationDocumentsCopyWith<$Res> implements $VerificationDocumentsCopyWith<$Res> {
  factory _$VerificationDocumentsCopyWith(_VerificationDocuments value, $Res Function(_VerificationDocuments) _then) = __$VerificationDocumentsCopyWithImpl;
@override @useResult
$Res call({
 String? ifu, String? rccm, String? proofOfAddress
});




}
/// @nodoc
class __$VerificationDocumentsCopyWithImpl<$Res>
    implements _$VerificationDocumentsCopyWith<$Res> {
  __$VerificationDocumentsCopyWithImpl(this._self, this._then);

  final _VerificationDocuments _self;
  final $Res Function(_VerificationDocuments) _then;

/// Create a copy of VerificationDocuments
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ifu = freezed,Object? rccm = freezed,Object? proofOfAddress = freezed,}) {
  return _then(_VerificationDocuments(
ifu: freezed == ifu ? _self.ifu : ifu // ignore: cast_nullable_to_non_nullable
as String?,rccm: freezed == rccm ? _self.rccm : rccm // ignore: cast_nullable_to_non_nullable
as String?,proofOfAddress: freezed == proofOfAddress ? _self.proofOfAddress : proofOfAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Verification {

 VerificationStatus get status; VerificationDocuments get documents;@TimestampConverter() DateTime? get submittedAt; String? get reviewedBy;@TimestampConverter() DateTime? get reviewedAt; String? get note;
/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationCopyWith<Verification> get copyWith => _$VerificationCopyWithImpl<Verification>(this as Verification, _$identity);

  /// Serializes this Verification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Verification&&(identical(other.status, status) || other.status == status)&&(identical(other.documents, documents) || other.documents == documents)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,documents,submittedAt,reviewedBy,reviewedAt,note);

@override
String toString() {
  return 'Verification(status: $status, documents: $documents, submittedAt: $submittedAt, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class $VerificationCopyWith<$Res>  {
  factory $VerificationCopyWith(Verification value, $Res Function(Verification) _then) = _$VerificationCopyWithImpl;
@useResult
$Res call({
 VerificationStatus status, VerificationDocuments documents,@TimestampConverter() DateTime? submittedAt, String? reviewedBy,@TimestampConverter() DateTime? reviewedAt, String? note
});


$VerificationDocumentsCopyWith<$Res> get documents;

}
/// @nodoc
class _$VerificationCopyWithImpl<$Res>
    implements $VerificationCopyWith<$Res> {
  _$VerificationCopyWithImpl(this._self, this._then);

  final Verification _self;
  final $Res Function(Verification) _then;

/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? documents = null,Object? submittedAt = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as VerificationDocuments,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerificationDocumentsCopyWith<$Res> get documents {
  
  return $VerificationDocumentsCopyWith<$Res>(_self.documents, (value) {
    return _then(_self.copyWith(documents: value));
  });
}
}


/// Adds pattern-matching-related methods to [Verification].
extension VerificationPatterns on Verification {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Verification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Verification() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Verification value)  $default,){
final _that = this;
switch (_that) {
case _Verification():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Verification value)?  $default,){
final _that = this;
switch (_that) {
case _Verification() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VerificationStatus status,  VerificationDocuments documents, @TimestampConverter()  DateTime? submittedAt,  String? reviewedBy, @TimestampConverter()  DateTime? reviewedAt,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Verification() when $default != null:
return $default(_that.status,_that.documents,_that.submittedAt,_that.reviewedBy,_that.reviewedAt,_that.note);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VerificationStatus status,  VerificationDocuments documents, @TimestampConverter()  DateTime? submittedAt,  String? reviewedBy, @TimestampConverter()  DateTime? reviewedAt,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Verification():
return $default(_that.status,_that.documents,_that.submittedAt,_that.reviewedBy,_that.reviewedAt,_that.note);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VerificationStatus status,  VerificationDocuments documents, @TimestampConverter()  DateTime? submittedAt,  String? reviewedBy, @TimestampConverter()  DateTime? reviewedAt,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Verification() when $default != null:
return $default(_that.status,_that.documents,_that.submittedAt,_that.reviewedBy,_that.reviewedAt,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Verification implements Verification {
  const _Verification({this.status = VerificationStatus.draft, this.documents = const VerificationDocuments(), @TimestampConverter() this.submittedAt, this.reviewedBy, @TimestampConverter() this.reviewedAt, this.note});
  factory _Verification.fromJson(Map<String, dynamic> json) => _$VerificationFromJson(json);

@override@JsonKey() final  VerificationStatus status;
@override@JsonKey() final  VerificationDocuments documents;
@override@TimestampConverter() final  DateTime? submittedAt;
@override final  String? reviewedBy;
@override@TimestampConverter() final  DateTime? reviewedAt;
@override final  String? note;

/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerificationCopyWith<_Verification> get copyWith => __$VerificationCopyWithImpl<_Verification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Verification&&(identical(other.status, status) || other.status == status)&&(identical(other.documents, documents) || other.documents == documents)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,documents,submittedAt,reviewedBy,reviewedAt,note);

@override
String toString() {
  return 'Verification(status: $status, documents: $documents, submittedAt: $submittedAt, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class _$VerificationCopyWith<$Res> implements $VerificationCopyWith<$Res> {
  factory _$VerificationCopyWith(_Verification value, $Res Function(_Verification) _then) = __$VerificationCopyWithImpl;
@override @useResult
$Res call({
 VerificationStatus status, VerificationDocuments documents,@TimestampConverter() DateTime? submittedAt, String? reviewedBy,@TimestampConverter() DateTime? reviewedAt, String? note
});


@override $VerificationDocumentsCopyWith<$Res> get documents;

}
/// @nodoc
class __$VerificationCopyWithImpl<$Res>
    implements _$VerificationCopyWith<$Res> {
  __$VerificationCopyWithImpl(this._self, this._then);

  final _Verification _self;
  final $Res Function(_Verification) _then;

/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? documents = null,Object? submittedAt = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? note = freezed,}) {
  return _then(_Verification(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as VerificationDocuments,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerificationDocumentsCopyWith<$Res> get documents {
  
  return $VerificationDocumentsCopyWith<$Res>(_self.documents, (value) {
    return _then(_self.copyWith(documents: value));
  });
}
}


/// @nodoc
mixin _$OrgMember {

@JsonKey(includeToJson: false) String get id; OrgRole get role; String? get displayName; String? get email;@TimestampConverter() DateTime? get addedAt;
/// Create a copy of OrgMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrgMemberCopyWith<OrgMember> get copyWith => _$OrgMemberCopyWithImpl<OrgMember>(this as OrgMember, _$identity);

  /// Serializes this OrgMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrgMember&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,displayName,email,addedAt);

@override
String toString() {
  return 'OrgMember(id: $id, role: $role, displayName: $displayName, email: $email, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $OrgMemberCopyWith<$Res>  {
  factory $OrgMemberCopyWith(OrgMember value, $Res Function(OrgMember) _then) = _$OrgMemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, OrgRole role, String? displayName, String? email,@TimestampConverter() DateTime? addedAt
});




}
/// @nodoc
class _$OrgMemberCopyWithImpl<$Res>
    implements $OrgMemberCopyWith<$Res> {
  _$OrgMemberCopyWithImpl(this._self, this._then);

  final OrgMember _self;
  final $Res Function(OrgMember) _then;

/// Create a copy of OrgMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? displayName = freezed,Object? email = freezed,Object? addedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as OrgRole,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrgMember].
extension OrgMemberPatterns on OrgMember {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrgMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrgMember() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrgMember value)  $default,){
final _that = this;
switch (_that) {
case _OrgMember():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrgMember value)?  $default,){
final _that = this;
switch (_that) {
case _OrgMember() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  OrgRole role,  String? displayName,  String? email, @TimestampConverter()  DateTime? addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrgMember() when $default != null:
return $default(_that.id,_that.role,_that.displayName,_that.email,_that.addedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  OrgRole role,  String? displayName,  String? email, @TimestampConverter()  DateTime? addedAt)  $default,) {final _that = this;
switch (_that) {
case _OrgMember():
return $default(_that.id,_that.role,_that.displayName,_that.email,_that.addedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  OrgRole role,  String? displayName,  String? email, @TimestampConverter()  DateTime? addedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrgMember() when $default != null:
return $default(_that.id,_that.role,_that.displayName,_that.email,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrgMember implements OrgMember {
  const _OrgMember({@JsonKey(includeToJson: false) this.id = '', required this.role, this.displayName, this.email, @TimestampConverter() this.addedAt});
  factory _OrgMember.fromJson(Map<String, dynamic> json) => _$OrgMemberFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  OrgRole role;
@override final  String? displayName;
@override final  String? email;
@override@TimestampConverter() final  DateTime? addedAt;

/// Create a copy of OrgMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrgMemberCopyWith<_OrgMember> get copyWith => __$OrgMemberCopyWithImpl<_OrgMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrgMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrgMember&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,displayName,email,addedAt);

@override
String toString() {
  return 'OrgMember(id: $id, role: $role, displayName: $displayName, email: $email, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$OrgMemberCopyWith<$Res> implements $OrgMemberCopyWith<$Res> {
  factory _$OrgMemberCopyWith(_OrgMember value, $Res Function(_OrgMember) _then) = __$OrgMemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, OrgRole role, String? displayName, String? email,@TimestampConverter() DateTime? addedAt
});




}
/// @nodoc
class __$OrgMemberCopyWithImpl<$Res>
    implements _$OrgMemberCopyWith<$Res> {
  __$OrgMemberCopyWithImpl(this._self, this._then);

  final _OrgMember _self;
  final $Res Function(_OrgMember) _then;

/// Create a copy of OrgMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? displayName = freezed,Object? email = freezed,Object? addedAt = freezed,}) {
  return _then(_OrgMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as OrgRole,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
