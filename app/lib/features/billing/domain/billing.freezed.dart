// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlanFeatures {

/// Annonces publiées en même temps ; null = illimité.
 int? get maxListings; int get featuredListings; bool get advancedStats;
/// Create a copy of PlanFeatures
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanFeaturesCopyWith<PlanFeatures> get copyWith => _$PlanFeaturesCopyWithImpl<PlanFeatures>(this as PlanFeatures, _$identity);

  /// Serializes this PlanFeatures to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanFeatures&&(identical(other.maxListings, maxListings) || other.maxListings == maxListings)&&(identical(other.featuredListings, featuredListings) || other.featuredListings == featuredListings)&&(identical(other.advancedStats, advancedStats) || other.advancedStats == advancedStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxListings,featuredListings,advancedStats);

@override
String toString() {
  return 'PlanFeatures(maxListings: $maxListings, featuredListings: $featuredListings, advancedStats: $advancedStats)';
}


}

/// @nodoc
abstract mixin class $PlanFeaturesCopyWith<$Res>  {
  factory $PlanFeaturesCopyWith(PlanFeatures value, $Res Function(PlanFeatures) _then) = _$PlanFeaturesCopyWithImpl;
@useResult
$Res call({
 int? maxListings, int featuredListings, bool advancedStats
});




}
/// @nodoc
class _$PlanFeaturesCopyWithImpl<$Res>
    implements $PlanFeaturesCopyWith<$Res> {
  _$PlanFeaturesCopyWithImpl(this._self, this._then);

  final PlanFeatures _self;
  final $Res Function(PlanFeatures) _then;

/// Create a copy of PlanFeatures
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxListings = freezed,Object? featuredListings = null,Object? advancedStats = null,}) {
  return _then(_self.copyWith(
maxListings: freezed == maxListings ? _self.maxListings : maxListings // ignore: cast_nullable_to_non_nullable
as int?,featuredListings: null == featuredListings ? _self.featuredListings : featuredListings // ignore: cast_nullable_to_non_nullable
as int,advancedStats: null == advancedStats ? _self.advancedStats : advancedStats // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanFeatures].
extension PlanFeaturesPatterns on PlanFeatures {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanFeatures value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanFeatures() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanFeatures value)  $default,){
final _that = this;
switch (_that) {
case _PlanFeatures():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanFeatures value)?  $default,){
final _that = this;
switch (_that) {
case _PlanFeatures() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? maxListings,  int featuredListings,  bool advancedStats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanFeatures() when $default != null:
return $default(_that.maxListings,_that.featuredListings,_that.advancedStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? maxListings,  int featuredListings,  bool advancedStats)  $default,) {final _that = this;
switch (_that) {
case _PlanFeatures():
return $default(_that.maxListings,_that.featuredListings,_that.advancedStats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? maxListings,  int featuredListings,  bool advancedStats)?  $default,) {final _that = this;
switch (_that) {
case _PlanFeatures() when $default != null:
return $default(_that.maxListings,_that.featuredListings,_that.advancedStats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanFeatures implements PlanFeatures {
  const _PlanFeatures({this.maxListings, this.featuredListings = 0, this.advancedStats = false});
  factory _PlanFeatures.fromJson(Map<String, dynamic> json) => _$PlanFeaturesFromJson(json);

/// Annonces publiées en même temps ; null = illimité.
@override final  int? maxListings;
@override@JsonKey() final  int featuredListings;
@override@JsonKey() final  bool advancedStats;

/// Create a copy of PlanFeatures
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanFeaturesCopyWith<_PlanFeatures> get copyWith => __$PlanFeaturesCopyWithImpl<_PlanFeatures>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanFeaturesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanFeatures&&(identical(other.maxListings, maxListings) || other.maxListings == maxListings)&&(identical(other.featuredListings, featuredListings) || other.featuredListings == featuredListings)&&(identical(other.advancedStats, advancedStats) || other.advancedStats == advancedStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxListings,featuredListings,advancedStats);

@override
String toString() {
  return 'PlanFeatures(maxListings: $maxListings, featuredListings: $featuredListings, advancedStats: $advancedStats)';
}


}

/// @nodoc
abstract mixin class _$PlanFeaturesCopyWith<$Res> implements $PlanFeaturesCopyWith<$Res> {
  factory _$PlanFeaturesCopyWith(_PlanFeatures value, $Res Function(_PlanFeatures) _then) = __$PlanFeaturesCopyWithImpl;
@override @useResult
$Res call({
 int? maxListings, int featuredListings, bool advancedStats
});




}
/// @nodoc
class __$PlanFeaturesCopyWithImpl<$Res>
    implements _$PlanFeaturesCopyWith<$Res> {
  __$PlanFeaturesCopyWithImpl(this._self, this._then);

  final _PlanFeatures _self;
  final $Res Function(_PlanFeatures) _then;

/// Create a copy of PlanFeatures
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxListings = freezed,Object? featuredListings = null,Object? advancedStats = null,}) {
  return _then(_PlanFeatures(
maxListings: freezed == maxListings ? _self.maxListings : maxListings // ignore: cast_nullable_to_non_nullable
as int?,featuredListings: null == featuredListings ? _self.featuredListings : featuredListings // ignore: cast_nullable_to_non_nullable
as int,advancedStats: null == advancedStats ? _self.advancedStats : advancedStats // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SubscriptionPlan {

@JsonKey(includeToJson: false) String get id; String get name; String get description; Money get price; PlanPeriod get period; PlanTarget get target; PlanFeatures get features; bool get active;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of SubscriptionPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionPlanCopyWith<SubscriptionPlan> get copyWith => _$SubscriptionPlanCopyWithImpl<SubscriptionPlan>(this as SubscriptionPlan, _$identity);

  /// Serializes this SubscriptionPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.period, period) || other.period == period)&&(identical(other.target, target) || other.target == target)&&(identical(other.features, features) || other.features == features)&&(identical(other.active, active) || other.active == active)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,period,target,features,active,updatedAt);

@override
String toString() {
  return 'SubscriptionPlan(id: $id, name: $name, description: $description, price: $price, period: $period, target: $target, features: $features, active: $active, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SubscriptionPlanCopyWith<$Res>  {
  factory $SubscriptionPlanCopyWith(SubscriptionPlan value, $Res Function(SubscriptionPlan) _then) = _$SubscriptionPlanCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, String description, Money price, PlanPeriod period, PlanTarget target, PlanFeatures features, bool active,@TimestampConverter() DateTime? updatedAt
});


$PlanFeaturesCopyWith<$Res> get features;

}
/// @nodoc
class _$SubscriptionPlanCopyWithImpl<$Res>
    implements $SubscriptionPlanCopyWith<$Res> {
  _$SubscriptionPlanCopyWithImpl(this._self, this._then);

  final SubscriptionPlan _self;
  final $Res Function(SubscriptionPlan) _then;

/// Create a copy of SubscriptionPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? price = null,Object? period = null,Object? target = null,Object? features = null,Object? active = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as PlanPeriod,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as PlanTarget,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as PlanFeatures,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of SubscriptionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanFeaturesCopyWith<$Res> get features {
  
  return $PlanFeaturesCopyWith<$Res>(_self.features, (value) {
    return _then(_self.copyWith(features: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubscriptionPlan].
extension SubscriptionPlanPatterns on SubscriptionPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionPlan value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionPlan value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  String description,  Money price,  PlanPeriod period,  PlanTarget target,  PlanFeatures features,  bool active, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionPlan() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.period,_that.target,_that.features,_that.active,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String name,  String description,  Money price,  PlanPeriod period,  PlanTarget target,  PlanFeatures features,  bool active, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionPlan():
return $default(_that.id,_that.name,_that.description,_that.price,_that.period,_that.target,_that.features,_that.active,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String name,  String description,  Money price,  PlanPeriod period,  PlanTarget target,  PlanFeatures features,  bool active, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionPlan() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.price,_that.period,_that.target,_that.features,_that.active,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubscriptionPlan extends SubscriptionPlan {
  const _SubscriptionPlan({@JsonKey(includeToJson: false) this.id = '', required this.name, this.description = '', this.price = Money.zero, this.period = PlanPeriod.month, this.target = PlanTarget.all, this.features = const PlanFeatures(), this.active = true, @TimestampConverter() this.updatedAt}): super._();
  factory _SubscriptionPlan.fromJson(Map<String, dynamic> json) => _$SubscriptionPlanFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  Money price;
@override@JsonKey() final  PlanPeriod period;
@override@JsonKey() final  PlanTarget target;
@override@JsonKey() final  PlanFeatures features;
@override@JsonKey() final  bool active;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of SubscriptionPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionPlanCopyWith<_SubscriptionPlan> get copyWith => __$SubscriptionPlanCopyWithImpl<_SubscriptionPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionPlanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionPlan&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.price, price) || other.price == price)&&(identical(other.period, period) || other.period == period)&&(identical(other.target, target) || other.target == target)&&(identical(other.features, features) || other.features == features)&&(identical(other.active, active) || other.active == active)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,price,period,target,features,active,updatedAt);

@override
String toString() {
  return 'SubscriptionPlan(id: $id, name: $name, description: $description, price: $price, period: $period, target: $target, features: $features, active: $active, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionPlanCopyWith<$Res> implements $SubscriptionPlanCopyWith<$Res> {
  factory _$SubscriptionPlanCopyWith(_SubscriptionPlan value, $Res Function(_SubscriptionPlan) _then) = __$SubscriptionPlanCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String name, String description, Money price, PlanPeriod period, PlanTarget target, PlanFeatures features, bool active,@TimestampConverter() DateTime? updatedAt
});


@override $PlanFeaturesCopyWith<$Res> get features;

}
/// @nodoc
class __$SubscriptionPlanCopyWithImpl<$Res>
    implements _$SubscriptionPlanCopyWith<$Res> {
  __$SubscriptionPlanCopyWithImpl(this._self, this._then);

  final _SubscriptionPlan _self;
  final $Res Function(_SubscriptionPlan) _then;

/// Create a copy of SubscriptionPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? price = null,Object? period = null,Object? target = null,Object? features = null,Object? active = null,Object? updatedAt = freezed,}) {
  return _then(_SubscriptionPlan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as PlanPeriod,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as PlanTarget,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as PlanFeatures,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of SubscriptionPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanFeaturesCopyWith<$Res> get features {
  
  return $PlanFeaturesCopyWith<$Res>(_self.features, (value) {
    return _then(_self.copyWith(features: value));
  });
}
}


/// @nodoc
mixin _$Subscription {

@JsonKey(includeToJson: false) String get id; String get orgId; String? get orgName; String get planId; SubscriptionPlan get planSnapshot; SubscriptionStatus get status;@TimestampConverter() DateTime? get currentPeriodStart;@TimestampConverter() DateTime? get currentPeriodEnd; String? get lastPaymentId;@TimestampConverter() DateTime? get createdAt;
/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<Subscription> get copyWith => _$SubscriptionCopyWithImpl<Subscription>(this as Subscription, _$identity);

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subscription&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.planSnapshot, planSnapshot) || other.planSnapshot == planSnapshot)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentPeriodStart, currentPeriodStart) || other.currentPeriodStart == currentPeriodStart)&&(identical(other.currentPeriodEnd, currentPeriodEnd) || other.currentPeriodEnd == currentPeriodEnd)&&(identical(other.lastPaymentId, lastPaymentId) || other.lastPaymentId == lastPaymentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgId,orgName,planId,planSnapshot,status,currentPeriodStart,currentPeriodEnd,lastPaymentId,createdAt);

@override
String toString() {
  return 'Subscription(id: $id, orgId: $orgId, orgName: $orgName, planId: $planId, planSnapshot: $planSnapshot, status: $status, currentPeriodStart: $currentPeriodStart, currentPeriodEnd: $currentPeriodEnd, lastPaymentId: $lastPaymentId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SubscriptionCopyWith<$Res>  {
  factory $SubscriptionCopyWith(Subscription value, $Res Function(Subscription) _then) = _$SubscriptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, String planId, SubscriptionPlan planSnapshot, SubscriptionStatus status,@TimestampConverter() DateTime? currentPeriodStart,@TimestampConverter() DateTime? currentPeriodEnd, String? lastPaymentId,@TimestampConverter() DateTime? createdAt
});


$SubscriptionPlanCopyWith<$Res> get planSnapshot;

}
/// @nodoc
class _$SubscriptionCopyWithImpl<$Res>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._self, this._then);

  final Subscription _self;
  final $Res Function(Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? planId = null,Object? planSnapshot = null,Object? status = null,Object? currentPeriodStart = freezed,Object? currentPeriodEnd = freezed,Object? lastPaymentId = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,planSnapshot: null == planSnapshot ? _self.planSnapshot : planSnapshot // ignore: cast_nullable_to_non_nullable
as SubscriptionPlan,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,currentPeriodStart: freezed == currentPeriodStart ? _self.currentPeriodStart : currentPeriodStart // ignore: cast_nullable_to_non_nullable
as DateTime?,currentPeriodEnd: freezed == currentPeriodEnd ? _self.currentPeriodEnd : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,lastPaymentId: freezed == lastPaymentId ? _self.lastPaymentId : lastPaymentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionPlanCopyWith<$Res> get planSnapshot {
  
  return $SubscriptionPlanCopyWith<$Res>(_self.planSnapshot, (value) {
    return _then(_self.copyWith(planSnapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [Subscription].
extension SubscriptionPatterns on Subscription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subscription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subscription value)  $default,){
final _that = this;
switch (_that) {
case _Subscription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subscription value)?  $default,){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String planId,  SubscriptionPlan planSnapshot,  SubscriptionStatus status, @TimestampConverter()  DateTime? currentPeriodStart, @TimestampConverter()  DateTime? currentPeriodEnd,  String? lastPaymentId, @TimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.planId,_that.planSnapshot,_that.status,_that.currentPeriodStart,_that.currentPeriodEnd,_that.lastPaymentId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String planId,  SubscriptionPlan planSnapshot,  SubscriptionStatus status, @TimestampConverter()  DateTime? currentPeriodStart, @TimestampConverter()  DateTime? currentPeriodEnd,  String? lastPaymentId, @TimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Subscription():
return $default(_that.id,_that.orgId,_that.orgName,_that.planId,_that.planSnapshot,_that.status,_that.currentPeriodStart,_that.currentPeriodEnd,_that.lastPaymentId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  String planId,  SubscriptionPlan planSnapshot,  SubscriptionStatus status, @TimestampConverter()  DateTime? currentPeriodStart, @TimestampConverter()  DateTime? currentPeriodEnd,  String? lastPaymentId, @TimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.planId,_that.planSnapshot,_that.status,_that.currentPeriodStart,_that.currentPeriodEnd,_that.lastPaymentId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Subscription extends Subscription {
  const _Subscription({@JsonKey(includeToJson: false) this.id = '', required this.orgId, this.orgName, required this.planId, required this.planSnapshot, this.status = SubscriptionStatus.active, @TimestampConverter() this.currentPeriodStart, @TimestampConverter() this.currentPeriodEnd, this.lastPaymentId, @TimestampConverter() this.createdAt}): super._();
  factory _Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String orgId;
@override final  String? orgName;
@override final  String planId;
@override final  SubscriptionPlan planSnapshot;
@override@JsonKey() final  SubscriptionStatus status;
@override@TimestampConverter() final  DateTime? currentPeriodStart;
@override@TimestampConverter() final  DateTime? currentPeriodEnd;
@override final  String? lastPaymentId;
@override@TimestampConverter() final  DateTime? createdAt;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionCopyWith<_Subscription> get copyWith => __$SubscriptionCopyWithImpl<_Subscription>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subscription&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.planSnapshot, planSnapshot) || other.planSnapshot == planSnapshot)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentPeriodStart, currentPeriodStart) || other.currentPeriodStart == currentPeriodStart)&&(identical(other.currentPeriodEnd, currentPeriodEnd) || other.currentPeriodEnd == currentPeriodEnd)&&(identical(other.lastPaymentId, lastPaymentId) || other.lastPaymentId == lastPaymentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgId,orgName,planId,planSnapshot,status,currentPeriodStart,currentPeriodEnd,lastPaymentId,createdAt);

@override
String toString() {
  return 'Subscription(id: $id, orgId: $orgId, orgName: $orgName, planId: $planId, planSnapshot: $planSnapshot, status: $status, currentPeriodStart: $currentPeriodStart, currentPeriodEnd: $currentPeriodEnd, lastPaymentId: $lastPaymentId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionCopyWith<$Res> implements $SubscriptionCopyWith<$Res> {
  factory _$SubscriptionCopyWith(_Subscription value, $Res Function(_Subscription) _then) = __$SubscriptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, String planId, SubscriptionPlan planSnapshot, SubscriptionStatus status,@TimestampConverter() DateTime? currentPeriodStart,@TimestampConverter() DateTime? currentPeriodEnd, String? lastPaymentId,@TimestampConverter() DateTime? createdAt
});


@override $SubscriptionPlanCopyWith<$Res> get planSnapshot;

}
/// @nodoc
class __$SubscriptionCopyWithImpl<$Res>
    implements _$SubscriptionCopyWith<$Res> {
  __$SubscriptionCopyWithImpl(this._self, this._then);

  final _Subscription _self;
  final $Res Function(_Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? planId = null,Object? planSnapshot = null,Object? status = null,Object? currentPeriodStart = freezed,Object? currentPeriodEnd = freezed,Object? lastPaymentId = freezed,Object? createdAt = freezed,}) {
  return _then(_Subscription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,planId: null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,planSnapshot: null == planSnapshot ? _self.planSnapshot : planSnapshot // ignore: cast_nullable_to_non_nullable
as SubscriptionPlan,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,currentPeriodStart: freezed == currentPeriodStart ? _self.currentPeriodStart : currentPeriodStart // ignore: cast_nullable_to_non_nullable
as DateTime?,currentPeriodEnd: freezed == currentPeriodEnd ? _self.currentPeriodEnd : currentPeriodEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,lastPaymentId: freezed == lastPaymentId ? _self.lastPaymentId : lastPaymentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubscriptionPlanCopyWith<$Res> get planSnapshot {
  
  return $SubscriptionPlanCopyWith<$Res>(_self.planSnapshot, (value) {
    return _then(_self.copyWith(planSnapshot: value));
  });
}
}


/// @nodoc
mixin _$PaymentPurpose {

 String get type; String? get planId; String? get subscriptionId;
/// Create a copy of PaymentPurpose
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentPurposeCopyWith<PaymentPurpose> get copyWith => _$PaymentPurposeCopyWithImpl<PaymentPurpose>(this as PaymentPurpose, _$identity);

  /// Serializes this PaymentPurpose to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentPurpose&&(identical(other.type, type) || other.type == type)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,planId,subscriptionId);

@override
String toString() {
  return 'PaymentPurpose(type: $type, planId: $planId, subscriptionId: $subscriptionId)';
}


}

/// @nodoc
abstract mixin class $PaymentPurposeCopyWith<$Res>  {
  factory $PaymentPurposeCopyWith(PaymentPurpose value, $Res Function(PaymentPurpose) _then) = _$PaymentPurposeCopyWithImpl;
@useResult
$Res call({
 String type, String? planId, String? subscriptionId
});




}
/// @nodoc
class _$PaymentPurposeCopyWithImpl<$Res>
    implements $PaymentPurposeCopyWith<$Res> {
  _$PaymentPurposeCopyWithImpl(this._self, this._then);

  final PaymentPurpose _self;
  final $Res Function(PaymentPurpose) _then;

/// Create a copy of PaymentPurpose
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? planId = freezed,Object? subscriptionId = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentPurpose].
extension PaymentPurposePatterns on PaymentPurpose {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentPurpose value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentPurpose() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentPurpose value)  $default,){
final _that = this;
switch (_that) {
case _PaymentPurpose():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentPurpose value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentPurpose() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String? planId,  String? subscriptionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentPurpose() when $default != null:
return $default(_that.type,_that.planId,_that.subscriptionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String? planId,  String? subscriptionId)  $default,) {final _that = this;
switch (_that) {
case _PaymentPurpose():
return $default(_that.type,_that.planId,_that.subscriptionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String? planId,  String? subscriptionId)?  $default,) {final _that = this;
switch (_that) {
case _PaymentPurpose() when $default != null:
return $default(_that.type,_that.planId,_that.subscriptionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentPurpose implements PaymentPurpose {
  const _PaymentPurpose({required this.type, this.planId, this.subscriptionId});
  factory _PaymentPurpose.fromJson(Map<String, dynamic> json) => _$PaymentPurposeFromJson(json);

@override final  String type;
@override final  String? planId;
@override final  String? subscriptionId;

/// Create a copy of PaymentPurpose
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentPurposeCopyWith<_PaymentPurpose> get copyWith => __$PaymentPurposeCopyWithImpl<_PaymentPurpose>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentPurposeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentPurpose&&(identical(other.type, type) || other.type == type)&&(identical(other.planId, planId) || other.planId == planId)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,planId,subscriptionId);

@override
String toString() {
  return 'PaymentPurpose(type: $type, planId: $planId, subscriptionId: $subscriptionId)';
}


}

/// @nodoc
abstract mixin class _$PaymentPurposeCopyWith<$Res> implements $PaymentPurposeCopyWith<$Res> {
  factory _$PaymentPurposeCopyWith(_PaymentPurpose value, $Res Function(_PaymentPurpose) _then) = __$PaymentPurposeCopyWithImpl;
@override @useResult
$Res call({
 String type, String? planId, String? subscriptionId
});




}
/// @nodoc
class __$PaymentPurposeCopyWithImpl<$Res>
    implements _$PaymentPurposeCopyWith<$Res> {
  __$PaymentPurposeCopyWithImpl(this._self, this._then);

  final _PaymentPurpose _self;
  final $Res Function(_PaymentPurpose) _then;

/// Create a copy of PaymentPurpose
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? planId = freezed,Object? subscriptionId = freezed,}) {
  return _then(_PaymentPurpose(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,planId: freezed == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String?,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Payment {

@JsonKey(includeToJson: false) String get id; String get provider; PaymentPurpose get purpose; String get payerUid; String? get payerOrgId; String? get orgName; Money get amount; String get description; PaymentStatus get status;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get completedAt;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.payerUid, payerUid) || other.payerUid == payerUid)&&(identical(other.payerOrgId, payerOrgId) || other.payerOrgId == payerOrgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,provider,purpose,payerUid,payerOrgId,orgName,amount,description,status,createdAt,completedAt);

@override
String toString() {
  return 'Payment(id: $id, provider: $provider, purpose: $purpose, payerUid: $payerUid, payerOrgId: $payerOrgId, orgName: $orgName, amount: $amount, description: $description, status: $status, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String provider, PaymentPurpose purpose, String payerUid, String? payerOrgId, String? orgName, Money amount, String description, PaymentStatus status,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? completedAt
});


$PaymentPurposeCopyWith<$Res> get purpose;

}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? provider = null,Object? purpose = null,Object? payerUid = null,Object? payerOrgId = freezed,Object? orgName = freezed,Object? amount = null,Object? description = null,Object? status = null,Object? createdAt = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as PaymentPurpose,payerUid: null == payerUid ? _self.payerUid : payerUid // ignore: cast_nullable_to_non_nullable
as String,payerOrgId: freezed == payerOrgId ? _self.payerOrgId : payerOrgId // ignore: cast_nullable_to_non_nullable
as String?,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentPurposeCopyWith<$Res> get purpose {
  
  return $PaymentPurposeCopyWith<$Res>(_self.purpose, (value) {
    return _then(_self.copyWith(purpose: value));
  });
}
}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String provider,  PaymentPurpose purpose,  String payerUid,  String? payerOrgId,  String? orgName,  Money amount,  String description,  PaymentStatus status, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.provider,_that.purpose,_that.payerUid,_that.payerOrgId,_that.orgName,_that.amount,_that.description,_that.status,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String provider,  PaymentPurpose purpose,  String payerUid,  String? payerOrgId,  String? orgName,  Money amount,  String description,  PaymentStatus status, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.provider,_that.purpose,_that.payerUid,_that.payerOrgId,_that.orgName,_that.amount,_that.description,_that.status,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String provider,  PaymentPurpose purpose,  String payerUid,  String? payerOrgId,  String? orgName,  Money amount,  String description,  PaymentStatus status, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.provider,_that.purpose,_that.payerUid,_that.payerOrgId,_that.orgName,_that.amount,_that.description,_that.status,_that.createdAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment extends Payment {
  const _Payment({@JsonKey(includeToJson: false) this.id = '', this.provider = 'simulation', required this.purpose, required this.payerUid, this.payerOrgId, this.orgName, required this.amount, this.description = '', this.status = PaymentStatus.pending, @TimestampConverter() this.createdAt, @TimestampConverter() this.completedAt}): super._();
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey() final  String provider;
@override final  PaymentPurpose purpose;
@override final  String payerUid;
@override final  String? payerOrgId;
@override final  String? orgName;
@override final  Money amount;
@override@JsonKey() final  String description;
@override@JsonKey() final  PaymentStatus status;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? completedAt;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.payerUid, payerUid) || other.payerUid == payerUid)&&(identical(other.payerOrgId, payerOrgId) || other.payerOrgId == payerOrgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,provider,purpose,payerUid,payerOrgId,orgName,amount,description,status,createdAt,completedAt);

@override
String toString() {
  return 'Payment(id: $id, provider: $provider, purpose: $purpose, payerUid: $payerUid, payerOrgId: $payerOrgId, orgName: $orgName, amount: $amount, description: $description, status: $status, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String provider, PaymentPurpose purpose, String payerUid, String? payerOrgId, String? orgName, Money amount, String description, PaymentStatus status,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? completedAt
});


@override $PaymentPurposeCopyWith<$Res> get purpose;

}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? provider = null,Object? purpose = null,Object? payerUid = null,Object? payerOrgId = freezed,Object? orgName = freezed,Object? amount = null,Object? description = null,Object? status = null,Object? createdAt = freezed,Object? completedAt = freezed,}) {
  return _then(_Payment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as PaymentPurpose,payerUid: null == payerUid ? _self.payerUid : payerUid // ignore: cast_nullable_to_non_nullable
as String,payerOrgId: freezed == payerOrgId ? _self.payerOrgId : payerOrgId // ignore: cast_nullable_to_non_nullable
as String?,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentPurposeCopyWith<$Res> get purpose {
  
  return $PaymentPurposeCopyWith<$Res>(_self.purpose, (value) {
    return _then(_self.copyWith(purpose: value));
  });
}
}


/// @nodoc
mixin _$CommissionRule {

@JsonKey(includeToJson: false) String get id; CommissionScope get scope; RateType get rateType; double? get rate; Money? get fixedAmount;/// null : règle par défaut ; sinon règle propre à un partenaire.
 String? get orgId; String? get orgName;@TimestampConverter() DateTime? get validFrom;@TimestampConverter() DateTime? get validTo; bool get active; String? get updatedBy;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of CommissionRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommissionRuleCopyWith<CommissionRule> get copyWith => _$CommissionRuleCopyWithImpl<CommissionRule>(this as CommissionRule, _$identity);

  /// Serializes this CommissionRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommissionRule&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.rateType, rateType) || other.rateType == rateType)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.fixedAmount, fixedAmount) || other.fixedAmount == fixedAmount)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo)&&(identical(other.active, active) || other.active == active)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scope,rateType,rate,fixedAmount,orgId,orgName,validFrom,validTo,active,updatedBy,updatedAt);

@override
String toString() {
  return 'CommissionRule(id: $id, scope: $scope, rateType: $rateType, rate: $rate, fixedAmount: $fixedAmount, orgId: $orgId, orgName: $orgName, validFrom: $validFrom, validTo: $validTo, active: $active, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CommissionRuleCopyWith<$Res>  {
  factory $CommissionRuleCopyWith(CommissionRule value, $Res Function(CommissionRule) _then) = _$CommissionRuleCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, CommissionScope scope, RateType rateType, double? rate, Money? fixedAmount, String? orgId, String? orgName,@TimestampConverter() DateTime? validFrom,@TimestampConverter() DateTime? validTo, bool active, String? updatedBy,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$CommissionRuleCopyWithImpl<$Res>
    implements $CommissionRuleCopyWith<$Res> {
  _$CommissionRuleCopyWithImpl(this._self, this._then);

  final CommissionRule _self;
  final $Res Function(CommissionRule) _then;

/// Create a copy of CommissionRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scope = null,Object? rateType = null,Object? rate = freezed,Object? fixedAmount = freezed,Object? orgId = freezed,Object? orgName = freezed,Object? validFrom = freezed,Object? validTo = freezed,Object? active = null,Object? updatedBy = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CommissionScope,rateType: null == rateType ? _self.rateType : rateType // ignore: cast_nullable_to_non_nullable
as RateType,rate: freezed == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double?,fixedAmount: freezed == fixedAmount ? _self.fixedAmount : fixedAmount // ignore: cast_nullable_to_non_nullable
as Money?,orgId: freezed == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String?,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CommissionRule].
extension CommissionRulePatterns on CommissionRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommissionRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommissionRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommissionRule value)  $default,){
final _that = this;
switch (_that) {
case _CommissionRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommissionRule value)?  $default,){
final _that = this;
switch (_that) {
case _CommissionRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  CommissionScope scope,  RateType rateType,  double? rate,  Money? fixedAmount,  String? orgId,  String? orgName, @TimestampConverter()  DateTime? validFrom, @TimestampConverter()  DateTime? validTo,  bool active,  String? updatedBy, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommissionRule() when $default != null:
return $default(_that.id,_that.scope,_that.rateType,_that.rate,_that.fixedAmount,_that.orgId,_that.orgName,_that.validFrom,_that.validTo,_that.active,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  CommissionScope scope,  RateType rateType,  double? rate,  Money? fixedAmount,  String? orgId,  String? orgName, @TimestampConverter()  DateTime? validFrom, @TimestampConverter()  DateTime? validTo,  bool active,  String? updatedBy, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CommissionRule():
return $default(_that.id,_that.scope,_that.rateType,_that.rate,_that.fixedAmount,_that.orgId,_that.orgName,_that.validFrom,_that.validTo,_that.active,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  CommissionScope scope,  RateType rateType,  double? rate,  Money? fixedAmount,  String? orgId,  String? orgName, @TimestampConverter()  DateTime? validFrom, @TimestampConverter()  DateTime? validTo,  bool active,  String? updatedBy, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CommissionRule() when $default != null:
return $default(_that.id,_that.scope,_that.rateType,_that.rate,_that.fixedAmount,_that.orgId,_that.orgName,_that.validFrom,_that.validTo,_that.active,_that.updatedBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommissionRule extends CommissionRule {
  const _CommissionRule({@JsonKey(includeToJson: false) this.id = '', required this.scope, this.rateType = RateType.percent, this.rate, this.fixedAmount, this.orgId, this.orgName, @TimestampConverter() this.validFrom, @TimestampConverter() this.validTo, this.active = true, this.updatedBy, @TimestampConverter() this.updatedAt}): super._();
  factory _CommissionRule.fromJson(Map<String, dynamic> json) => _$CommissionRuleFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  CommissionScope scope;
@override@JsonKey() final  RateType rateType;
@override final  double? rate;
@override final  Money? fixedAmount;
/// null : règle par défaut ; sinon règle propre à un partenaire.
@override final  String? orgId;
@override final  String? orgName;
@override@TimestampConverter() final  DateTime? validFrom;
@override@TimestampConverter() final  DateTime? validTo;
@override@JsonKey() final  bool active;
@override final  String? updatedBy;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of CommissionRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommissionRuleCopyWith<_CommissionRule> get copyWith => __$CommissionRuleCopyWithImpl<_CommissionRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommissionRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommissionRule&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.rateType, rateType) || other.rateType == rateType)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.fixedAmount, fixedAmount) || other.fixedAmount == fixedAmount)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validTo, validTo) || other.validTo == validTo)&&(identical(other.active, active) || other.active == active)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,scope,rateType,rate,fixedAmount,orgId,orgName,validFrom,validTo,active,updatedBy,updatedAt);

@override
String toString() {
  return 'CommissionRule(id: $id, scope: $scope, rateType: $rateType, rate: $rate, fixedAmount: $fixedAmount, orgId: $orgId, orgName: $orgName, validFrom: $validFrom, validTo: $validTo, active: $active, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CommissionRuleCopyWith<$Res> implements $CommissionRuleCopyWith<$Res> {
  factory _$CommissionRuleCopyWith(_CommissionRule value, $Res Function(_CommissionRule) _then) = __$CommissionRuleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, CommissionScope scope, RateType rateType, double? rate, Money? fixedAmount, String? orgId, String? orgName,@TimestampConverter() DateTime? validFrom,@TimestampConverter() DateTime? validTo, bool active, String? updatedBy,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$CommissionRuleCopyWithImpl<$Res>
    implements _$CommissionRuleCopyWith<$Res> {
  __$CommissionRuleCopyWithImpl(this._self, this._then);

  final _CommissionRule _self;
  final $Res Function(_CommissionRule) _then;

/// Create a copy of CommissionRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scope = null,Object? rateType = null,Object? rate = freezed,Object? fixedAmount = freezed,Object? orgId = freezed,Object? orgName = freezed,Object? validFrom = freezed,Object? validTo = freezed,Object? active = null,Object? updatedBy = freezed,Object? updatedAt = freezed,}) {
  return _then(_CommissionRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as CommissionScope,rateType: null == rateType ? _self.rateType : rateType // ignore: cast_nullable_to_non_nullable
as RateType,rate: freezed == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double?,fixedAmount: freezed == fixedAmount ? _self.fixedAmount : fixedAmount // ignore: cast_nullable_to_non_nullable
as Money?,orgId: freezed == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String?,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,validFrom: freezed == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,validTo: freezed == validTo ? _self.validTo : validTo // ignore: cast_nullable_to_non_nullable
as DateTime?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CommissionSource {

 String get type; String get id;
/// Create a copy of CommissionSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommissionSourceCopyWith<CommissionSource> get copyWith => _$CommissionSourceCopyWithImpl<CommissionSource>(this as CommissionSource, _$identity);

  /// Serializes this CommissionSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommissionSource&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id);

@override
String toString() {
  return 'CommissionSource(type: $type, id: $id)';
}


}

/// @nodoc
abstract mixin class $CommissionSourceCopyWith<$Res>  {
  factory $CommissionSourceCopyWith(CommissionSource value, $Res Function(CommissionSource) _then) = _$CommissionSourceCopyWithImpl;
@useResult
$Res call({
 String type, String id
});




}
/// @nodoc
class _$CommissionSourceCopyWithImpl<$Res>
    implements $CommissionSourceCopyWith<$Res> {
  _$CommissionSourceCopyWithImpl(this._self, this._then);

  final CommissionSource _self;
  final $Res Function(CommissionSource) _then;

/// Create a copy of CommissionSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CommissionSource].
extension CommissionSourcePatterns on CommissionSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommissionSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommissionSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommissionSource value)  $default,){
final _that = this;
switch (_that) {
case _CommissionSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommissionSource value)?  $default,){
final _that = this;
switch (_that) {
case _CommissionSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommissionSource() when $default != null:
return $default(_that.type,_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String id)  $default,) {final _that = this;
switch (_that) {
case _CommissionSource():
return $default(_that.type,_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String id)?  $default,) {final _that = this;
switch (_that) {
case _CommissionSource() when $default != null:
return $default(_that.type,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommissionSource implements CommissionSource {
  const _CommissionSource({required this.type, required this.id});
  factory _CommissionSource.fromJson(Map<String, dynamic> json) => _$CommissionSourceFromJson(json);

@override final  String type;
@override final  String id;

/// Create a copy of CommissionSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommissionSourceCopyWith<_CommissionSource> get copyWith => __$CommissionSourceCopyWithImpl<_CommissionSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommissionSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommissionSource&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id);

@override
String toString() {
  return 'CommissionSource(type: $type, id: $id)';
}


}

/// @nodoc
abstract mixin class _$CommissionSourceCopyWith<$Res> implements $CommissionSourceCopyWith<$Res> {
  factory _$CommissionSourceCopyWith(_CommissionSource value, $Res Function(_CommissionSource) _then) = __$CommissionSourceCopyWithImpl;
@override @useResult
$Res call({
 String type, String id
});




}
/// @nodoc
class __$CommissionSourceCopyWithImpl<$Res>
    implements _$CommissionSourceCopyWith<$Res> {
  __$CommissionSourceCopyWithImpl(this._self, this._then);

  final _CommissionSource _self;
  final $Res Function(_CommissionSource) _then;

/// Create a copy of CommissionSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = null,}) {
  return _then(_CommissionSource(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Commission {

@JsonKey(includeToJson: false) String get id; String get orgId; String? get orgName; CommissionSource? get source; Money get baseAmount; Money get amount; CommissionStatus get status; String? get statusNote;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get statusChangedAt;
/// Create a copy of Commission
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommissionCopyWith<Commission> get copyWith => _$CommissionCopyWithImpl<Commission>(this as Commission, _$identity);

  /// Serializes this Commission to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Commission&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.source, source) || other.source == source)&&(identical(other.baseAmount, baseAmount) || other.baseAmount == baseAmount)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusNote, statusNote) || other.statusNote == statusNote)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgId,orgName,source,baseAmount,amount,status,statusNote,createdAt,statusChangedAt);

@override
String toString() {
  return 'Commission(id: $id, orgId: $orgId, orgName: $orgName, source: $source, baseAmount: $baseAmount, amount: $amount, status: $status, statusNote: $statusNote, createdAt: $createdAt, statusChangedAt: $statusChangedAt)';
}


}

/// @nodoc
abstract mixin class $CommissionCopyWith<$Res>  {
  factory $CommissionCopyWith(Commission value, $Res Function(Commission) _then) = _$CommissionCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, CommissionSource? source, Money baseAmount, Money amount, CommissionStatus status, String? statusNote,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? statusChangedAt
});


$CommissionSourceCopyWith<$Res>? get source;

}
/// @nodoc
class _$CommissionCopyWithImpl<$Res>
    implements $CommissionCopyWith<$Res> {
  _$CommissionCopyWithImpl(this._self, this._then);

  final Commission _self;
  final $Res Function(Commission) _then;

/// Create a copy of Commission
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? source = freezed,Object? baseAmount = null,Object? amount = null,Object? status = null,Object? statusNote = freezed,Object? createdAt = freezed,Object? statusChangedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CommissionSource?,baseAmount: null == baseAmount ? _self.baseAmount : baseAmount // ignore: cast_nullable_to_non_nullable
as Money,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommissionStatus,statusNote: freezed == statusNote ? _self.statusNote : statusNote // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusChangedAt: freezed == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Commission
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommissionSourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $CommissionSourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}


/// Adds pattern-matching-related methods to [Commission].
extension CommissionPatterns on Commission {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Commission value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Commission() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Commission value)  $default,){
final _that = this;
switch (_that) {
case _Commission():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Commission value)?  $default,){
final _that = this;
switch (_that) {
case _Commission() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  CommissionSource? source,  Money baseAmount,  Money amount,  CommissionStatus status,  String? statusNote, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? statusChangedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Commission() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.source,_that.baseAmount,_that.amount,_that.status,_that.statusNote,_that.createdAt,_that.statusChangedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  CommissionSource? source,  Money baseAmount,  Money amount,  CommissionStatus status,  String? statusNote, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? statusChangedAt)  $default,) {final _that = this;
switch (_that) {
case _Commission():
return $default(_that.id,_that.orgId,_that.orgName,_that.source,_that.baseAmount,_that.amount,_that.status,_that.statusNote,_that.createdAt,_that.statusChangedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String orgId,  String? orgName,  CommissionSource? source,  Money baseAmount,  Money amount,  CommissionStatus status,  String? statusNote, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? statusChangedAt)?  $default,) {final _that = this;
switch (_that) {
case _Commission() when $default != null:
return $default(_that.id,_that.orgId,_that.orgName,_that.source,_that.baseAmount,_that.amount,_that.status,_that.statusNote,_that.createdAt,_that.statusChangedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Commission implements Commission {
  const _Commission({@JsonKey(includeToJson: false) this.id = '', required this.orgId, this.orgName, this.source, this.baseAmount = Money.zero, required this.amount, this.status = CommissionStatus.due, this.statusNote, @TimestampConverter() this.createdAt, @TimestampConverter() this.statusChangedAt});
  factory _Commission.fromJson(Map<String, dynamic> json) => _$CommissionFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String orgId;
@override final  String? orgName;
@override final  CommissionSource? source;
@override@JsonKey() final  Money baseAmount;
@override final  Money amount;
@override@JsonKey() final  CommissionStatus status;
@override final  String? statusNote;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? statusChangedAt;

/// Create a copy of Commission
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommissionCopyWith<_Commission> get copyWith => __$CommissionCopyWithImpl<_Commission>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommissionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Commission&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.source, source) || other.source == source)&&(identical(other.baseAmount, baseAmount) || other.baseAmount == baseAmount)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusNote, statusNote) || other.statusNote == statusNote)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orgId,orgName,source,baseAmount,amount,status,statusNote,createdAt,statusChangedAt);

@override
String toString() {
  return 'Commission(id: $id, orgId: $orgId, orgName: $orgName, source: $source, baseAmount: $baseAmount, amount: $amount, status: $status, statusNote: $statusNote, createdAt: $createdAt, statusChangedAt: $statusChangedAt)';
}


}

/// @nodoc
abstract mixin class _$CommissionCopyWith<$Res> implements $CommissionCopyWith<$Res> {
  factory _$CommissionCopyWith(_Commission value, $Res Function(_Commission) _then) = __$CommissionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String orgId, String? orgName, CommissionSource? source, Money baseAmount, Money amount, CommissionStatus status, String? statusNote,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? statusChangedAt
});


@override $CommissionSourceCopyWith<$Res>? get source;

}
/// @nodoc
class __$CommissionCopyWithImpl<$Res>
    implements _$CommissionCopyWith<$Res> {
  __$CommissionCopyWithImpl(this._self, this._then);

  final _Commission _self;
  final $Res Function(_Commission) _then;

/// Create a copy of Commission
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? orgName = freezed,Object? source = freezed,Object? baseAmount = null,Object? amount = null,Object? status = null,Object? statusNote = freezed,Object? createdAt = freezed,Object? statusChangedAt = freezed,}) {
  return _then(_Commission(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as CommissionSource?,baseAmount: null == baseAmount ? _self.baseAmount : baseAmount // ignore: cast_nullable_to_non_nullable
as Money,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CommissionStatus,statusNote: freezed == statusNote ? _self.statusNote : statusNote // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusChangedAt: freezed == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Commission
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommissionSourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $CommissionSourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}

// dart format on
