// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListingStats {

 int get views; int get requests; int get accepted; int get rejected; int get expired; int get leads;
/// Create a copy of ListingStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingStatsCopyWith<ListingStats> get copyWith => _$ListingStatsCopyWithImpl<ListingStats>(this as ListingStats, _$identity);

  /// Serializes this ListingStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingStats&&(identical(other.views, views) || other.views == views)&&(identical(other.requests, requests) || other.requests == requests)&&(identical(other.accepted, accepted) || other.accepted == accepted)&&(identical(other.rejected, rejected) || other.rejected == rejected)&&(identical(other.expired, expired) || other.expired == expired)&&(identical(other.leads, leads) || other.leads == leads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,views,requests,accepted,rejected,expired,leads);

@override
String toString() {
  return 'ListingStats(views: $views, requests: $requests, accepted: $accepted, rejected: $rejected, expired: $expired, leads: $leads)';
}


}

/// @nodoc
abstract mixin class $ListingStatsCopyWith<$Res>  {
  factory $ListingStatsCopyWith(ListingStats value, $Res Function(ListingStats) _then) = _$ListingStatsCopyWithImpl;
@useResult
$Res call({
 int views, int requests, int accepted, int rejected, int expired, int leads
});




}
/// @nodoc
class _$ListingStatsCopyWithImpl<$Res>
    implements $ListingStatsCopyWith<$Res> {
  _$ListingStatsCopyWithImpl(this._self, this._then);

  final ListingStats _self;
  final $Res Function(ListingStats) _then;

/// Create a copy of ListingStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? views = null,Object? requests = null,Object? accepted = null,Object? rejected = null,Object? expired = null,Object? leads = null,}) {
  return _then(_self.copyWith(
views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as int,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as int,leads: null == leads ? _self.leads : leads // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ListingStats].
extension ListingStatsPatterns on ListingStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListingStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListingStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListingStats value)  $default,){
final _that = this;
switch (_that) {
case _ListingStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListingStats value)?  $default,){
final _that = this;
switch (_that) {
case _ListingStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int views,  int requests,  int accepted,  int rejected,  int expired,  int leads)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListingStats() when $default != null:
return $default(_that.views,_that.requests,_that.accepted,_that.rejected,_that.expired,_that.leads);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int views,  int requests,  int accepted,  int rejected,  int expired,  int leads)  $default,) {final _that = this;
switch (_that) {
case _ListingStats():
return $default(_that.views,_that.requests,_that.accepted,_that.rejected,_that.expired,_that.leads);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int views,  int requests,  int accepted,  int rejected,  int expired,  int leads)?  $default,) {final _that = this;
switch (_that) {
case _ListingStats() when $default != null:
return $default(_that.views,_that.requests,_that.accepted,_that.rejected,_that.expired,_that.leads);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListingStats implements ListingStats {
  const _ListingStats({this.views = 0, this.requests = 0, this.accepted = 0, this.rejected = 0, this.expired = 0, this.leads = 0});
  factory _ListingStats.fromJson(Map<String, dynamic> json) => _$ListingStatsFromJson(json);

@override@JsonKey() final  int views;
@override@JsonKey() final  int requests;
@override@JsonKey() final  int accepted;
@override@JsonKey() final  int rejected;
@override@JsonKey() final  int expired;
@override@JsonKey() final  int leads;

/// Create a copy of ListingStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingStatsCopyWith<_ListingStats> get copyWith => __$ListingStatsCopyWithImpl<_ListingStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListingStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListingStats&&(identical(other.views, views) || other.views == views)&&(identical(other.requests, requests) || other.requests == requests)&&(identical(other.accepted, accepted) || other.accepted == accepted)&&(identical(other.rejected, rejected) || other.rejected == rejected)&&(identical(other.expired, expired) || other.expired == expired)&&(identical(other.leads, leads) || other.leads == leads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,views,requests,accepted,rejected,expired,leads);

@override
String toString() {
  return 'ListingStats(views: $views, requests: $requests, accepted: $accepted, rejected: $rejected, expired: $expired, leads: $leads)';
}


}

/// @nodoc
abstract mixin class _$ListingStatsCopyWith<$Res> implements $ListingStatsCopyWith<$Res> {
  factory _$ListingStatsCopyWith(_ListingStats value, $Res Function(_ListingStats) _then) = __$ListingStatsCopyWithImpl;
@override @useResult
$Res call({
 int views, int requests, int accepted, int rejected, int expired, int leads
});




}
/// @nodoc
class __$ListingStatsCopyWithImpl<$Res>
    implements _$ListingStatsCopyWith<$Res> {
  __$ListingStatsCopyWithImpl(this._self, this._then);

  final _ListingStats _self;
  final $Res Function(_ListingStats) _then;

/// Create a copy of ListingStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? views = null,Object? requests = null,Object? accepted = null,Object? rejected = null,Object? expired = null,Object? leads = null,}) {
  return _then(_ListingStats(
views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as int,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,expired: null == expired ? _self.expired : expired // ignore: cast_nullable_to_non_nullable
as int,leads: null == leads ? _self.leads : leads // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Moderation {

 String? get reviewedBy;@TimestampConverter() DateTime? get reviewedAt; String? get reason;
/// Create a copy of Moderation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModerationCopyWith<Moderation> get copyWith => _$ModerationCopyWithImpl<Moderation>(this as Moderation, _$identity);

  /// Serializes this Moderation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Moderation&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reviewedBy,reviewedAt,reason);

@override
String toString() {
  return 'Moderation(reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ModerationCopyWith<$Res>  {
  factory $ModerationCopyWith(Moderation value, $Res Function(Moderation) _then) = _$ModerationCopyWithImpl;
@useResult
$Res call({
 String? reviewedBy,@TimestampConverter() DateTime? reviewedAt, String? reason
});




}
/// @nodoc
class _$ModerationCopyWithImpl<$Res>
    implements $ModerationCopyWith<$Res> {
  _$ModerationCopyWithImpl(this._self, this._then);

  final Moderation _self;
  final $Res Function(Moderation) _then;

/// Create a copy of Moderation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? reason = freezed,}) {
  return _then(_self.copyWith(
reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Moderation].
extension ModerationPatterns on Moderation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Moderation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Moderation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Moderation value)  $default,){
final _that = this;
switch (_that) {
case _Moderation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Moderation value)?  $default,){
final _that = this;
switch (_that) {
case _Moderation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? reviewedBy, @TimestampConverter()  DateTime? reviewedAt,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Moderation() when $default != null:
return $default(_that.reviewedBy,_that.reviewedAt,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? reviewedBy, @TimestampConverter()  DateTime? reviewedAt,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _Moderation():
return $default(_that.reviewedBy,_that.reviewedAt,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? reviewedBy, @TimestampConverter()  DateTime? reviewedAt,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _Moderation() when $default != null:
return $default(_that.reviewedBy,_that.reviewedAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Moderation implements Moderation {
  const _Moderation({this.reviewedBy, @TimestampConverter() this.reviewedAt, this.reason});
  factory _Moderation.fromJson(Map<String, dynamic> json) => _$ModerationFromJson(json);

@override final  String? reviewedBy;
@override@TimestampConverter() final  DateTime? reviewedAt;
@override final  String? reason;

/// Create a copy of Moderation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModerationCopyWith<_Moderation> get copyWith => __$ModerationCopyWithImpl<_Moderation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModerationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Moderation&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reviewedBy,reviewedAt,reason);

@override
String toString() {
  return 'Moderation(reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ModerationCopyWith<$Res> implements $ModerationCopyWith<$Res> {
  factory _$ModerationCopyWith(_Moderation value, $Res Function(_Moderation) _then) = __$ModerationCopyWithImpl;
@override @useResult
$Res call({
 String? reviewedBy,@TimestampConverter() DateTime? reviewedAt, String? reason
});




}
/// @nodoc
class __$ModerationCopyWithImpl<$Res>
    implements _$ModerationCopyWith<$Res> {
  __$ModerationCopyWithImpl(this._self, this._then);

  final _Moderation _self;
  final $Res Function(_Moderation) _then;

/// Create a copy of Moderation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? reason = freezed,}) {
  return _then(_Moderation(
reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HotelRules {

 String get checkIn; String get checkOut; bool get pets; String get cancellationPolicy; String get other;
/// Create a copy of HotelRules
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelRulesCopyWith<HotelRules> get copyWith => _$HotelRulesCopyWithImpl<HotelRules>(this as HotelRules, _$identity);

  /// Serializes this HotelRules to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelRules&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.pets, pets) || other.pets == pets)&&(identical(other.cancellationPolicy, cancellationPolicy) || other.cancellationPolicy == cancellationPolicy)&&(identical(other.other, this.other) || other.other == this.other));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkIn,checkOut,pets,cancellationPolicy,other);

@override
String toString() {
  return 'HotelRules(checkIn: $checkIn, checkOut: $checkOut, pets: $pets, cancellationPolicy: $cancellationPolicy, other: $other)';
}


}

/// @nodoc
abstract mixin class $HotelRulesCopyWith<$Res>  {
  factory $HotelRulesCopyWith(HotelRules value, $Res Function(HotelRules) _then) = _$HotelRulesCopyWithImpl;
@useResult
$Res call({
 String checkIn, String checkOut, bool pets, String cancellationPolicy, String other
});




}
/// @nodoc
class _$HotelRulesCopyWithImpl<$Res>
    implements $HotelRulesCopyWith<$Res> {
  _$HotelRulesCopyWithImpl(this._self, this._then);

  final HotelRules _self;
  final $Res Function(HotelRules) _then;

/// Create a copy of HotelRules
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checkIn = null,Object? checkOut = null,Object? pets = null,Object? cancellationPolicy = null,Object? other = null,}) {
  return _then(_self.copyWith(
checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String,pets: null == pets ? _self.pets : pets // ignore: cast_nullable_to_non_nullable
as bool,cancellationPolicy: null == cancellationPolicy ? _self.cancellationPolicy : cancellationPolicy // ignore: cast_nullable_to_non_nullable
as String,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelRules].
extension HotelRulesPatterns on HotelRules {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelRules value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelRules() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelRules value)  $default,){
final _that = this;
switch (_that) {
case _HotelRules():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelRules value)?  $default,){
final _that = this;
switch (_that) {
case _HotelRules() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String checkIn,  String checkOut,  bool pets,  String cancellationPolicy,  String other)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelRules() when $default != null:
return $default(_that.checkIn,_that.checkOut,_that.pets,_that.cancellationPolicy,_that.other);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String checkIn,  String checkOut,  bool pets,  String cancellationPolicy,  String other)  $default,) {final _that = this;
switch (_that) {
case _HotelRules():
return $default(_that.checkIn,_that.checkOut,_that.pets,_that.cancellationPolicy,_that.other);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String checkIn,  String checkOut,  bool pets,  String cancellationPolicy,  String other)?  $default,) {final _that = this;
switch (_that) {
case _HotelRules() when $default != null:
return $default(_that.checkIn,_that.checkOut,_that.pets,_that.cancellationPolicy,_that.other);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelRules implements HotelRules {
  const _HotelRules({this.checkIn = '', this.checkOut = '', this.pets = false, this.cancellationPolicy = '', this.other = ''});
  factory _HotelRules.fromJson(Map<String, dynamic> json) => _$HotelRulesFromJson(json);

@override@JsonKey() final  String checkIn;
@override@JsonKey() final  String checkOut;
@override@JsonKey() final  bool pets;
@override@JsonKey() final  String cancellationPolicy;
@override@JsonKey() final  String other;

/// Create a copy of HotelRules
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelRulesCopyWith<_HotelRules> get copyWith => __$HotelRulesCopyWithImpl<_HotelRules>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelRulesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelRules&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.pets, pets) || other.pets == pets)&&(identical(other.cancellationPolicy, cancellationPolicy) || other.cancellationPolicy == cancellationPolicy)&&(identical(other.other, this.other) || other.other == this.other));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkIn,checkOut,pets,cancellationPolicy,other);

@override
String toString() {
  return 'HotelRules(checkIn: $checkIn, checkOut: $checkOut, pets: $pets, cancellationPolicy: $cancellationPolicy, other: $other)';
}


}

/// @nodoc
abstract mixin class _$HotelRulesCopyWith<$Res> implements $HotelRulesCopyWith<$Res> {
  factory _$HotelRulesCopyWith(_HotelRules value, $Res Function(_HotelRules) _then) = __$HotelRulesCopyWithImpl;
@override @useResult
$Res call({
 String checkIn, String checkOut, bool pets, String cancellationPolicy, String other
});




}
/// @nodoc
class __$HotelRulesCopyWithImpl<$Res>
    implements _$HotelRulesCopyWith<$Res> {
  __$HotelRulesCopyWithImpl(this._self, this._then);

  final _HotelRules _self;
  final $Res Function(_HotelRules) _then;

/// Create a copy of HotelRules
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checkIn = null,Object? checkOut = null,Object? pets = null,Object? cancellationPolicy = null,Object? other = null,}) {
  return _then(_HotelRules(
checkIn: null == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String,checkOut: null == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String,pets: null == pets ? _self.pets : pets // ignore: cast_nullable_to_non_nullable
as bool,cancellationPolicy: null == cancellationPolicy ? _self.cancellationPolicy : cancellationPolicy // ignore: cast_nullable_to_non_nullable
as String,other: null == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Hotel {

@JsonKey(includeToJson: false) String get id; String get orgId; String? get orgName; String get name; String get description; String get city; String get district; String get address; String get country; List<String> get photos; List<String> get amenities; int? get stars; String get phone; HotelRules get rules;@JsonKey(includeToJson: false) Money? get minPricePerNight;@JsonKey(includeToJson: false) int get maxGuests;@JsonKey(includeToJson: false) int get roomTypesCount;@JsonKey(includeToJson: false) bool get featured; ListingStatus get status;@JsonKey(includeToJson: false) ListingStats get stats;@JsonKey(includeToJson: false) Moderation? get moderation;@JsonKey(includeToJson: false)@TimestampConverter() DateTime? get createdAt;@JsonKey(includeToJson: false)@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelCopyWith<Hotel> get copyWith => _$HotelCopyWithImpl<Hotel>(this as Hotel, _$identity);

  /// Serializes this Hotel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hotel&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.country, country) || other.country == country)&&const DeepCollectionEquality().equals(other.photos, photos)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.rules, rules) || other.rules == rules)&&(identical(other.minPricePerNight, minPricePerNight) || other.minPricePerNight == minPricePerNight)&&(identical(other.maxGuests, maxGuests) || other.maxGuests == maxGuests)&&(identical(other.roomTypesCount, roomTypesCount) || other.roomTypesCount == roomTypesCount)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.status, status) || other.status == status)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.moderation, moderation) || other.moderation == moderation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orgId,orgName,name,description,city,district,address,country,const DeepCollectionEquality().hash(photos),const DeepCollectionEquality().hash(amenities),stars,phone,rules,minPricePerNight,maxGuests,roomTypesCount,featured,status,stats,moderation,createdAt,updatedAt]);

@override
String toString() {
  return 'Hotel(id: $id, orgId: $orgId, orgName: $orgName, name: $name, description: $description, city: $city, district: $district, address: $address, country: $country, photos: $photos, amenities: $amenities, stars: $stars, phone: $phone, rules: $rules, minPricePerNight: $minPricePerNight, maxGuests: $maxGuests, roomTypesCount: $roomTypesCount, featured: $featured, status: $status, stats: $stats, moderation: $moderation, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $HotelCopyWith<$Res>  {
  factory $HotelCopyWith(Hotel value, $Res Function(Hotel) _then) = _$HotelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, String name, String description, String city, String district, String address, String country, List<String> photos, List<String> amenities, int? stars, String phone, HotelRules rules,@JsonKey(includeToJson: false) Money? minPricePerNight,@JsonKey(includeToJson: false) int maxGuests,@JsonKey(includeToJson: false) int roomTypesCount,@JsonKey(includeToJson: false) bool featured, ListingStatus status,@JsonKey(includeToJson: false) ListingStats stats,@JsonKey(includeToJson: false) Moderation? moderation,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? createdAt,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? updatedAt
});


$HotelRulesCopyWith<$Res> get rules;$ListingStatsCopyWith<$Res> get stats;$ModerationCopyWith<$Res>? get moderation;

}
/// @nodoc
class _$HotelCopyWithImpl<$Res>
    implements $HotelCopyWith<$Res> {
  _$HotelCopyWithImpl(this._self, this._then);

  final Hotel _self;
  final $Res Function(Hotel) _then;

/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? name = null,Object? description = null,Object? city = null,Object? district = null,Object? address = null,Object? country = null,Object? photos = null,Object? amenities = null,Object? stars = freezed,Object? phone = null,Object? rules = null,Object? minPricePerNight = freezed,Object? maxGuests = null,Object? roomTypesCount = null,Object? featured = null,Object? status = null,Object? stats = null,Object? moderation = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,stars: freezed == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as int?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as HotelRules,minPricePerNight: freezed == minPricePerNight ? _self.minPricePerNight : minPricePerNight // ignore: cast_nullable_to_non_nullable
as Money?,maxGuests: null == maxGuests ? _self.maxGuests : maxGuests // ignore: cast_nullable_to_non_nullable
as int,roomTypesCount: null == roomTypesCount ? _self.roomTypesCount : roomTypesCount // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ListingStats,moderation: freezed == moderation ? _self.moderation : moderation // ignore: cast_nullable_to_non_nullable
as Moderation?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HotelRulesCopyWith<$Res> get rules {
  
  return $HotelRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingStatsCopyWith<$Res> get stats {
  
  return $ListingStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModerationCopyWith<$Res>? get moderation {
    if (_self.moderation == null) {
    return null;
  }

  return $ModerationCopyWith<$Res>(_self.moderation!, (value) {
    return _then(_self.copyWith(moderation: value));
  });
}
}


/// Adds pattern-matching-related methods to [Hotel].
extension HotelPatterns on Hotel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hotel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hotel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hotel value)  $default,){
final _that = this;
switch (_that) {
case _Hotel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hotel value)?  $default,){
final _that = this;
switch (_that) {
case _Hotel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String name,  String description,  String city,  String district,  String address,  String country,  List<String> photos,  List<String> amenities,  int? stars,  String phone,  HotelRules rules, @JsonKey(includeToJson: false)  Money? minPricePerNight, @JsonKey(includeToJson: false)  int maxGuests, @JsonKey(includeToJson: false)  int roomTypesCount, @JsonKey(includeToJson: false)  bool featured,  ListingStatus status, @JsonKey(includeToJson: false)  ListingStats stats, @JsonKey(includeToJson: false)  Moderation? moderation, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? createdAt, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hotel() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.name,_that.description,_that.city,_that.district,_that.address,_that.country,_that.photos,_that.amenities,_that.stars,_that.phone,_that.rules,_that.minPricePerNight,_that.maxGuests,_that.roomTypesCount,_that.featured,_that.status,_that.stats,_that.moderation,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String name,  String description,  String city,  String district,  String address,  String country,  List<String> photos,  List<String> amenities,  int? stars,  String phone,  HotelRules rules, @JsonKey(includeToJson: false)  Money? minPricePerNight, @JsonKey(includeToJson: false)  int maxGuests, @JsonKey(includeToJson: false)  int roomTypesCount, @JsonKey(includeToJson: false)  bool featured,  ListingStatus status, @JsonKey(includeToJson: false)  ListingStats stats, @JsonKey(includeToJson: false)  Moderation? moderation, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? createdAt, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Hotel():
return $default(_that.id,_that.orgId,_that.orgName,_that.name,_that.description,_that.city,_that.district,_that.address,_that.country,_that.photos,_that.amenities,_that.stars,_that.phone,_that.rules,_that.minPricePerNight,_that.maxGuests,_that.roomTypesCount,_that.featured,_that.status,_that.stats,_that.moderation,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String name,  String description,  String city,  String district,  String address,  String country,  List<String> photos,  List<String> amenities,  int? stars,  String phone,  HotelRules rules, @JsonKey(includeToJson: false)  Money? minPricePerNight, @JsonKey(includeToJson: false)  int maxGuests, @JsonKey(includeToJson: false)  int roomTypesCount, @JsonKey(includeToJson: false)  bool featured,  ListingStatus status, @JsonKey(includeToJson: false)  ListingStats stats, @JsonKey(includeToJson: false)  Moderation? moderation, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? createdAt, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Hotel() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.name,_that.description,_that.city,_that.district,_that.address,_that.country,_that.photos,_that.amenities,_that.stars,_that.phone,_that.rules,_that.minPricePerNight,_that.maxGuests,_that.roomTypesCount,_that.featured,_that.status,_that.stats,_that.moderation,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hotel extends Hotel {
  const _Hotel({@JsonKey(includeToJson: false) this.id = '', required this.orgId, this.orgName, this.name = '', this.description = '', this.city = '', this.district = '', this.address = '', this.country = 'BF', final  List<String> photos = const [], final  List<String> amenities = const [], this.stars, this.phone = '', this.rules = const HotelRules(), @JsonKey(includeToJson: false) this.minPricePerNight, @JsonKey(includeToJson: false) this.maxGuests = 0, @JsonKey(includeToJson: false) this.roomTypesCount = 0, @JsonKey(includeToJson: false) this.featured = false, this.status = ListingStatus.draft, @JsonKey(includeToJson: false) this.stats = const ListingStats(), @JsonKey(includeToJson: false) this.moderation, @JsonKey(includeToJson: false)@TimestampConverter() this.createdAt, @JsonKey(includeToJson: false)@TimestampConverter() this.updatedAt}): _photos = photos,_amenities = amenities,super._();
  factory _Hotel.fromJson(Map<String, dynamic> json) => _$HotelFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String orgId;
@override final  String? orgName;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  String city;
@override@JsonKey() final  String district;
@override@JsonKey() final  String address;
@override@JsonKey() final  String country;
 final  List<String> _photos;
@override@JsonKey() List<String> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

 final  List<String> _amenities;
@override@JsonKey() List<String> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

@override final  int? stars;
@override@JsonKey() final  String phone;
@override@JsonKey() final  HotelRules rules;
@override@JsonKey(includeToJson: false) final  Money? minPricePerNight;
@override@JsonKey(includeToJson: false) final  int maxGuests;
@override@JsonKey(includeToJson: false) final  int roomTypesCount;
@override@JsonKey(includeToJson: false) final  bool featured;
@override@JsonKey() final  ListingStatus status;
@override@JsonKey(includeToJson: false) final  ListingStats stats;
@override@JsonKey(includeToJson: false) final  Moderation? moderation;
@override@JsonKey(includeToJson: false)@TimestampConverter() final  DateTime? createdAt;
@override@JsonKey(includeToJson: false)@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelCopyWith<_Hotel> get copyWith => __$HotelCopyWithImpl<_Hotel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hotel&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.country, country) || other.country == country)&&const DeepCollectionEquality().equals(other._photos, _photos)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.rules, rules) || other.rules == rules)&&(identical(other.minPricePerNight, minPricePerNight) || other.minPricePerNight == minPricePerNight)&&(identical(other.maxGuests, maxGuests) || other.maxGuests == maxGuests)&&(identical(other.roomTypesCount, roomTypesCount) || other.roomTypesCount == roomTypesCount)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.status, status) || other.status == status)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.moderation, moderation) || other.moderation == moderation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orgId,orgName,name,description,city,district,address,country,const DeepCollectionEquality().hash(_photos),const DeepCollectionEquality().hash(_amenities),stars,phone,rules,minPricePerNight,maxGuests,roomTypesCount,featured,status,stats,moderation,createdAt,updatedAt]);

@override
String toString() {
  return 'Hotel(id: $id, orgId: $orgId, orgName: $orgName, name: $name, description: $description, city: $city, district: $district, address: $address, country: $country, photos: $photos, amenities: $amenities, stars: $stars, phone: $phone, rules: $rules, minPricePerNight: $minPricePerNight, maxGuests: $maxGuests, roomTypesCount: $roomTypesCount, featured: $featured, status: $status, stats: $stats, moderation: $moderation, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$HotelCopyWith<$Res> implements $HotelCopyWith<$Res> {
  factory _$HotelCopyWith(_Hotel value, $Res Function(_Hotel) _then) = __$HotelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, String name, String description, String city, String district, String address, String country, List<String> photos, List<String> amenities, int? stars, String phone, HotelRules rules,@JsonKey(includeToJson: false) Money? minPricePerNight,@JsonKey(includeToJson: false) int maxGuests,@JsonKey(includeToJson: false) int roomTypesCount,@JsonKey(includeToJson: false) bool featured, ListingStatus status,@JsonKey(includeToJson: false) ListingStats stats,@JsonKey(includeToJson: false) Moderation? moderation,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? createdAt,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? updatedAt
});


@override $HotelRulesCopyWith<$Res> get rules;@override $ListingStatsCopyWith<$Res> get stats;@override $ModerationCopyWith<$Res>? get moderation;

}
/// @nodoc
class __$HotelCopyWithImpl<$Res>
    implements _$HotelCopyWith<$Res> {
  __$HotelCopyWithImpl(this._self, this._then);

  final _Hotel _self;
  final $Res Function(_Hotel) _then;

/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? name = null,Object? description = null,Object? city = null,Object? district = null,Object? address = null,Object? country = null,Object? photos = null,Object? amenities = null,Object? stars = freezed,Object? phone = null,Object? rules = null,Object? minPricePerNight = freezed,Object? maxGuests = null,Object? roomTypesCount = null,Object? featured = null,Object? status = null,Object? stats = null,Object? moderation = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Hotel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,stars: freezed == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as int?,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as HotelRules,minPricePerNight: freezed == minPricePerNight ? _self.minPricePerNight : minPricePerNight // ignore: cast_nullable_to_non_nullable
as Money?,maxGuests: null == maxGuests ? _self.maxGuests : maxGuests // ignore: cast_nullable_to_non_nullable
as int,roomTypesCount: null == roomTypesCount ? _self.roomTypesCount : roomTypesCount // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ListingStats,moderation: freezed == moderation ? _self.moderation : moderation // ignore: cast_nullable_to_non_nullable
as Moderation?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HotelRulesCopyWith<$Res> get rules {
  
  return $HotelRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingStatsCopyWith<$Res> get stats {
  
  return $ListingStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of Hotel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModerationCopyWith<$Res>? get moderation {
    if (_self.moderation == null) {
    return null;
  }

  return $ModerationCopyWith<$Res>(_self.moderation!, (value) {
    return _then(_self.copyWith(moderation: value));
  });
}
}


/// @nodoc
mixin _$RoomType {

@JsonKey(includeToJson: false) String get id; String get name; String get description; int get capacityAdults; int get capacityChildren; String get beds; Money get pricePerNight; int get quantity; List<String> get photos; List<String> get amenities; bool get active;
/// Create a copy of RoomType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomTypeCopyWith<RoomType> get copyWith => _$RoomTypeCopyWithImpl<RoomType>(this as RoomType, _$identity);

  /// Serializes this RoomType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.capacityAdults, capacityAdults) || other.capacityAdults == capacityAdults)&&(identical(other.capacityChildren, capacityChildren) || other.capacityChildren == capacityChildren)&&(identical(other.beds, beds) || other.beds == beds)&&(identical(other.pricePerNight, pricePerNight) || other.pricePerNight == pricePerNight)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other.photos, photos)&&const DeepCollectionEquality().equals(other.amenities, amenities)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,capacityAdults,capacityChildren,beds,pricePerNight,quantity,const DeepCollectionEquality().hash(photos),const DeepCollectionEquality().hash(amenities),active);

@override
String toString() {
  return 'RoomType(id: $id, name: $name, description: $description, capacityAdults: $capacityAdults, capacityChildren: $capacityChildren, beds: $beds, pricePerNight: $pricePerNight, quantity: $quantity, photos: $photos, amenities: $amenities, active: $active)';
}


}

/// @nodoc
abstract mixin class $RoomTypeCopyWith<$Res>  {
  factory $RoomTypeCopyWith(RoomType value, $Res Function(RoomType) _then) = _$RoomTypeCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, String description, int capacityAdults, int capacityChildren, String beds, Money pricePerNight, int quantity, List<String> photos, List<String> amenities, bool active
});




}
/// @nodoc
class _$RoomTypeCopyWithImpl<$Res>
    implements $RoomTypeCopyWith<$Res> {
  _$RoomTypeCopyWithImpl(this._self, this._then);

  final RoomType _self;
  final $Res Function(RoomType) _then;

/// Create a copy of RoomType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? capacityAdults = null,Object? capacityChildren = null,Object? beds = null,Object? pricePerNight = null,Object? quantity = null,Object? photos = null,Object? amenities = null,Object? active = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,capacityAdults: null == capacityAdults ? _self.capacityAdults : capacityAdults // ignore: cast_nullable_to_non_nullable
as int,capacityChildren: null == capacityChildren ? _self.capacityChildren : capacityChildren // ignore: cast_nullable_to_non_nullable
as int,beds: null == beds ? _self.beds : beds // ignore: cast_nullable_to_non_nullable
as String,pricePerNight: null == pricePerNight ? _self.pricePerNight : pricePerNight // ignore: cast_nullable_to_non_nullable
as Money,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self.amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomType].
extension RoomTypePatterns on RoomType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomType value)  $default,){
final _that = this;
switch (_that) {
case _RoomType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomType value)?  $default,){
final _that = this;
switch (_that) {
case _RoomType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  String description,  int capacityAdults,  int capacityChildren,  String beds,  Money pricePerNight,  int quantity,  List<String> photos,  List<String> amenities,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomType() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.capacityAdults,_that.capacityChildren,_that.beds,_that.pricePerNight,_that.quantity,_that.photos,_that.amenities,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  String description,  int capacityAdults,  int capacityChildren,  String beds,  Money pricePerNight,  int quantity,  List<String> photos,  List<String> amenities,  bool active)  $default,) {final _that = this;
switch (_that) {
case _RoomType():
return $default(_that.id,_that.name,_that.description,_that.capacityAdults,_that.capacityChildren,_that.beds,_that.pricePerNight,_that.quantity,_that.photos,_that.amenities,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String name,  String description,  int capacityAdults,  int capacityChildren,  String beds,  Money pricePerNight,  int quantity,  List<String> photos,  List<String> amenities,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _RoomType() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.capacityAdults,_that.capacityChildren,_that.beds,_that.pricePerNight,_that.quantity,_that.photos,_that.amenities,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomType extends RoomType {
  const _RoomType({@JsonKey(includeToJson: false) this.id = '', this.name = '', this.description = '', this.capacityAdults = 2, this.capacityChildren = 0, this.beds = '', this.pricePerNight = Money.zero, this.quantity = 1, final  List<String> photos = const [], final  List<String> amenities = const [], this.active = true}): _photos = photos,_amenities = amenities,super._();
  factory _RoomType.fromJson(Map<String, dynamic> json) => _$RoomTypeFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  int capacityAdults;
@override@JsonKey() final  int capacityChildren;
@override@JsonKey() final  String beds;
@override@JsonKey() final  Money pricePerNight;
@override@JsonKey() final  int quantity;
 final  List<String> _photos;
@override@JsonKey() List<String> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

 final  List<String> _amenities;
@override@JsonKey() List<String> get amenities {
  if (_amenities is EqualUnmodifiableListView) return _amenities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_amenities);
}

@override@JsonKey() final  bool active;

/// Create a copy of RoomType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomTypeCopyWith<_RoomType> get copyWith => __$RoomTypeCopyWithImpl<_RoomType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomType&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.capacityAdults, capacityAdults) || other.capacityAdults == capacityAdults)&&(identical(other.capacityChildren, capacityChildren) || other.capacityChildren == capacityChildren)&&(identical(other.beds, beds) || other.beds == beds)&&(identical(other.pricePerNight, pricePerNight) || other.pricePerNight == pricePerNight)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other._photos, _photos)&&const DeepCollectionEquality().equals(other._amenities, _amenities)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,capacityAdults,capacityChildren,beds,pricePerNight,quantity,const DeepCollectionEquality().hash(_photos),const DeepCollectionEquality().hash(_amenities),active);

@override
String toString() {
  return 'RoomType(id: $id, name: $name, description: $description, capacityAdults: $capacityAdults, capacityChildren: $capacityChildren, beds: $beds, pricePerNight: $pricePerNight, quantity: $quantity, photos: $photos, amenities: $amenities, active: $active)';
}


}

/// @nodoc
abstract mixin class _$RoomTypeCopyWith<$Res> implements $RoomTypeCopyWith<$Res> {
  factory _$RoomTypeCopyWith(_RoomType value, $Res Function(_RoomType) _then) = __$RoomTypeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, String description, int capacityAdults, int capacityChildren, String beds, Money pricePerNight, int quantity, List<String> photos, List<String> amenities, bool active
});




}
/// @nodoc
class __$RoomTypeCopyWithImpl<$Res>
    implements _$RoomTypeCopyWith<$Res> {
  __$RoomTypeCopyWithImpl(this._self, this._then);

  final _RoomType _self;
  final $Res Function(_RoomType) _then;

/// Create a copy of RoomType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? capacityAdults = null,Object? capacityChildren = null,Object? beds = null,Object? pricePerNight = null,Object? quantity = null,Object? photos = null,Object? amenities = null,Object? active = null,}) {
  return _then(_RoomType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,capacityAdults: null == capacityAdults ? _self.capacityAdults : capacityAdults // ignore: cast_nullable_to_non_nullable
as int,capacityChildren: null == capacityChildren ? _self.capacityChildren : capacityChildren // ignore: cast_nullable_to_non_nullable
as int,beds: null == beds ? _self.beds : beds // ignore: cast_nullable_to_non_nullable
as String,pricePerNight: null == pricePerNight ? _self.pricePerNight : pricePerNight // ignore: cast_nullable_to_non_nullable
as Money,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,amenities: null == amenities ? _self._amenities : amenities // ignore: cast_nullable_to_non_nullable
as List<String>,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$HotelOffer {

@JsonKey(includeToJson: false) String get id; String get title; String get description; int get discountPercent; List<String> get roomTypeIds;@TimestampConverter() DateTime? get validFrom;@TimestampConverter() DateTime? get validTo; bool get active;
/// Create a copy of HotelOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HotelOfferCopyWith<HotelOffer> get copyWith => _$HotelOfferCopyWithImpl<HotelOffer>(this as HotelOffer, _$identity);

  /// Serializes this HotelOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HotelOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&const DeepCollectionEquality().equals(other.roomTypeIds, roomTypeIds)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,discountPercent,const DeepCollectionEquality().hash(roomTypeIds),validFrom,validTo,active);

@override
String toString() {
  return 'HotelOffer(id: $id, title: $title, description: $description, discountPercent: $discountPercent, roomTypeIds: $roomTypeIds, validFrom: $validFrom, validTo: $validTo, active: $active)';
}


}

/// @nodoc
abstract mixin class $HotelOfferCopyWith<$Res>  {
  factory $HotelOfferCopyWith(HotelOffer value, $Res Function(HotelOffer) _then) = _$HotelOfferCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String title, String description, int discountPercent, List<String> roomTypeIds,@TimestampConverter() DateTime? validFrom,@TimestampConverter() DateTime? validTo, bool active
});




}
/// @nodoc
class _$HotelOfferCopyWithImpl<$Res>
    implements $HotelOfferCopyWith<$Res> {
  _$HotelOfferCopyWithImpl(this._self, this._then);

  final HotelOffer _self;
  final $Res Function(HotelOffer) _then;

/// Create a copy of HotelOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? discountPercent = null,Object? roomTypeIds = null,Object? validFrom = freezed,Object? validTo = freezed,Object? active = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int,roomTypeIds: null == roomTypeIds ? _self.roomTypeIds : roomTypeIds // ignore: cast_nullable_to_non_nullable
as List<String>,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HotelOffer].
extension HotelOfferPatterns on HotelOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HotelOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HotelOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HotelOffer value)  $default,){
final _that = this;
switch (_that) {
case _HotelOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HotelOffer value)?  $default,){
final _that = this;
switch (_that) {
case _HotelOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String title,  String description,  int discountPercent,  List<String> roomTypeIds, @TimestampConverter()  DateTime? validFrom, @TimestampConverter()  DateTime? validTo,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HotelOffer() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.discountPercent,_that.roomTypeIds,_that.validFrom,_that.validTo,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String title,  String description,  int discountPercent,  List<String> roomTypeIds, @TimestampConverter()  DateTime? validFrom, @TimestampConverter()  DateTime? validTo,  bool active)  $default,) {final _that = this;
switch (_that) {
case _HotelOffer():
return $default(_that.id,_that.title,_that.description,_that.discountPercent,_that.roomTypeIds,_that.validFrom,_that.validTo,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String title,  String description,  int discountPercent,  List<String> roomTypeIds, @TimestampConverter()  DateTime? validFrom, @TimestampConverter()  DateTime? validTo,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _HotelOffer() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.discountPercent,_that.roomTypeIds,_that.validFrom,_that.validTo,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HotelOffer extends HotelOffer {
  const _HotelOffer({@JsonKey(includeToJson: false) this.id = '', this.title = '', this.description = '', this.discountPercent = 0, final  List<String> roomTypeIds = const [], @TimestampConverter() this.validFrom, @TimestampConverter() this.validTo, this.active = true}): _roomTypeIds = roomTypeIds,super._();
  factory _HotelOffer.fromJson(Map<String, dynamic> json) => _$HotelOfferFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  int discountPercent;
 final  List<String> _roomTypeIds;
@override@JsonKey() List<String> get roomTypeIds {
  if (_roomTypeIds is EqualUnmodifiableListView) return _roomTypeIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roomTypeIds);
}

@override@TimestampConverter() final  DateTime? validFrom;
@override@TimestampConverter() final  DateTime? validTo;
@override@JsonKey() final  bool active;

/// Create a copy of HotelOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HotelOfferCopyWith<_HotelOffer> get copyWith => __$HotelOfferCopyWithImpl<_HotelOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HotelOfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HotelOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&const DeepCollectionEquality().equals(other._roomTypeIds, _roomTypeIds)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,discountPercent,const DeepCollectionEquality().hash(_roomTypeIds),validFrom,validTo,active);

@override
String toString() {
  return 'HotelOffer(id: $id, title: $title, description: $description, discountPercent: $discountPercent, roomTypeIds: $roomTypeIds, validFrom: $validFrom, validTo: $validTo, active: $active)';
}


}

/// @nodoc
abstract mixin class _$HotelOfferCopyWith<$Res> implements $HotelOfferCopyWith<$Res> {
  factory _$HotelOfferCopyWith(_HotelOffer value, $Res Function(_HotelOffer) _then) = __$HotelOfferCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String title, String description, int discountPercent, List<String> roomTypeIds,@TimestampConverter() DateTime? validFrom,@TimestampConverter() DateTime? validTo, bool active
});




}
/// @nodoc
class __$HotelOfferCopyWithImpl<$Res>
    implements _$HotelOfferCopyWith<$Res> {
  __$HotelOfferCopyWithImpl(this._self, this._then);

  final _HotelOffer _self;
  final $Res Function(_HotelOffer) _then;

/// Create a copy of HotelOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? discountPercent = null,Object? roomTypeIds = null,Object? validFrom = freezed,Object? validTo = freezed,Object? active = null,}) {
  return _then(_HotelOffer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int,roomTypeIds: null == roomTypeIds ? _self._roomTypeIds : roomTypeIds // ignore: cast_nullable_to_non_nullable
as List<String>,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PropertyConditions {

 String get deposit; String get advance; String get agencyFees;
/// Create a copy of PropertyConditions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyConditionsCopyWith<PropertyConditions> get copyWith => _$PropertyConditionsCopyWithImpl<PropertyConditions>(this as PropertyConditions, _$identity);

  /// Serializes this PropertyConditions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyConditions&&(identical(other.deposit, deposit) || other.deposit == deposit)&&(identical(other.advance, advance) || other.advance == advance)&&(identical(other.agencyFees, agencyFees) || other.agencyFees == agencyFees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deposit,advance,agencyFees);

@override
String toString() {
  return 'PropertyConditions(deposit: $deposit, advance: $advance, agencyFees: $agencyFees)';
}


}

/// @nodoc
abstract mixin class $PropertyConditionsCopyWith<$Res>  {
  factory $PropertyConditionsCopyWith(PropertyConditions value, $Res Function(PropertyConditions) _then) = _$PropertyConditionsCopyWithImpl;
@useResult
$Res call({
 String deposit, String advance, String agencyFees
});




}
/// @nodoc
class _$PropertyConditionsCopyWithImpl<$Res>
    implements $PropertyConditionsCopyWith<$Res> {
  _$PropertyConditionsCopyWithImpl(this._self, this._then);

  final PropertyConditions _self;
  final $Res Function(PropertyConditions) _then;

/// Create a copy of PropertyConditions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deposit = null,Object? advance = null,Object? agencyFees = null,}) {
  return _then(_self.copyWith(
deposit: null == deposit ? _self.deposit : deposit // ignore: cast_nullable_to_non_nullable
as String,advance: null == advance ? _self.advance : advance // ignore: cast_nullable_to_non_nullable
as String,agencyFees: null == agencyFees ? _self.agencyFees : agencyFees // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyConditions].
extension PropertyConditionsPatterns on PropertyConditions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyConditions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyConditions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyConditions value)  $default,){
final _that = this;
switch (_that) {
case _PropertyConditions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyConditions value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyConditions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deposit,  String advance,  String agencyFees)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyConditions() when $default != null:
return $default(_that.deposit,_that.advance,_that.agencyFees);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deposit,  String advance,  String agencyFees)  $default,) {final _that = this;
switch (_that) {
case _PropertyConditions():
return $default(_that.deposit,_that.advance,_that.agencyFees);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deposit,  String advance,  String agencyFees)?  $default,) {final _that = this;
switch (_that) {
case _PropertyConditions() when $default != null:
return $default(_that.deposit,_that.advance,_that.agencyFees);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PropertyConditions implements PropertyConditions {
  const _PropertyConditions({this.deposit = '', this.advance = '', this.agencyFees = ''});
  factory _PropertyConditions.fromJson(Map<String, dynamic> json) => _$PropertyConditionsFromJson(json);

@override@JsonKey() final  String deposit;
@override@JsonKey() final  String advance;
@override@JsonKey() final  String agencyFees;

/// Create a copy of PropertyConditions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyConditionsCopyWith<_PropertyConditions> get copyWith => __$PropertyConditionsCopyWithImpl<_PropertyConditions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyConditionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyConditions&&(identical(other.deposit, deposit) || other.deposit == deposit)&&(identical(other.advance, advance) || other.advance == advance)&&(identical(other.agencyFees, agencyFees) || other.agencyFees == agencyFees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deposit,advance,agencyFees);

@override
String toString() {
  return 'PropertyConditions(deposit: $deposit, advance: $advance, agencyFees: $agencyFees)';
}


}

/// @nodoc
abstract mixin class _$PropertyConditionsCopyWith<$Res> implements $PropertyConditionsCopyWith<$Res> {
  factory _$PropertyConditionsCopyWith(_PropertyConditions value, $Res Function(_PropertyConditions) _then) = __$PropertyConditionsCopyWithImpl;
@override @useResult
$Res call({
 String deposit, String advance, String agencyFees
});




}
/// @nodoc
class __$PropertyConditionsCopyWithImpl<$Res>
    implements _$PropertyConditionsCopyWith<$Res> {
  __$PropertyConditionsCopyWithImpl(this._self, this._then);

  final _PropertyConditions _self;
  final $Res Function(_PropertyConditions) _then;

/// Create a copy of PropertyConditions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deposit = null,Object? advance = null,Object? agencyFees = null,}) {
  return _then(_PropertyConditions(
deposit: null == deposit ? _self.deposit : deposit // ignore: cast_nullable_to_non_nullable
as String,advance: null == advance ? _self.advance : advance // ignore: cast_nullable_to_non_nullable
as String,agencyFees: null == agencyFees ? _self.agencyFees : agencyFees // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Property {

@JsonKey(includeToJson: false) String get id; String get orgId; String? get orgName; String? get orgType; TransactionType get transactionType; String get propertyType; String get title; String get description; String get city; String get district; String get address; String get country; Money get price; RentPeriod? get rentPeriod; int? get surface; int? get rooms; int? get bedrooms; int? get bathrooms; List<String> get features; PropertyConditions get conditions; List<String> get photos;@JsonKey(includeToJson: false) bool get featured; ListingStatus get status;@JsonKey(includeToJson: false) ListingStats get stats;@JsonKey(includeToJson: false) Moderation? get moderation;@JsonKey(includeToJson: false)@TimestampConverter() DateTime? get publishedAt;@JsonKey(includeToJson: false)@TimestampConverter() DateTime? get createdAt;@JsonKey(includeToJson: false)@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyCopyWith<Property> get copyWith => _$PropertyCopyWithImpl<Property>(this as Property, _$identity);

  /// Serializes this Property to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Property&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.orgType, orgType) || other.orgType == orgType)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.country, country) || other.country == country)&&(identical(other.price, price) || other.price == price)&&(identical(other.rentPeriod, rentPeriod) || other.rentPeriod == rentPeriod)&&(identical(other.surface, surface) || other.surface == surface)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&const DeepCollectionEquality().equals(other.features, features)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.status, status) || other.status == status)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.moderation, moderation) || other.moderation == moderation)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orgId,orgName,orgType,transactionType,propertyType,title,description,city,district,address,country,price,rentPeriod,surface,rooms,bedrooms,bathrooms,const DeepCollectionEquality().hash(features),conditions,const DeepCollectionEquality().hash(photos),featured,status,stats,moderation,publishedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'Property(id: $id, orgId: $orgId, orgName: $orgName, orgType: $orgType, transactionType: $transactionType, propertyType: $propertyType, title: $title, description: $description, city: $city, district: $district, address: $address, country: $country, price: $price, rentPeriod: $rentPeriod, surface: $surface, rooms: $rooms, bedrooms: $bedrooms, bathrooms: $bathrooms, features: $features, conditions: $conditions, photos: $photos, featured: $featured, status: $status, stats: $stats, moderation: $moderation, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PropertyCopyWith<$Res>  {
  factory $PropertyCopyWith(Property value, $Res Function(Property) _then) = _$PropertyCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, String? orgType, TransactionType transactionType, String propertyType, String title, String description, String city, String district, String address, String country, Money price, RentPeriod? rentPeriod, int? surface, int? rooms, int? bedrooms, int? bathrooms, List<String> features, PropertyConditions conditions, List<String> photos,@JsonKey(includeToJson: false) bool featured, ListingStatus status,@JsonKey(includeToJson: false) ListingStats stats,@JsonKey(includeToJson: false) Moderation? moderation,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? publishedAt,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? createdAt,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? updatedAt
});


$PropertyConditionsCopyWith<$Res> get conditions;$ListingStatsCopyWith<$Res> get stats;$ModerationCopyWith<$Res>? get moderation;

}
/// @nodoc
class _$PropertyCopyWithImpl<$Res>
    implements $PropertyCopyWith<$Res> {
  _$PropertyCopyWithImpl(this._self, this._then);

  final Property _self;
  final $Res Function(Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? orgType = freezed,Object? transactionType = null,Object? propertyType = null,Object? title = null,Object? description = null,Object? city = null,Object? district = null,Object? address = null,Object? country = null,Object? price = null,Object? rentPeriod = freezed,Object? surface = freezed,Object? rooms = freezed,Object? bedrooms = freezed,Object? bathrooms = freezed,Object? features = null,Object? conditions = null,Object? photos = null,Object? featured = null,Object? status = null,Object? stats = null,Object? moderation = freezed,Object? publishedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,orgType: freezed == orgType ? _self.orgType : orgType // ignore: cast_nullable_to_non_nullable
as String?,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as TransactionType,propertyType: null == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,rentPeriod: freezed == rentPeriod ? _self.rentPeriod : rentPeriod // ignore: cast_nullable_to_non_nullable
as RentPeriod?,surface: freezed == surface ? _self.surface : surface // ignore: cast_nullable_to_non_nullable
as int?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,bedrooms: freezed == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int?,bathrooms: freezed == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int?,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as PropertyConditions,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ListingStats,moderation: freezed == moderation ? _self.moderation : moderation // ignore: cast_nullable_to_non_nullable
as Moderation?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PropertyConditionsCopyWith<$Res> get conditions {
  
  return $PropertyConditionsCopyWith<$Res>(_self.conditions, (value) {
    return _then(_self.copyWith(conditions: value));
  });
}/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingStatsCopyWith<$Res> get stats {
  
  return $ListingStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModerationCopyWith<$Res>? get moderation {
    if (_self.moderation == null) {
    return null;
  }

  return $ModerationCopyWith<$Res>(_self.moderation!, (value) {
    return _then(_self.copyWith(moderation: value));
  });
}
}


/// Adds pattern-matching-related methods to [Property].
extension PropertyPatterns on Property {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Property value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Property() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Property value)  $default,){
final _that = this;
switch (_that) {
case _Property():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Property value)?  $default,){
final _that = this;
switch (_that) {
case _Property() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String? orgType,  TransactionType transactionType,  String propertyType,  String title,  String description,  String city,  String district,  String address,  String country,  Money price,  RentPeriod? rentPeriod,  int? surface,  int? rooms,  int? bedrooms,  int? bathrooms,  List<String> features,  PropertyConditions conditions,  List<String> photos, @JsonKey(includeToJson: false)  bool featured,  ListingStatus status, @JsonKey(includeToJson: false)  ListingStats stats, @JsonKey(includeToJson: false)  Moderation? moderation, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? publishedAt, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? createdAt, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.orgType,_that.transactionType,_that.propertyType,_that.title,_that.description,_that.city,_that.district,_that.address,_that.country,_that.price,_that.rentPeriod,_that.surface,_that.rooms,_that.bedrooms,_that.bathrooms,_that.features,_that.conditions,_that.photos,_that.featured,_that.status,_that.stats,_that.moderation,_that.publishedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String? orgType,  TransactionType transactionType,  String propertyType,  String title,  String description,  String city,  String district,  String address,  String country,  Money price,  RentPeriod? rentPeriod,  int? surface,  int? rooms,  int? bedrooms,  int? bathrooms,  List<String> features,  PropertyConditions conditions,  List<String> photos, @JsonKey(includeToJson: false)  bool featured,  ListingStatus status, @JsonKey(includeToJson: false)  ListingStats stats, @JsonKey(includeToJson: false)  Moderation? moderation, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? publishedAt, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? createdAt, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Property():
return $default(_that.id,_that.orgId,_that.orgName,_that.orgType,_that.transactionType,_that.propertyType,_that.title,_that.description,_that.city,_that.district,_that.address,_that.country,_that.price,_that.rentPeriod,_that.surface,_that.rooms,_that.bedrooms,_that.bathrooms,_that.features,_that.conditions,_that.photos,_that.featured,_that.status,_that.stats,_that.moderation,_that.publishedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String? orgType,  TransactionType transactionType,  String propertyType,  String title,  String description,  String city,  String district,  String address,  String country,  Money price,  RentPeriod? rentPeriod,  int? surface,  int? rooms,  int? bedrooms,  int? bathrooms,  List<String> features,  PropertyConditions conditions,  List<String> photos, @JsonKey(includeToJson: false)  bool featured,  ListingStatus status, @JsonKey(includeToJson: false)  ListingStats stats, @JsonKey(includeToJson: false)  Moderation? moderation, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? publishedAt, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? createdAt, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Property() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.orgType,_that.transactionType,_that.propertyType,_that.title,_that.description,_that.city,_that.district,_that.address,_that.country,_that.price,_that.rentPeriod,_that.surface,_that.rooms,_that.bedrooms,_that.bathrooms,_that.features,_that.conditions,_that.photos,_that.featured,_that.status,_that.stats,_that.moderation,_that.publishedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Property extends Property {
  const _Property({@JsonKey(includeToJson: false) this.id = '', required this.orgId, this.orgName, this.orgType, this.transactionType = TransactionType.rent, this.propertyType = '', this.title = '', this.description = '', this.city = '', this.district = '', this.address = '', this.country = 'BF', this.price = Money.zero, this.rentPeriod, this.surface, this.rooms, this.bedrooms, this.bathrooms, final  List<String> features = const [], this.conditions = const PropertyConditions(), final  List<String> photos = const [], @JsonKey(includeToJson: false) this.featured = false, this.status = ListingStatus.draft, @JsonKey(includeToJson: false) this.stats = const ListingStats(), @JsonKey(includeToJson: false) this.moderation, @JsonKey(includeToJson: false)@TimestampConverter() this.publishedAt, @JsonKey(includeToJson: false)@TimestampConverter() this.createdAt, @JsonKey(includeToJson: false)@TimestampConverter() this.updatedAt}): _features = features,_photos = photos,super._();
  factory _Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String orgId;
@override final  String? orgName;
@override final  String? orgType;
@override@JsonKey() final  TransactionType transactionType;
@override@JsonKey() final  String propertyType;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String city;
@override@JsonKey() final  String district;
@override@JsonKey() final  String address;
@override@JsonKey() final  String country;
@override@JsonKey() final  Money price;
@override final  RentPeriod? rentPeriod;
@override final  int? surface;
@override final  int? rooms;
@override final  int? bedrooms;
@override final  int? bathrooms;
 final  List<String> _features;
@override@JsonKey() List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

@override@JsonKey() final  PropertyConditions conditions;
 final  List<String> _photos;
@override@JsonKey() List<String> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override@JsonKey(includeToJson: false) final  bool featured;
@override@JsonKey() final  ListingStatus status;
@override@JsonKey(includeToJson: false) final  ListingStats stats;
@override@JsonKey(includeToJson: false) final  Moderation? moderation;
@override@JsonKey(includeToJson: false)@TimestampConverter() final  DateTime? publishedAt;
@override@JsonKey(includeToJson: false)@TimestampConverter() final  DateTime? createdAt;
@override@JsonKey(includeToJson: false)@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyCopyWith<_Property> get copyWith => __$PropertyCopyWithImpl<_Property>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Property&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.orgType, orgType) || other.orgType == orgType)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.country, country) || other.country == country)&&(identical(other.price, price) || other.price == price)&&(identical(other.rentPeriod, rentPeriod) || other.rentPeriod == rentPeriod)&&(identical(other.surface, surface) || other.surface == surface)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.bedrooms, bedrooms) || other.bedrooms == bedrooms)&&(identical(other.bathrooms, bathrooms) || other.bathrooms == bathrooms)&&const DeepCollectionEquality().equals(other._features, _features)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.status, status) || other.status == status)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.moderation, moderation) || other.moderation == moderation)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orgId,orgName,orgType,transactionType,propertyType,title,description,city,district,address,country,price,rentPeriod,surface,rooms,bedrooms,bathrooms,const DeepCollectionEquality().hash(_features),conditions,const DeepCollectionEquality().hash(_photos),featured,status,stats,moderation,publishedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'Property(id: $id, orgId: $orgId, orgName: $orgName, orgType: $orgType, transactionType: $transactionType, propertyType: $propertyType, title: $title, description: $description, city: $city, district: $district, address: $address, country: $country, price: $price, rentPeriod: $rentPeriod, surface: $surface, rooms: $rooms, bedrooms: $bedrooms, bathrooms: $bathrooms, features: $features, conditions: $conditions, photos: $photos, featured: $featured, status: $status, stats: $stats, moderation: $moderation, publishedAt: $publishedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PropertyCopyWith<$Res> implements $PropertyCopyWith<$Res> {
  factory _$PropertyCopyWith(_Property value, $Res Function(_Property) _then) = __$PropertyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, String? orgType, TransactionType transactionType, String propertyType, String title, String description, String city, String district, String address, String country, Money price, RentPeriod? rentPeriod, int? surface, int? rooms, int? bedrooms, int? bathrooms, List<String> features, PropertyConditions conditions, List<String> photos,@JsonKey(includeToJson: false) bool featured, ListingStatus status,@JsonKey(includeToJson: false) ListingStats stats,@JsonKey(includeToJson: false) Moderation? moderation,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? publishedAt,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? createdAt,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? updatedAt
});


