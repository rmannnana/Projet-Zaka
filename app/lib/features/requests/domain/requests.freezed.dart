// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientSnapshot {

 String get name; String? get phone; String? get email;
/// Create a copy of ClientSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientSnapshotCopyWith<ClientSnapshot> get copyWith => _$ClientSnapshotCopyWithImpl<ClientSnapshot>(this as ClientSnapshot, _$identity);

  /// Serializes this ClientSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientSnapshot&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,phone,email);

@override
String toString() {
  return 'ClientSnapshot(name: $name, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class $ClientSnapshotCopyWith<$Res>  {
  factory $ClientSnapshotCopyWith(ClientSnapshot value, $Res Function(ClientSnapshot) _then) = _$ClientSnapshotCopyWithImpl;
@useResult
$Res call({
 String name, String? phone, String? email
});




}
/// @nodoc
class _$ClientSnapshotCopyWithImpl<$Res>
    implements $ClientSnapshotCopyWith<$Res> {
  _$ClientSnapshotCopyWithImpl(this._self, this._then);

  final ClientSnapshot _self;
  final $Res Function(ClientSnapshot) _then;

/// Create a copy of ClientSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? phone = freezed,Object? email = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientSnapshot].
extension ClientSnapshotPatterns on ClientSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ClientSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ClientSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? phone,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientSnapshot() when $default != null:
return $default(_that.name,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? phone,  String? email)  $default,) {final _that = this;
switch (_that) {
case _ClientSnapshot():
return $default(_that.name,_that.phone,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? phone,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _ClientSnapshot() when $default != null:
return $default(_that.name,_that.phone,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientSnapshot implements ClientSnapshot {
  const _ClientSnapshot({this.name = '', this.phone, this.email});
  factory _ClientSnapshot.fromJson(Map<String, dynamic> json) => _$ClientSnapshotFromJson(json);

@override@JsonKey() final  String name;
@override final  String? phone;
@override final  String? email;

/// Create a copy of ClientSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientSnapshotCopyWith<_ClientSnapshot> get copyWith => __$ClientSnapshotCopyWithImpl<_ClientSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientSnapshot&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,phone,email);

@override
String toString() {
  return 'ClientSnapshot(name: $name, phone: $phone, email: $email)';
}


}

/// @nodoc
abstract mixin class _$ClientSnapshotCopyWith<$Res> implements $ClientSnapshotCopyWith<$Res> {
  factory _$ClientSnapshotCopyWith(_ClientSnapshot value, $Res Function(_ClientSnapshot) _then) = __$ClientSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String name, String? phone, String? email
});




}
/// @nodoc
class __$ClientSnapshotCopyWithImpl<$Res>
    implements _$ClientSnapshotCopyWith<$Res> {
  __$ClientSnapshotCopyWithImpl(this._self, this._then);

  final _ClientSnapshot _self;
  final $Res Function(_ClientSnapshot) _then;

/// Create a copy of ClientSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? phone = freezed,Object? email = freezed,}) {
  return _then(_ClientSnapshot(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StatusEvent {

 String get status; String? get by;@TimestampConverter() DateTime? get at; String? get note;
/// Create a copy of StatusEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusEventCopyWith<StatusEvent> get copyWith => _$StatusEventCopyWithImpl<StatusEvent>(this as StatusEvent, _$identity);

  /// Serializes this StatusEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusEvent&&(identical(other.status, status) || other.status == status)&&(identical(other.by, by) || other.by == by)&&(identical(other.at, at) || other.at == at)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,by,at,note);

@override
String toString() {
  return 'StatusEvent(status: $status, by: $by, at: $at, note: $note)';
}


}

/// @nodoc
abstract mixin class $StatusEventCopyWith<$Res>  {
  factory $StatusEventCopyWith(StatusEvent value, $Res Function(StatusEvent) _then) = _$StatusEventCopyWithImpl;
@useResult
$Res call({
 String status, String? by,@TimestampConverter() DateTime? at, String? note
});




}
/// @nodoc
class _$StatusEventCopyWithImpl<$Res>
    implements $StatusEventCopyWith<$Res> {
  _$StatusEventCopyWithImpl(this._self, this._then);

  final StatusEvent _self;
  final $Res Function(StatusEvent) _then;

/// Create a copy of StatusEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? by = freezed,Object? at = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,by: freezed == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StatusEvent].
extension StatusEventPatterns on StatusEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatusEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatusEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatusEvent value)  $default,){
final _that = this;
switch (_that) {
case _StatusEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatusEvent value)?  $default,){
final _that = this;
switch (_that) {
case _StatusEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? by, @TimestampConverter()  DateTime? at,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatusEvent() when $default != null:
return $default(_that.status,_that.by,_that.at,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? by, @TimestampConverter()  DateTime? at,  String? note)  $default,) {final _that = this;
switch (_that) {
case _StatusEvent():
return $default(_that.status,_that.by,_that.at,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? by, @TimestampConverter()  DateTime? at,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _StatusEvent() when $default != null:
return $default(_that.status,_that.by,_that.at,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatusEvent implements StatusEvent {
  const _StatusEvent({this.status = '', this.by, @TimestampConverter() this.at, this.note});
  factory _StatusEvent.fromJson(Map<String, dynamic> json) => _$StatusEventFromJson(json);

@override@JsonKey() final  String status;
@override final  String? by;
@override@TimestampConverter() final  DateTime? at;
@override final  String? note;

/// Create a copy of StatusEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatusEventCopyWith<_StatusEvent> get copyWith => __$StatusEventCopyWithImpl<_StatusEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatusEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatusEvent&&(identical(other.status, status) || other.status == status)&&(identical(other.by, by) || other.by == by)&&(identical(other.at, at) || other.at == at)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,by,at,note);

@override
String toString() {
  return 'StatusEvent(status: $status, by: $by, at: $at, note: $note)';
}


}

/// @nodoc
abstract mixin class _$StatusEventCopyWith<$Res> implements $StatusEventCopyWith<$Res> {
  factory _$StatusEventCopyWith(_StatusEvent value, $Res Function(_StatusEvent) _then) = __$StatusEventCopyWithImpl;
@override @useResult
$Res call({
 String status, String? by,@TimestampConverter() DateTime? at, String? note
});




}
/// @nodoc
class __$StatusEventCopyWithImpl<$Res>
    implements _$StatusEventCopyWith<$Res> {
  __$StatusEventCopyWithImpl(this._self, this._then);

  final _StatusEvent _self;
  final $Res Function(_StatusEvent) _then;

/// Create a copy of StatusEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? by = freezed,Object? at = freezed,Object? note = freezed,}) {
  return _then(_StatusEvent(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,by: freezed == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String?,at: freezed == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BookingRequest {

@JsonKey(includeToJson: false) String get id; String get hotelId; String get hotelName; String? get hotelCity; String? get hotelPhoto; String get orgId; String? get orgName; String get roomTypeId; String get roomTypeName; String? get offerTitle; int get discountPercent; String get clientUid; ClientSnapshot get clientSnapshot;@TimestampConverter() DateTime? get checkIn;@TimestampConverter() DateTime? get checkOut; int get nights; int get adults; int get children; int get rooms; Money? get pricePerNight; Money get estimatedTotal; String get message; BookingStatus get status; BookingPayment get paymentStatus;@TimestampConverter() DateTime? get expiresAt; List<StatusEvent> get statusHistory; Money? get commissionAmount;@TimestampConverter() DateTime? get createdAt;
/// Create a copy of BookingRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingRequestCopyWith<BookingRequest> get copyWith => _$BookingRequestCopyWithImpl<BookingRequest>(this as BookingRequest, _$identity);

  /// Serializes this BookingRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.hotelId, hotelId) || other.hotelId == hotelId)&&(identical(other.hotelName, hotelName) || other.hotelName == hotelName)&&(identical(other.hotelCity, hotelCity) || other.hotelCity == hotelCity)&&(identical(other.hotelPhoto, hotelPhoto) || other.hotelPhoto == hotelPhoto)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.roomTypeId, roomTypeId) || other.roomTypeId == roomTypeId)&&(identical(other.roomTypeName, roomTypeName) || other.roomTypeName == roomTypeName)&&(identical(other.offerTitle, offerTitle) || other.offerTitle == offerTitle)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.clientUid, clientUid) || other.clientUid == clientUid)&&(identical(other.clientSnapshot, clientSnapshot) || other.clientSnapshot == clientSnapshot)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.nights, nights) || other.nights == nights)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.children, children) || other.children == children)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.pricePerNight, pricePerNight) || other.pricePerNight == pricePerNight)&&(identical(other.estimatedTotal, estimatedTotal) || other.estimatedTotal == estimatedTotal)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other.statusHistory, statusHistory)&&(identical(other.commissionAmount, commissionAmount) || other.commissionAmount == commissionAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,hotelId,hotelName,hotelCity,hotelPhoto,orgId,orgName,roomTypeId,roomTypeName,offerTitle,discountPercent,clientUid,clientSnapshot,checkIn,checkOut,nights,adults,children,rooms,pricePerNight,estimatedTotal,message,status,paymentStatus,expiresAt,const DeepCollectionEquality().hash(statusHistory),commissionAmount,createdAt]);

@override
String toString() {
  return 'BookingRequest(id: $id, hotelId: $hotelId, hotelName: $hotelName, hotelCity: $hotelCity, hotelPhoto: $hotelPhoto, orgId: $orgId, orgName: $orgName, roomTypeId: $roomTypeId, roomTypeName: $roomTypeName, offerTitle: $offerTitle, discountPercent: $discountPercent, clientUid: $clientUid, clientSnapshot: $clientSnapshot, checkIn: $checkIn, checkOut: $checkOut, nights: $nights, adults: $adults, children: $children, rooms: $rooms, pricePerNight: $pricePerNight, estimatedTotal: $estimatedTotal, message: $message, status: $status, paymentStatus: $paymentStatus, expiresAt: $expiresAt, statusHistory: $statusHistory, commissionAmount: $commissionAmount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BookingRequestCopyWith<$Res>  {
  factory $BookingRequestCopyWith(BookingRequest value, $Res Function(BookingRequest) _then) = _$BookingRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String hotelId, String hotelName, String? hotelCity, String? hotelPhoto, String orgId, String? orgName, String roomTypeId, String roomTypeName, String? offerTitle, int discountPercent, String clientUid, ClientSnapshot clientSnapshot,@TimestampConverter() DateTime? checkIn,@TimestampConverter() DateTime? checkOut, int nights, int adults, int children, int rooms, Money? pricePerNight, Money estimatedTotal, String message, BookingStatus status, BookingPayment paymentStatus,@TimestampConverter() DateTime? expiresAt, List<StatusEvent> statusHistory, Money? commissionAmount,@TimestampConverter() DateTime? createdAt
});


$ClientSnapshotCopyWith<$Res> get clientSnapshot;

}
/// @nodoc
class _$BookingRequestCopyWithImpl<$Res>
    implements $BookingRequestCopyWith<$Res> {
  _$BookingRequestCopyWithImpl(this._self, this._then);

  final BookingRequest _self;
  final $Res Function(BookingRequest) _then;

/// Create a copy of BookingRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hotelId = null,Object? hotelName = null,Object? hotelCity = freezed,Object? hotelPhoto = freezed,Object? orgId = null,Object? orgName = freezed,Object? roomTypeId = null,Object? roomTypeName = null,Object? offerTitle = freezed,Object? discountPercent = null,Object? clientUid = null,Object? clientSnapshot = null,Object? checkIn = freezed,Object? checkOut = freezed,Object? nights = null,Object? adults = null,Object? children = null,Object? rooms = null,Object? pricePerNight = freezed,Object? estimatedTotal = null,Object? message = null,Object? status = null,Object? paymentStatus = null,Object? expiresAt = freezed,Object? statusHistory = null,Object? commissionAmount = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hotelId: null == hotelId ? _self.hotelId : hotelId // ignore: cast_nullable_to_non_nullable
as String,hotelName: null == hotelName ? _self.hotelName : hotelName // ignore: cast_nullable_to_non_nullable
as String,hotelCity: freezed == hotelCity ? _self.hotelCity : hotelCity // ignore: cast_nullable_to_non_nullable
as String?,hotelPhoto: freezed == hotelPhoto ? _self.hotelPhoto : hotelPhoto // ignore: cast_nullable_to_non_nullable
as String?,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,roomTypeId: null == roomTypeId ? _self.roomTypeId : roomTypeId // ignore: cast_nullable_to_non_nullable
as String,roomTypeName: null == roomTypeName ? _self.roomTypeName : roomTypeName // ignore: cast_nullable_to_non_nullable
as String,offerTitle: freezed == offerTitle ? _self.offerTitle : offerTitle // ignore: cast_nullable_to_non_nullable
as String?,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int,clientUid: null == clientUid ? _self.clientUid : clientUid // ignore: cast_nullable_to_non_nullable
as String,clientSnapshot: null == clientSnapshot ? _self.clientSnapshot : clientSnapshot // ignore: cast_nullable_to_non_nullable
as ClientSnapshot,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOut: freezed == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as DateTime?,nights: null == nights ? _self.nights : nights // ignore: cast_nullable_to_non_nullable
as int,adults: null == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as int,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int,pricePerNight: freezed == pricePerNight ? _self.pricePerNight : pricePerNight // ignore: cast_nullable_to_non_nullable
as Money?,estimatedTotal: null == estimatedTotal ? _self.estimatedTotal : estimatedTotal // ignore: cast_nullable_to_non_nullable
as Money,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as BookingPayment,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusHistory: null == statusHistory ? _self.statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<StatusEvent>,commissionAmount: freezed == commissionAmount ? _self.commissionAmount : commissionAmount // ignore: cast_nullable_to_non_nullable
as Money?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of BookingRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientSnapshotCopyWith<$Res> get clientSnapshot {
  
  return $ClientSnapshotCopyWith<$Res>(_self.clientSnapshot, (value) {
    return _then(_self.copyWith(clientSnapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingRequest].
extension BookingRequestPatterns on BookingRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingRequest value)  $default,){
final _that = this;
switch (_that) {
case _BookingRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BookingRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String hotelId,  String hotelName,  String? hotelCity,  String? hotelPhoto,  String orgId,  String? orgName,  String roomTypeId,  String roomTypeName,  String? offerTitle,  int discountPercent,  String clientUid,  ClientSnapshot clientSnapshot, @TimestampConverter()  DateTime? checkIn, @TimestampConverter()  DateTime? checkOut,  int nights,  int adults,  int children,  int rooms,  Money? pricePerNight,  Money estimatedTotal,  String message,  BookingStatus status,  BookingPayment paymentStatus, @TimestampConverter()  DateTime? expiresAt,  List<StatusEvent> statusHistory,  Money? commissionAmount, @TimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingRequest() when $default != null:
return $default(_that.id,_that.hotelId,_that.hotelName,_that.hotelCity,_that.hotelPhoto,_that.orgId,_that.orgName,_that.roomTypeId,_that.roomTypeName,_that.offerTitle,_that.discountPercent,_that.clientUid,_that.clientSnapshot,_that.checkIn,_that.checkOut,_that.nights,_that.adults,_that.children,_that.rooms,_that.pricePerNight,_that.estimatedTotal,_that.message,_that.status,_that.paymentStatus,_that.expiresAt,_that.statusHistory,_that.commissionAmount,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String hotelId,  String hotelName,  String? hotelCity,  String? hotelPhoto,  String orgId,  String? orgName,  String roomTypeId,  String roomTypeName,  String? offerTitle,  int discountPercent,  String clientUid,  ClientSnapshot clientSnapshot, @TimestampConverter()  DateTime? checkIn, @TimestampConverter()  DateTime? checkOut,  int nights,  int adults,  int children,  int rooms,  Money? pricePerNight,  Money estimatedTotal,  String message,  BookingStatus status,  BookingPayment paymentStatus, @TimestampConverter()  DateTime? expiresAt,  List<StatusEvent> statusHistory,  Money? commissionAmount, @TimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BookingRequest():
return $default(_that.id,_that.hotelId,_that.hotelName,_that.hotelCity,_that.hotelPhoto,_that.orgId,_that.orgName,_that.roomTypeId,_that.roomTypeName,_that.offerTitle,_that.discountPercent,_that.clientUid,_that.clientSnapshot,_that.checkIn,_that.checkOut,_that.nights,_that.adults,_that.children,_that.rooms,_that.pricePerNight,_that.estimatedTotal,_that.message,_that.status,_that.paymentStatus,_that.expiresAt,_that.statusHistory,_that.commissionAmount,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String hotelId,  String hotelName,  String? hotelCity,  String? hotelPhoto,  String orgId,  String? orgName,  String roomTypeId,  String roomTypeName,  String? offerTitle,  int discountPercent,  String clientUid,  ClientSnapshot clientSnapshot, @TimestampConverter()  DateTime? checkIn, @TimestampConverter()  DateTime? checkOut,  int nights,  int adults,  int children,  int rooms,  Money? pricePerNight,  Money estimatedTotal,  String message,  BookingStatus status,  BookingPayment paymentStatus, @TimestampConverter()  DateTime? expiresAt,  List<StatusEvent> statusHistory,  Money? commissionAmount, @TimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BookingRequest() when $default != null:
return $default(_that.id,_that.hotelId,_that.hotelName,_that.hotelCity,_that.hotelPhoto,_that.orgId,_that.orgName,_that.roomTypeId,_that.roomTypeName,_that.offerTitle,_that.discountPercent,_that.clientUid,_that.clientSnapshot,_that.checkIn,_that.checkOut,_that.nights,_that.adults,_that.children,_that.rooms,_that.pricePerNight,_that.estimatedTotal,_that.message,_that.status,_that.paymentStatus,_that.expiresAt,_that.statusHistory,_that.commissionAmount,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingRequest extends BookingRequest {
  const _BookingRequest({@JsonKey(includeToJson: false) this.id = '', required this.hotelId, this.hotelName = '', this.hotelCity, this.hotelPhoto, required this.orgId, this.orgName, this.roomTypeId = '', this.roomTypeName = '', this.offerTitle, this.discountPercent = 0, required this.clientUid, this.clientSnapshot = const ClientSnapshot(), @TimestampConverter() this.checkIn, @TimestampConverter() this.checkOut, this.nights = 1, this.adults = 1, this.children = 0, this.rooms = 1, this.pricePerNight, this.estimatedTotal = Money.zero, this.message = '', this.status = BookingStatus.pending, this.paymentStatus = BookingPayment.unpaid, @TimestampConverter() this.expiresAt, final  List<StatusEvent> statusHistory = const [], this.commissionAmount, @TimestampConverter() this.createdAt}): _statusHistory = statusHistory,super._();
  factory _BookingRequest.fromJson(Map<String, dynamic> json) => _$BookingRequestFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String hotelId;
@override@JsonKey() final  String hotelName;
@override final  String? hotelCity;
@override final  String? hotelPhoto;
@override final  String orgId;
@override final  String? orgName;
@override@JsonKey() final  String roomTypeId;
@override@JsonKey() final  String roomTypeName;
@override final  String? offerTitle;
@override@JsonKey() final  int discountPercent;
@override final  String clientUid;
@override@JsonKey() final  ClientSnapshot clientSnapshot;
@override@TimestampConverter() final  DateTime? checkIn;
@override@TimestampConverter() final  DateTime? checkOut;
@override@JsonKey() final  int nights;
@override@JsonKey() final  int adults;
@override@JsonKey() final  int children;
@override@JsonKey() final  int rooms;
@override final  Money? pricePerNight;
@override@JsonKey() final  Money estimatedTotal;
@override@JsonKey() final  String message;
@override@JsonKey() final  BookingStatus status;
@override@JsonKey() final  BookingPayment paymentStatus;
@override@TimestampConverter() final  DateTime? expiresAt;
 final  List<StatusEvent> _statusHistory;
@override@JsonKey() List<StatusEvent> get statusHistory {
  if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_statusHistory);
}

@override final  Money? commissionAmount;
@override@TimestampConverter() final  DateTime? createdAt;

/// Create a copy of BookingRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingRequestCopyWith<_BookingRequest> get copyWith => __$BookingRequestCopyWithImpl<_BookingRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.hotelId, hotelId) || other.hotelId == hotelId)&&(identical(other.hotelName, hotelName) || other.hotelName == hotelName)&&(identical(other.hotelCity, hotelCity) || other.hotelCity == hotelCity)&&(identical(other.hotelPhoto, hotelPhoto) || other.hotelPhoto == hotelPhoto)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.roomTypeId, roomTypeId) || other.roomTypeId == roomTypeId)&&(identical(other.roomTypeName, roomTypeName) || other.roomTypeName == roomTypeName)&&(identical(other.offerTitle, offerTitle) || other.offerTitle == offerTitle)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.clientUid, clientUid) || other.clientUid == clientUid)&&(identical(other.clientSnapshot, clientSnapshot) || other.clientSnapshot == clientSnapshot)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.nights, nights) || other.nights == nights)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.children, children) || other.children == children)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.pricePerNight, pricePerNight) || other.pricePerNight == pricePerNight)&&(identical(other.estimatedTotal, estimatedTotal) || other.estimatedTotal == estimatedTotal)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other._statusHistory, _statusHistory)&&(identical(other.commissionAmount, commissionAmount) || other.commissionAmount == commissionAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,hotelId,hotelName,hotelCity,hotelPhoto,orgId,orgName,roomTypeId,roomTypeName,offerTitle,discountPercent,clientUid,clientSnapshot,checkIn,checkOut,nights,adults,children,rooms,pricePerNight,estimatedTotal,message,status,paymentStatus,expiresAt,const DeepCollectionEquality().hash(_statusHistory),commissionAmount,createdAt]);

@override
String toString() {
  return 'BookingRequest(id: $id, hotelId: $hotelId, hotelName: $hotelName, hotelCity: $hotelCity, hotelPhoto: $hotelPhoto, orgId: $orgId, orgName: $orgName, roomTypeId: $roomTypeId, roomTypeName: $roomTypeName, offerTitle: $offerTitle, discountPercent: $discountPercent, clientUid: $clientUid, clientSnapshot: $clientSnapshot, checkIn: $checkIn, checkOut: $checkOut, nights: $nights, adults: $adults, children: $children, rooms: $rooms, pricePerNight: $pricePerNight, estimatedTotal: $estimatedTotal, message: $message, status: $status, paymentStatus: $paymentStatus, expiresAt: $expiresAt, statusHistory: $statusHistory, commissionAmount: $commissionAmount, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BookingRequestCopyWith<$Res> implements $BookingRequestCopyWith<$Res> {
  factory _$BookingRequestCopyWith(_BookingRequest value, $Res Function(_BookingRequest) _then) = __$BookingRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String hotelId, String hotelName, String? hotelCity, String? hotelPhoto, String orgId, String? orgName, String roomTypeId, String roomTypeName, String? offerTitle, int discountPercent, String clientUid, ClientSnapshot clientSnapshot,@TimestampConverter() DateTime? checkIn,@TimestampConverter() DateTime? checkOut, int nights, int adults, int children, int rooms, Money? pricePerNight, Money estimatedTotal, String message, BookingStatus status, BookingPayment paymentStatus,@TimestampConverter() DateTime? expiresAt, List<StatusEvent> statusHistory, Money? commissionAmount,@TimestampConverter() DateTime? createdAt
});


@override $ClientSnapshotCopyWith<$Res> get clientSnapshot;

}
/// @nodoc
class __$BookingRequestCopyWithImpl<$Res>
    implements _$BookingRequestCopyWith<$Res> {
  __$BookingRequestCopyWithImpl(this._self, this._then);

  final _BookingRequest _self;
  final $Res Function(_BookingRequest) _then;

/// Create a copy of BookingRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hotelId = null,Object? hotelName = null,Object? hotelCity = freezed,Object? hotelPhoto = freezed,Object? orgId = null,Object? orgName = freezed,Object? roomTypeId = null,Object? roomTypeName = null,Object? offerTitle = freezed,Object? discountPercent = null,Object? clientUid = null,Object? clientSnapshot = null,Object? checkIn = freezed,Object? checkOut = freezed,Object? nights = null,Object? adults = null,Object? children = null,Object? rooms = null,Object? pricePerNight = freezed,Object? estimatedTotal = null,Object? message = null,Object? status = null,Object? paymentStatus = null,Object? expiresAt = freezed,Object? statusHistory = null,Object? commissionAmount = freezed,Object? createdAt = freezed,}) {
  return _then(_BookingRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hotelId: null == hotelId ? _self.hotelId : hotelId // ignore: cast_nullable_to_non_nullable
as String,hotelName: null == hotelName ? _self.hotelName : hotelName // ignore: cast_nullable_to_non_nullable
as String,hotelCity: freezed == hotelCity ? _self.hotelCity : hotelCity // ignore: cast_nullable_to_non_nullable
as String?,hotelPhoto: freezed == hotelPhoto ? _self.hotelPhoto : hotelPhoto // ignore: cast_nullable_to_non_nullable
as String?,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,roomTypeId: null == roomTypeId ? _self.roomTypeId : roomTypeId // ignore: cast_nullable_to_non_nullable
as String,roomTypeName: null == roomTypeName ? _self.roomTypeName : roomTypeName // ignore: cast_nullable_to_non_nullable
as String,offerTitle: freezed == offerTitle ? _self.offerTitle : offerTitle // ignore: cast_nullable_to_non_nullable
as String?,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int,clientUid: null == clientUid ? _self.clientUid : clientUid // ignore: cast_nullable_to_non_nullable
as String,clientSnapshot: null == clientSnapshot ? _self.clientSnapshot : clientSnapshot // ignore: cast_nullable_to_non_nullable
as ClientSnapshot,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOut: freezed == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as DateTime?,nights: null == nights ? _self.nights : nights // ignore: cast_nullable_to_non_nullable
as int,adults: null == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as int,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int,pricePerNight: freezed == pricePerNight ? _self.pricePerNight : pricePerNight // ignore: cast_nullable_to_non_nullable
as Money?,estimatedTotal: null == estimatedTotal ? _self.estimatedTotal : estimatedTotal // ignore: cast_nullable_to_non_nullable
as Money,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as BookingPayment,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusHistory: null == statusHistory ? _self._statusHistory : statusHistory // ignore: cast_nullable_to_non_nullable
as List<StatusEvent>,commissionAmount: freezed == commissionAmount ? _self.commissionAmount : commissionAmount // ignore: cast_nullable_to_non_nullable
as Money?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of BookingRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientSnapshotCopyWith<$Res> get clientSnapshot {
  
  return $ClientSnapshotCopyWith<$Res>(_self.clientSnapshot, (value) {
    return _then(_self.copyWith(clientSnapshot: value));
  });
}
}


/// @nodoc
mixin _$Lead {

@JsonKey(includeToJson: false) String get id; LeadType get type; String get targetType; String get targetId; String get targetTitle; String? get targetCity; String? get targetPhoto; String? get unitLabel; String get orgId; String? get orgName; String get clientUid; ClientSnapshot get clientSnapshot; String get message; String get preferredDates; LeadStatus get status;@TimestampConverter() DateTime? get visitAt;@TimestampConverter() DateTime? get createdAt;
/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadCopyWith<Lead> get copyWith => _$LeadCopyWithImpl<Lead>(this as Lead, _$identity);

  /// Serializes this Lead to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lead&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.targetTitle, targetTitle) || other.targetTitle == targetTitle)&&(identical(other.targetCity, targetCity) || other.targetCity == targetCity)&&(identical(other.targetPhoto, targetPhoto) || other.targetPhoto == targetPhoto)&&(identical(other.unitLabel, unitLabel) || other.unitLabel == unitLabel)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.clientUid, clientUid) || other.clientUid == clientUid)&&(identical(other.clientSnapshot, clientSnapshot) || other.clientSnapshot == clientSnapshot)&&(identical(other.message, message) || other.message == message)&&(identical(other.preferredDates, preferredDates) || other.preferredDates == preferredDates)&&(identical(other.status, status) || other.status == status)&&(identical(other.visitAt, visitAt) || other.visitAt == visitAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,targetType,targetId,targetTitle,targetCity,targetPhoto,unitLabel,orgId,orgName,clientUid,clientSnapshot,message,preferredDates,status,visitAt,createdAt);

@override
String toString() {
  return 'Lead(id: $id, type: $type, targetType: $targetType, targetId: $targetId, targetTitle: $targetTitle, targetCity: $targetCity, targetPhoto: $targetPhoto, unitLabel: $unitLabel, orgId: $orgId, orgName: $orgName, clientUid: $clientUid, clientSnapshot: $clientSnapshot, message: $message, preferredDates: $preferredDates, status: $status, visitAt: $visitAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LeadCopyWith<$Res>  {
  factory $LeadCopyWith(Lead value, $Res Function(Lead) _then) = _$LeadCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, LeadType type, String targetType, String targetId, String targetTitle, String? targetCity, String? targetPhoto, String? unitLabel, String orgId, String? orgName, String clientUid, ClientSnapshot clientSnapshot, String message, String preferredDates, LeadStatus status,@TimestampConverter() DateTime? visitAt,@TimestampConverter() DateTime? createdAt
});


$ClientSnapshotCopyWith<$Res> get clientSnapshot;

}
/// @nodoc
class _$LeadCopyWithImpl<$Res>
    implements $LeadCopyWith<$Res> {
  _$LeadCopyWithImpl(this._self, this._then);

  final Lead _self;
  final $Res Function(Lead) _then;

/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? targetType = null,Object? targetId = null,Object? targetTitle = null,Object? targetCity = freezed,Object? targetPhoto = freezed,Object? unitLabel = freezed,Object? orgId = null,Object? orgName = freezed,Object? clientUid = null,Object? clientSnapshot = null,Object? message = null,Object? preferredDates = null,Object? status = null,Object? visitAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LeadType,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,targetTitle: null == targetTitle ? _self.targetTitle : targetTitle // ignore: cast_nullable_to_non_nullable
as String,targetCity: freezed == targetCity ? _self.targetCity : targetCity // ignore: cast_nullable_to_non_nullable
as String?,targetPhoto: freezed == targetPhoto ? _self.targetPhoto : targetPhoto // ignore: cast_nullable_to_non_nullable
as String?,unitLabel: freezed == unitLabel ? _self.unitLabel : unitLabel // ignore: cast_nullable_to_non_nullable
as String?,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,clientUid: null == clientUid ? _self.clientUid : clientUid // ignore: cast_nullable_to_non_nullable
as String,clientSnapshot: null == clientSnapshot ? _self.clientSnapshot : clientSnapshot // ignore: cast_nullable_to_non_nullable
as ClientSnapshot,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,preferredDates: null == preferredDates ? _self.preferredDates : preferredDates // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,visitAt: freezed == visitAt ? _self.visitAt : visitAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientSnapshotCopyWith<$Res> get clientSnapshot {
  
  return $ClientSnapshotCopyWith<$Res>(_self.clientSnapshot, (value) {
    return _then(_self.copyWith(clientSnapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [Lead].
extension LeadPatterns on Lead {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lead value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lead() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lead value)  $default,){
final _that = this;
switch (_that) {
case _Lead():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lead value)?  $default,){
final _that = this;
switch (_that) {
case _Lead() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  LeadType type,  String targetType,  String targetId,  String targetTitle,  String? targetCity,  String? targetPhoto,  String? unitLabel,  String orgId,  String? orgName,  String clientUid,  ClientSnapshot clientSnapshot,  String message,  String preferredDates,  LeadStatus status, @TimestampConverter()  DateTime? visitAt, @TimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lead() when $default != null:
return $default(_that.id,_that.type,_that.targetType,_that.targetId,_that.targetTitle,_that.targetCity,_that.targetPhoto,_that.unitLabel,_that.orgId,_that.orgName,_that.clientUid,_that.clientSnapshot,_that.message,_that.preferredDates,_that.status,_that.visitAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  LeadType type,  String targetType,  String targetId,  String targetTitle,  String? targetCity,  String? targetPhoto,  String? unitLabel,  String orgId,  String? orgName,  String clientUid,  ClientSnapshot clientSnapshot,  String message,  String preferredDates,  LeadStatus status, @TimestampConverter()  DateTime? visitAt, @TimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Lead():
return $default(_that.id,_that.type,_that.targetType,_that.targetId,_that.targetTitle,_that.targetCity,_that.targetPhoto,_that.unitLabel,_that.orgId,_that.orgName,_that.clientUid,_that.clientSnapshot,_that.message,_that.preferredDates,_that.status,_that.visitAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  LeadType type,  String targetType,  String targetId,  String targetTitle,  String? targetCity,  String? targetPhoto,  String? unitLabel,  String orgId,  String? orgName,  String clientUid,  ClientSnapshot clientSnapshot,  String message,  String preferredDates,  LeadStatus status, @TimestampConverter()  DateTime? visitAt, @TimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Lead() when $default != null:
return $default(_that.id,_that.type,_that.targetType,_that.targetId,_that.targetTitle,_that.targetCity,_that.targetPhoto,_that.unitLabel,_that.orgId,_that.orgName,_that.clientUid,_that.clientSnapshot,_that.message,_that.preferredDates,_that.status,_that.visitAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lead implements Lead {
  const _Lead({@JsonKey(includeToJson: false) this.id = '', this.type = LeadType.contact, this.targetType = 'property', required this.targetId, this.targetTitle = '', this.targetCity, this.targetPhoto, this.unitLabel, required this.orgId, this.orgName, required this.clientUid, this.clientSnapshot = const ClientSnapshot(), this.message = '', this.preferredDates = '', this.status = LeadStatus.fresh, @TimestampConverter() this.visitAt, @TimestampConverter() this.createdAt});
  factory _Lead.fromJson(Map<String, dynamic> json) => _$LeadFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override@JsonKey() final  LeadType type;
@override@JsonKey() final  String targetType;
@override final  String targetId;
@override@JsonKey() final  String targetTitle;
@override final  String? targetCity;
@override final  String? targetPhoto;
@override final  String? unitLabel;
@override final  String orgId;
@override final  String? orgName;
@override final  String clientUid;
@override@JsonKey() final  ClientSnapshot clientSnapshot;
@override@JsonKey() final  String message;
@override@JsonKey() final  String preferredDates;
@override@JsonKey() final  LeadStatus status;
@override@TimestampConverter() final  DateTime? visitAt;
@override@TimestampConverter() final  DateTime? createdAt;

/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadCopyWith<_Lead> get copyWith => __$LeadCopyWithImpl<_Lead>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lead&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.targetTitle, targetTitle) || other.targetTitle == targetTitle)&&(identical(other.targetCity, targetCity) || other.targetCity == targetCity)&&(identical(other.targetPhoto, targetPhoto) || other.targetPhoto == targetPhoto)&&(identical(other.unitLabel, unitLabel) || other.unitLabel == unitLabel)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.orgName, orgName) || other.orgName == orgName)&&(identical(other.clientUid, clientUid) || other.clientUid == clientUid)&&(identical(other.clientSnapshot, clientSnapshot) || other.clientSnapshot == clientSnapshot)&&(identical(other.message, message) || other.message == message)&&(identical(other.preferredDates, preferredDates) || other.preferredDates == preferredDates)&&(identical(other.status, status) || other.status == status)&&(identical(other.visitAt, visitAt) || other.visitAt == visitAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,targetType,targetId,targetTitle,targetCity,targetPhoto,unitLabel,orgId,orgName,clientUid,clientSnapshot,message,preferredDates,status,visitAt,createdAt);

@override
String toString() {
  return 'Lead(id: $id, type: $type, targetType: $targetType, targetId: $targetId, targetTitle: $targetTitle, targetCity: $targetCity, targetPhoto: $targetPhoto, unitLabel: $unitLabel, orgId: $orgId, orgName: $orgName, clientUid: $clientUid, clientSnapshot: $clientSnapshot, message: $message, preferredDates: $preferredDates, status: $status, visitAt: $visitAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LeadCopyWith<$Res> implements $LeadCopyWith<$Res> {
  factory _$LeadCopyWith(_Lead value, $Res Function(_Lead) _then) = __$LeadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, LeadType type, String targetType, String targetId, String targetTitle, String? targetCity, String? targetPhoto, String? unitLabel, String orgId, String? orgName, String clientUid, ClientSnapshot clientSnapshot, String message, String preferredDates, LeadStatus status,@TimestampConverter() DateTime? visitAt,@TimestampConverter() DateTime? createdAt
});


@override $ClientSnapshotCopyWith<$Res> get clientSnapshot;

}
/// @nodoc
class __$LeadCopyWithImpl<$Res>
    implements _$LeadCopyWith<$Res> {
  __$LeadCopyWithImpl(this._self, this._then);

  final _Lead _self;
  final $Res Function(_Lead) _then;

/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? targetType = null,Object? targetId = null,Object? targetTitle = null,Object? targetCity = freezed,Object? targetPhoto = freezed,Object? unitLabel = freezed,Object? orgId = null,Object? orgName = freezed,Object? clientUid = null,Object? clientSnapshot = null,Object? message = null,Object? preferredDates = null,Object? status = null,Object? visitAt = freezed,Object? createdAt = freezed,}) {
  return _then(_Lead(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LeadType,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,targetTitle: null == targetTitle ? _self.targetTitle : targetTitle // ignore: cast_nullable_to_non_nullable
as String,targetCity: freezed == targetCity ? _self.targetCity : targetCity // ignore: cast_nullable_to_non_nullable
as String?,targetPhoto: freezed == targetPhoto ? _self.targetPhoto : targetPhoto // ignore: cast_nullable_to_non_nullable
as String?,unitLabel: freezed == unitLabel ? _self.unitLabel : unitLabel // ignore: cast_nullable_to_non_nullable
as String?,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,orgName: freezed == orgName ? _self.orgName : orgName // ignore: cast_nullable_to_non_nullable
as String?,clientUid: null == clientUid ? _self.clientUid : clientUid // ignore: cast_nullable_to_non_nullable
as String,clientSnapshot: null == clientSnapshot ? _self.clientSnapshot : clientSnapshot // ignore: cast_nullable_to_non_nullable
as ClientSnapshot,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,preferredDates: null == preferredDates ? _self.preferredDates : preferredDates // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,visitAt: freezed == visitAt ? _self.visitAt : visitAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClientSnapshotCopyWith<$Res> get clientSnapshot {
  
  return $ClientSnapshotCopyWith<$Res>(_self.clientSnapshot, (value) {
    return _then(_self.copyWith(clientSnapshot: value));
  });
}
}


/// @nodoc
mixin _$ChatMessage {

@JsonKey(includeToJson: false) String get id; String get fromUid; String get fromRole; String get text;@TimestampConverter() DateTime? get createdAt;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUid, fromUid) || other.fromUid == fromUid)&&(identical(other.fromRole, fromRole) || other.fromRole == fromRole)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUid,fromRole,text,createdAt);

@override
String toString() {
  return 'ChatMessage(id: $id, fromUid: $fromUid, fromRole: $fromRole, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false) String id, String fromUid, String fromRole, String text,@TimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fromUid = null,Object? fromRole = null,Object? text = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUid: null == fromUid ? _self.fromUid : fromUid // ignore: cast_nullable_to_non_nullable
as String,fromRole: null == fromRole ? _self.fromRole : fromRole // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String fromUid,  String fromRole,  String text, @TimestampConverter()  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.fromUid,_that.fromRole,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false)  String id,  String fromUid,  String fromRole,  String text, @TimestampConverter()  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.fromUid,_that.fromRole,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false)  String id,  String fromUid,  String fromRole,  String text, @TimestampConverter()  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.fromUid,_that.fromRole,_that.text,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({@JsonKey(includeToJson: false) this.id = '', required this.fromUid, this.fromRole = 'client', this.text = '', @TimestampConverter() this.createdAt});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override@JsonKey(includeToJson: false) final  String id;
@override final  String fromUid;
@override@JsonKey() final  String fromRole;
@override@JsonKey() final  String text;
@override@TimestampConverter() final  DateTime? createdAt;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.fromUid, fromUid) || other.fromUid == fromUid)&&(identical(other.fromRole, fromRole) || other.fromRole == fromRole)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fromUid,fromRole,text,createdAt);

@override
String toString() {
  return 'ChatMessage(id: $id, fromUid: $fromUid, fromRole: $fromRole, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false) String id, String fromUid, String fromRole, String text,@TimestampConverter() DateTime? createdAt
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fromUid = null,Object? fromRole = null,Object? text = null,Object? createdAt = freezed,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fromUid: null == fromUid ? _self.fromUid : fromUid // ignore: cast_nullable_to_non_nullable
as String,fromRole: null == fromRole ? _self.fromRole : fromRole // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