@override $PropertyConditionsCopyWith<$Res> get conditions;@override $ListingStatsCopyWith<$Res> get stats;@override $ModerationCopyWith<$Res>? get moderation;

}
/// @nodoc
class __$PropertyCopyWithImpl<$Res>
    implements _$PropertyCopyWith<$Res> {
  __$PropertyCopyWithImpl(this._self, this._then);

  final _Property _self;
  final $Res Function(_Property) _then;

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? orgType = freezed,Object? transactionType = null,Object? propertyType = null,Object? title = null,Object? description = null,Object? city = null,Object? district = null,Object? address = null,Object? country = null,Object? price = null,Object? rentPeriod = freezed,Object? surface = freezed,Object? rooms = freezed,Object? bedrooms = freezed,Object? bathrooms = freezed,Object? features = null,Object? conditions = null,Object? photos = null,Object? featured = null,Object? status = null,Object? stats = null,Object? moderation = freezed,Object? publishedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Property(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,orgType: freezed == orgType ? _self.orgType : orgType // ignore: cast_nullable_to_non_nullable
as String?,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as TransactionType,propertyType: null == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,rentPeriod: freezed == rentPeriod ? _self.rentPeriod : rentPeriod // ignore: cast_nullable_to_non_nullable
as RentPeriod?,surface: freezed == surface ? _self.surface : surface // ignore: cast_nullable_to_non_nullable
as int?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,bedrooms: freezed == bedrooms ? _self.bedrooms : bedrooms // ignore: cast_nullable_to_non_nullable
as int?,bathrooms: freezed == bathrooms ? _self.bathrooms : bathrooms // ignore: cast_nullable_to_non_nullable
as int?,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as PropertyConditions,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ListingStats,moderation: freezed == moderation ? _self.moderation : moderation // ignore: cast_nullable_to_non_nullable
as Moderation?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PropertyConditionsCopyWith<$Res> get conditions {
  
  return $PropertyConditionsCopyWith<$Res>(_self.conditions, (value) {
    return _then(_self.copyWith(conditions: value));
  });
}/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingStatsCopyWith<$Res> get stats {
  
  return $ListingStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of Property
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModerationCopyWith<$Res>? get moderation {
    if (_self.moderation == null) {
    return null;
  }

  return $ModerationCopyWith<$Res>(_self.moderation!, (value) {
    return _then(_self.copyWith(moderation: value));
  });
}
}


/// @nodoc
mixin _$Project {

@JsonKey(includeToJson: false) String get id; String get orgId; String? get orgName; String get title; String get description; String get city; String get district; String get address; String get country; List<String> get photos; Money? get estimatedBudget; String get deliveryDate;@JsonKey(includeToJson: false) Money? get priceFrom;@JsonKey(includeToJson: false) int get unitsCount;@JsonKey(includeToJson: false) int get unitsAvailable;@JsonKey(includeToJson: false) bool get featured; ListingStatus get status;@JsonKey(includeToJson: false) ListingStats get stats;@JsonKey(includeToJson: false) Moderation? get moderation;@JsonKey(includeToJson: false)@TimestampConverter() DateTime? get createdAt;
/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectCopyWith<Project> get copyWith => _$ProjectCopyWithImpl<Project>(this as Project, _$identity);

  /// Serializes this Project to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Project&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.country, country) || other.country == country)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.estimatedBudget, estimatedBudget) || other.estimatedBudget == estimatedBudget)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.priceFrom, priceFrom) || other.priceFrom == priceFrom)&&(identical(other.unitsCount, unitsCount) || other.unitsCount == unitsCount)&&(identical(other.unitsAvailable, unitsAvailable) || other.unitsAvailable == unitsAvailable)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.status, status) || other.status == status)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.moderation, moderation) || other.moderation == moderation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orgId,orgName,title,description,city,district,address,country,const DeepCollectionEquality().hash(photos),estimatedBudget,deliveryDate,priceFrom,unitsCount,unitsAvailable,featured,status,stats,moderation,createdAt]);

@override
String toString() {
  return 'Project(id: $id, orgId: $orgId, orgName: $orgName, title: $title, description: $description, city: $city, district: $district, address: $address, country: $country, photos: $photos, estimatedBudget: $estimatedBudget, deliveryDate: $deliveryDate, priceFrom: $priceFrom, unitsCount: $unitsCount, unitsAvailable: $unitsAvailable, featured: $featured, status: $status, stats: $stats, moderation: $moderation, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ProjectCopyWith<$Res>  {
  factory $ProjectCopyWith(Project value, $Res Function(Project) _then) = _$ProjectCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, String title, String description, String city, String district, String address, String country, List<String> photos, Money? estimatedBudget, String deliveryDate,@JsonKey(includeToJson: false) Money? priceFrom,@JsonKey(includeToJson: false) int unitsCount,@JsonKey(includeToJson: false) int unitsAvailable,@JsonKey(includeToJson: false) bool featured, ListingStatus status,@JsonKey(includeToJson: false) ListingStats stats,@JsonKey(includeToJson: false) Moderation? moderation,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? createdAt
});


$ListingStatsCopyWith<$Res> get stats;$ModerationCopyWith<$Res>? get moderation;

}
/// @nodoc
class _$ProjectCopyWithImpl<$Res>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._self, this._then);

  final Project _self;
  final $Res Function(Project) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? title = null,Object? description = null,Object? city = null,Object? district = null,Object? address = null,Object? country = null,Object? photos = null,Object? estimatedBudget = freezed,Object? deliveryDate = null,Object? priceFrom = freezed,Object? unitsCount = null,Object? unitsAvailable = null,Object? featured = null,Object? status = null,Object? stats = null,Object? moderation = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,estimatedBudget: freezed == estimatedBudget ? _self.estimatedBudget : estimatedBudget // ignore: cast_nullable_to_non_nullable
as Money?,deliveryDate: null == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as String,priceFrom: freezed == priceFrom ? _self.priceFrom : priceFrom // ignore: cast_nullable_to_non_nullable
as Money?,unitsCount: null == unitsCount ? _self.unitsCount : unitsCount // ignore: cast_nullable_to_non_nullable
as int,unitsAvailable: null == unitsAvailable ? _self.unitsAvailable : unitsAvailable // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ListingStats,moderation: freezed == moderation ? _self.moderation : moderation // ignore: cast_nullable_to_non_nullable
as Moderation?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingStatsCopyWith<$Res> get stats {
  
  return $ListingStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModerationCopyWith<$Res>? get moderation {
    if (_self.moderation == null) {
    return null;
  }

  return $ModerationCopyWith<$Res>(_self.moderation!, (value) {
    return _then(_self.copyWith(moderation: value));
  });
}
}


/// Adds pattern-matching-related methods to [Project].
extension ProjectPatterns on Project {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Project value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Project() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Project value)  $default,){
final _that = this;
switch (_that) {
case _Project():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Project value)?  $default,){
final _that = this;
switch (_that) {
case _Project() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String title,  String description,  String city,  String district,  String address,  String country,  List<String> photos,  Money? estimatedBudget,  String deliveryDate, @JsonKey(includeToJson: false)  Money? priceFrom, @JsonKey(includeToJson: false)  int unitsCount, @JsonKey(includeToJson: false)  int unitsAvailable, @JsonKey(includeToJson: false)  bool featured,  ListingStatus status, @JsonKey(includeToJson: false)  ListingStats stats, @JsonKey(includeToJson: false)  Moderation? moderation, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Project() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.title,_that.description,_that.city,_that.district,_that.address,_that.country,_that.photos,_that.estimatedBudget,_that.deliveryDate,_that.priceFrom,_that.unitsCount,_that.unitsAvailable,_that.featured,_that.status,_that.stats,_that.moderation,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String title,  String description,  String city,  String district,  String address,  String country,  List<String> photos,  Money? estimatedBudget,  String deliveryDate, @JsonKey(includeToJson: false)  Money? priceFrom, @JsonKey(includeToJson: false)  int unitsCount, @JsonKey(includeToJson: false)  int unitsAvailable, @JsonKey(includeToJson: false)  bool featured,  ListingStatus status, @JsonKey(includeToJson: false)  ListingStats stats, @JsonKey(includeToJson: false)  Moderation? moderation, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Project():
return $default(_that.id,_that.orgId,_that.orgName,_that.title,_that.description,_that.city,_that.district,_that.address,_that.country,_that.photos,_that.estimatedBudget,_that.deliveryDate,_that.priceFrom,_that.unitsCount,_that.unitsAvailable,_that.featured,_that.status,_that.stats,_that.moderation,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String title,  String description,  String city,  String district,  String address,  String country,  List<String> photos,  Money? estimatedBudget,  String deliveryDate, @JsonKey(includeToJson: false)  Money? priceFrom, @JsonKey(includeToJson: false)  int unitsCount, @JsonKey(includeToJson: false)  int unitsAvailable, @JsonKey(includeToJson: false)  bool featured,  ListingStatus status, @JsonKey(includeToJson: false)  ListingStats stats, @JsonKey(includeToJson: false)  Moderation? moderation, @JsonKey(includeToJson: false)@TimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Project() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.title,_that.description,_that.city,_that.district,_that.address,_that.country,_that.photos,_that.estimatedBudget,_that.deliveryDate,_that.priceFrom,_that.unitsCount,_that.unitsAvailable,_that.featured,_that.status,_that.stats,_that.moderation,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Project extends Project {
  const _Project({@JsonKey(includeToJson: false) this.id = '', required this.orgId, this.orgName, this.title = '', this.description = '', this.city = '', this.district = '', this.address = '', this.country = 'BF', final  List<String> photos = const [], this.estimatedBudget, this.deliveryDate = '', @JsonKey(includeToJson: false) this.priceFrom, @JsonKey(includeToJson: false) this.unitsCount = 0, @JsonKey(includeToJson: false) this.unitsAvailable = 0, @JsonKey(includeToJson: false) this.featured = false, this.status = ListingStatus.draft, @JsonKey(includeToJson: false) this.stats = const ListingStats(), @JsonKey(includeToJson: false) this.moderation, @JsonKey(includeToJson: false)@TimestampConverter() this.createdAt}): _photos = photos,super._();
  factory _Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String orgId;
@override final  String? orgName;
@override@JsonKey() final  String title;
@override@JsonKey() final  String description;
@override@JsonKey() final  String city;
@override@JsonKey() final  String district;
@override@JsonKey() final  String address;
@override@JsonKey() final  String country;
 final  List<String> _photos;
@override@JsonKey() List<String> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  Money? estimatedBudget;
@override@JsonKey() final  String deliveryDate;
@override@JsonKey(includeToJson: false) final  Money? priceFrom;
@override@JsonKey(includeToJson: false) final  int unitsCount;
@override@JsonKey(includeToJson: false) final  int unitsAvailable;
@override@JsonKey(includeToJson: false) final  bool featured;
@override@JsonKey() final  ListingStatus status;
@override@JsonKey(includeToJson: false) final  ListingStats stats;
@override@JsonKey(includeToJson: false) final  Moderation? moderation;
@override@JsonKey(includeToJson: false)@TimestampConverter() final  DateTime? createdAt;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectCopyWith<_Project> get copyWith => __$ProjectCopyWithImpl<_Project>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Project&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.address, address) || other.address == address)&&(identical(other.country, country) || other.country == country)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.estimatedBudget, estimatedBudget) || other.estimatedBudget == estimatedBudget)&&(identical(other.deliveryDate, deliveryDate) || other.deliveryDate == deliveryDate)&&(identical(other.priceFrom, priceFrom) || other.priceFrom == priceFrom)&&(identical(other.unitsCount, unitsCount) || other.unitsCount == unitsCount)&&(identical(other.unitsAvailable, unitsAvailable) || other.unitsAvailable == unitsAvailable)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.status, status) || other.status == status)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.moderation, moderation) || other.moderation == moderation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orgId,orgName,title,description,city,district,address,country,const DeepCollectionEquality().hash(_photos),estimatedBudget,deliveryDate,priceFrom,unitsCount,unitsAvailable,featured,status,stats,moderation,createdAt]);

@override
String toString() {
  return 'Project(id: $id, orgId: $orgId, orgName: $orgName, title: $title, description: $description, city: $city, district: $district, address: $address, country: $country, photos: $photos, estimatedBudget: $estimatedBudget, deliveryDate: $deliveryDate, priceFrom: $priceFrom, unitsCount: $unitsCount, unitsAvailable: $unitsAvailable, featured: $featured, status: $status, stats: $stats, moderation: $moderation, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ProjectCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$ProjectCopyWith(_Project value, $Res Function(_Project) _then) = __$ProjectCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, String title, String description, String city, String district, String address, String country, List<String> photos, Money? estimatedBudget, String deliveryDate,@JsonKey(includeToJson: false) Money? priceFrom,@JsonKey(includeToJson: false) int unitsCount,@JsonKey(includeToJson: false) int unitsAvailable,@JsonKey(includeToJson: false) bool featured, ListingStatus status,@JsonKey(includeToJson: false) ListingStats stats,@JsonKey(includeToJson: false) Moderation? moderation,@JsonKey(includeToJson: false)@TimestampConverter() DateTime? createdAt
});


@override $ListingStatsCopyWith<$Res> get stats;@override $ModerationCopyWith<$Res>? get moderation;

}
/// @nodoc
class __$ProjectCopyWithImpl<$Res>
    implements _$ProjectCopyWith<$Res> {
  __$ProjectCopyWithImpl(this._self, this._then);

  final _Project _self;
  final $Res Function(_Project) _then;

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? title = null,Object? description = null,Object? city = null,Object? district = null,Object? address = null,Object? country = null,Object? photos = null,Object? estimatedBudget = freezed,Object? deliveryDate = null,Object? priceFrom = freezed,Object? unitsCount = null,Object? unitsAvailable = null,Object? featured = null,Object? status = null,Object? stats = null,Object? moderation = freezed,Object? createdAt = freezed,}) {
  return _then(_Project(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,estimatedBudget: freezed == estimatedBudget ? _self.estimatedBudget : estimatedBudget // ignore: cast_nullable_to_non_nullable
as Money?,deliveryDate: null == deliveryDate ? _self.deliveryDate : deliveryDate // ignore: cast_nullable_to_non_nullable
as String,priceFrom: freezed == priceFrom ? _self.priceFrom : priceFrom // ignore: cast_nullable_to_non_nullable
as Money?,unitsCount: null == unitsCount ? _self.unitsCount : unitsCount // ignore: cast_nullable_to_non_nullable
as int,unitsAvailable: null == unitsAvailable ? _self.unitsAvailable : unitsAvailable // ignore: cast_nullable_to_non_nullable
as int,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as ListingStats,moderation: freezed == moderation ? _self.moderation : moderation // ignore: cast_nullable_to_non_nullable
as Moderation?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingStatsCopyWith<$Res> get stats {
  
  return $ListingStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of Project
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModerationCopyWith<$Res>? get moderation {
    if (_self.moderation == null) {
    return null;
  }

  return $ModerationCopyWith<$Res>(_self.moderation!, (value) {
    return _then(_self.copyWith(moderation: value));
  });
}
}


/// @nodoc
mixin _$ProjectUnit {

@JsonKey(includeToJson: false) String get id; String get label; String get propertyType; int? get surface; int? get rooms; Money get price; UnitStatus get status;
/// Create a copy of ProjectUnit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectUnitCopyWith<ProjectUnit> get copyWith => _$ProjectUnitCopyWithImpl<ProjectUnit>(this as ProjectUnit, _$identity);

  /// Serializes this ProjectUnit to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.surface, surface) || other.surface == surface)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,propertyType,surface,rooms,price,status);

@override
String toString() {
  return 'ProjectUnit(id: $id, label: $label, propertyType: $propertyType, surface: $surface, rooms: $rooms, price: $price, status: $status)';
}


}

/// @nodoc
abstract mixin class $ProjectUnitCopyWith<$Res>  {
  factory $ProjectUnitCopyWith(ProjectUnit value, $Res Function(ProjectUnit) _then) = _$ProjectUnitCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String label, String propertyType, int? surface, int? rooms, Money price, UnitStatus status
});




}
/// @nodoc
class _$ProjectUnitCopyWithImpl<$Res>
    implements $ProjectUnitCopyWith<$Res> {
  _$ProjectUnitCopyWithImpl(this._self, this._then);

  final ProjectUnit _self;
  final $Res Function(ProjectUnit) _then;

/// Create a copy of ProjectUnit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? propertyType = null,Object? surface = freezed,Object? rooms = freezed,Object? price = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,propertyType: null == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as String,surface: freezed == surface ? _self.surface : surface // ignore: cast_nullable_to_non_nullable
as int?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnitStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectUnit].
extension ProjectUnitPatterns on ProjectUnit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectUnit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectUnit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectUnit value)  $default,){
final _that = this;
switch (_that) {
case _ProjectUnit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectUnit value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectUnit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String label,  String propertyType,  int? surface,  int? rooms,  Money price,  UnitStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectUnit() when $default != null:
return $default(_that.id,_that.label,_that.propertyType,_that.surface,_that.rooms,_that.price,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String label,  String propertyType,  int? surface,  int? rooms,  Money price,  UnitStatus status)  $default,) {final _that = this;
switch (_that) {
case _ProjectUnit():
return $default(_that.id,_that.label,_that.propertyType,_that.surface,_that.rooms,_that.price,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String label,  String propertyType,  int? surface,  int? rooms,  Money price,  UnitStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ProjectUnit() when $default != null:
return $default(_that.id,_that.label,_that.propertyType,_that.surface,_that.rooms,_that.price,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectUnit implements ProjectUnit {
  const _ProjectUnit({@JsonKey(includeToJson: false) this.id = '', this.label = '', this.propertyType = '', this.surface, this.rooms, this.price = Money.zero, this.status = UnitStatus.available});
  factory _ProjectUnit.fromJson(Map<String, dynamic> json) => _$ProjectUnitFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey() final  String label;
@override@JsonKey() final  String propertyType;
@override final  int? surface;
@override final  int? rooms;
@override@JsonKey() final  Money price;
@override@JsonKey() final  UnitStatus status;

/// Create a copy of ProjectUnit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectUnitCopyWith<_ProjectUnit> get copyWith => __$ProjectUnitCopyWithImpl<_ProjectUnit>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectUnitToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectUnit&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.propertyType, propertyType) || other.propertyType == propertyType)&&(identical(other.surface, surface) || other.surface == surface)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,label,propertyType,surface,rooms,price,status);

@override
String toString() {
  return 'ProjectUnit(id: $id, label: $label, propertyType: $propertyType, surface: $surface, rooms: $rooms, price: $price, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ProjectUnitCopyWith<$Res> implements $ProjectUnitCopyWith<$Res> {
  factory _$ProjectUnitCopyWith(_ProjectUnit value, $Res Function(_ProjectUnit) _then) = __$ProjectUnitCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String label, String propertyType, int? surface, int? rooms, Money price, UnitStatus status
});




}
/// @nodoc
class __$ProjectUnitCopyWithImpl<$Res>
    implements _$ProjectUnitCopyWith<$Res> {
  __$ProjectUnitCopyWithImpl(this._self, this._then);

  final _ProjectUnit _self;
  final $Res Function(_ProjectUnit) _then;

/// Create a copy of ProjectUnit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? propertyType = null,Object? surface = freezed,Object? rooms = freezed,Object? price = null,Object? status = null,}) {
  return _then(_ProjectUnit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,propertyType: null == propertyType ? _self.propertyType : propertyType // ignore: cast_nullable_to_non_nullable
as String,surface: freezed == surface ? _self.surface : surface // ignore: cast_nullable_to_non_nullable
as int?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UnitStatus,
  ));
}


}


/// @nodoc
mixin _$Favorite {

@JsonKey(includeToJson: false) String get id; ListingKind get targetType; String get title; String? get photo; String? get city; Money? get price;@TimestampConverter() DateTime? get addedAt;
/// Create a copy of Favorite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteCopyWith<Favorite> get copyWith => _$FavoriteCopyWithImpl<Favorite>(this as Favorite, _$identity);

  /// Serializes this Favorite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Favorite&&(identical(other.id, id) || other.id == id)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.title, title) || other.title == title)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.city, city) || other.city == city)&&(identical(other.price, price) || other.price == price)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,targetType,title,photo,city,price,addedAt);

@override
String toString() {
  return 'Favorite(id: $id, targetType: $targetType, title: $title, photo: $photo, city: $city, price: $price, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $FavoriteCopyWith<$Res>  {
  factory $FavoriteCopyWith(Favorite value, $Res Function(Favorite) _then) = _$FavoriteCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, ListingKind targetType, String title, String? photo, String? city, Money? price,@TimestampConverter() DateTime? addedAt
});




}
/// @nodoc
class _$FavoriteCopyWithImpl<$Res>
    implements $FavoriteCopyWith<$Res> {
  _$FavoriteCopyWithImpl(this._self, this._then);

  final Favorite _self;
  final $Res Function(Favorite) _then;

/// Create a copy of Favorite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? targetType = null,Object? title = null,Object? photo = freezed,Object? city = freezed,Object? price = freezed,Object? addedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as ListingKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Favorite].
extension FavoritePatterns on Favorite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Favorite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Favorite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Favorite value)  $default,){
final _that = this;
switch (_that) {
case _Favorite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Favorite value)?  $default,){
final _that = this;
switch (_that) {
case _Favorite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  ListingKind targetType,  String title,  String? photo,  String? city,  Money? price, @TimestampConverter()  DateTime? addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Favorite() when $default != null:
return $default(_that.id,_that.targetType,_that.title,_that.photo,_that.city,_that.price,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  ListingKind targetType,  String title,  String? photo,  String? city,  Money? price, @TimestampConverter()  DateTime? addedAt)  $default,) {final _that = this;
switch (_that) {
case _Favorite():
return $default(_that.id,_that.targetType,_that.title,_that.photo,_that.city,_that.price,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  ListingKind targetType,  String title,  String? photo,  String? city,  Money? price, @TimestampConverter()  DateTime? addedAt)?  $default,) {final _that = this;
switch (_that) {
case _Favorite() when $default != null:
return $default(_that.id,_that.targetType,_that.title,_that.photo,_that.city,_that.price,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Favorite implements Favorite {
  const _Favorite({@JsonKey(includeToJson: false) this.id = '', required this.targetType, this.title = '', this.photo, this.city, this.price, @TimestampConverter() this.addedAt});
  factory _Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  ListingKind targetType;
@override@JsonKey() final  String title;
@override final  String? photo;
@override final  String? city;
@override final  Money? price;
@override@TimestampConverter() final  DateTime? addedAt;

/// Create a copy of Favorite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteCopyWith<_Favorite> get copyWith => __$FavoriteCopyWithImpl<_Favorite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Favorite&&(identical(other.id, id) || other.id == id)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.title, title) || other.title == title)&&(identical(other.photo, photo) || other.photo == photo)&&(identical(other.city, city) || other.city == city)&&(identical(other.price, price) || other.price == price)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,targetType,title,photo,city,price,addedAt);

@override
String toString() {
  return 'Favorite(id: $id, targetType: $targetType, title: $title, photo: $photo, city: $city, price: $price, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteCopyWith<$Res> implements $FavoriteCopyWith<$Res> {
  factory _$FavoriteCopyWith(_Favorite value, $Res Function(_Favorite) _then) = __$FavoriteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, ListingKind targetType, String title, String? photo, String? city, Money? price,@TimestampConverter() DateTime? addedAt
});




}
/// @nodoc
class __$FavoriteCopyWithImpl<$Res>
    implements _$FavoriteCopyWith<$Res> {
  __$FavoriteCopyWithImpl(this._self, this._then);

  final _Favorite _self;
  final $Res Function(_Favorite) _then;

/// Create a copy of Favorite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? targetType = null,Object? title = null,Object? photo = freezed,Object? city = freezed,Object? price = freezed,Object? addedAt = freezed,}) {
  return _then(_Favorite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as ListingKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,photo: freezed == photo ? _self.photo : photo // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
