// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientSnapshot _$ClientSnapshotFromJson(Map<String, dynamic> json) =>
    _ClientSnapshot(
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ClientSnapshotToJson(_ClientSnapshot instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': ?instance.phone,
      'email': ?instance.email,
    };

_StatusEvent _$StatusEventFromJson(Map<String, dynamic> json) => _StatusEvent(
  status: json['status'] as String? ?? '',
  by: json['by'] as String?,
  at: const TimestampConverter().fromJson(json['at']),
  note: json['note'] as String?,
);

Map<String, dynamic> _$StatusEventToJson(_StatusEvent instance) =>
    <String, dynamic>{
      'status': instance.status,
      'by': ?instance.by,
      'at': ?const TimestampConverter().toJson(instance.at),
      'note': ?instance.note,
    };

_BookingRequest _$BookingRequestFromJson(Map<String, dynamic> json) =>
    _BookingRequest(
      id: json['id'] as String? ?? '',
      hotelId: json['hotelId'] as String,
      hotelName: json['hotelName'] as String? ?? '',
      hotelCity: json['hotelCity'] as String?,
      hotelPhoto: json['hotelPhoto'] as String?,
      orgId: json['orgId'] as String,
      orgName: json['orgName'] as String?,
      roomTypeId: json['roomTypeId'] as String? ?? '',
      roomTypeName: json['roomTypeName'] as String? ?? '',
      offerTitle: json['offerTitle'] as String?,
      discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
      clientUid: json['clientUid'] as String,
      clientSnapshot: json['clientSnapshot'] == null
          ? const ClientSnapshot()
          : ClientSnapshot.fromJson(
              json['clientSnapshot'] as Map<String, dynamic>,
            ),
      checkIn: const TimestampConverter().fromJson(json['checkIn']),
      checkOut: const TimestampConverter().fromJson(json['checkOut']),
      nights: (json['nights'] as num?)?.toInt() ?? 1,
      adults: (json['adults'] as num?)?.toInt() ?? 1,
      children: (json['children'] as num?)?.toInt() ?? 0,
      rooms: (json['rooms'] as num?)?.toInt() ?? 1,
      pricePerNight: json['pricePerNight'] == null
          ? null
          : Money.fromJson(json['pricePerNight'] as Map<String, dynamic>),
      estimatedTotal: json['estimatedTotal'] == null
          ? Money.zero
          : Money.fromJson(json['estimatedTotal'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
      status:
          $enumDecodeNullable(_$BookingStatusEnumMap, json['status']) ??
          BookingStatus.pending,
      paymentStatus:
          $enumDecodeNullable(_$BookingPaymentEnumMap, json['paymentStatus']) ??
          BookingPayment.unpaid,
      expiresAt: const TimestampConverter().fromJson(json['expiresAt']),
      statusHistory:
          (json['statusHistory'] as List<dynamic>?)
              ?.map((e) => StatusEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      commissionAmount: json['commissionAmount'] == null
          ? null
          : Money.fromJson(json['commissionAmount'] as Map<String, dynamic>),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$BookingRequestToJson(_BookingRequest instance) =>
    <String, dynamic>{
      'hotelId': instance.hotelId,
      'hotelName': instance.hotelName,
      'hotelCity': ?instance.hotelCity,
      'hotelPhoto': ?instance.hotelPhoto,
      'orgId': instance.orgId,
      'orgName': ?instance.orgName,
      'roomTypeId': instance.roomTypeId,
      'roomTypeName': instance.roomTypeName,
      'offerTitle': ?instance.offerTitle,
      'discountPercent': instance.discountPercent,
      'clientUid': instance.clientUid,
      'clientSnapshot': instance.clientSnapshot.toJson(),
      'checkIn': ?const TimestampConverter().toJson(instance.checkIn),
      'checkOut': ?const TimestampConverter().toJson(instance.checkOut),
      'nights': instance.nights,
      'adults': instance.adults,
      'children': instance.children,
      'rooms': instance.rooms,
      'pricePerNight': ?instance.pricePerNight?.toJson(),
      'estimatedTotal': instance.estimatedTotal.toJson(),
      'message': instance.message,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'paymentStatus': _$BookingPaymentEnumMap[instance.paymentStatus]!,
      'expiresAt': ?const TimestampConverter().toJson(instance.expiresAt),
      'statusHistory': instance.statusHistory.map((e) => e.toJson()).toList(),
      'commissionAmount': ?instance.commissionAmount?.toJson(),
      'createdAt': ?const TimestampConverter().toJson(instance.createdAt),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.infoRequested: 'info_requested',
  BookingStatus.accepted: 'accepted',
  BookingStatus.rejected: 'rejected',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.expired: 'expired',
  BookingStatus.completed: 'completed',
};

const _$BookingPaymentEnumMap = {
  BookingPayment.unpaid: 'unpaid',
  BookingPayment.paidSimulated: 'paid_simulated',
  BookingPayment.refundedSimulated: 'refunded_simulated',
  BookingPayment.paid: 'paid',
};

_Lead _$LeadFromJson(Map<String, dynamic> json) => _Lead(
  id: json['id'] as String? ?? '',
  type:
      $enumDecodeNullable(_$LeadTypeEnumMap, json['type']) ?? LeadType.contact,
  targetType: json['targetType'] as String? ?? 'property',
  targetId: json['targetId'] as String,
  targetTitle: json['targetTitle'] as String? ?? '',
  targetCity: json['targetCity'] as String?,
  targetPhoto: json['targetPhoto'] as String?,
  unitLabel: json['unitLabel'] as String?,
  orgId: json['orgId'] as String,
  orgName: json['orgName'] as String?,
  clientUid: json['clientUid'] as String,
  clientSnapshot: json['clientSnapshot'] == null
      ? const ClientSnapshot()
      : ClientSnapshot.fromJson(json['clientSnapshot'] as Map<String, dynamic>),
  message: json['message'] as String? ?? '',
  preferredDates: json['preferredDates'] as String? ?? '',
  status:
      $enumDecodeNullable(_$LeadStatusEnumMap, json['status']) ??
      LeadStatus.fresh,
  visitAt: const TimestampConverter().fromJson(json['visitAt']),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$LeadToJson(_Lead instance) => <String, dynamic>{
  'type': _$LeadTypeEnumMap[instance.type]!,
  'targetType': instance.targetType,
  'targetId': instance.targetId,
  'targetTitle': instance.targetTitle,
  'targetCity': ?instance.targetCity,
  'targetPhoto': ?instance.targetPhoto,
  'unitLabel': ?instance.unitLabel,
  'orgId': instance.orgId,
  'orgName': ?instance.orgName,
  'clientUid': instance.clientUid,
  'clientSnapshot': instance.clientSnapshot.toJson(),
  'message': instance.message,
  'preferredDates': instance.preferredDates,
  'status': _$LeadStatusEnumMap[instance.status]!,
  'visitAt': ?const TimestampConverter().toJson(instance.visitAt),
  'createdAt': ?const TimestampConverter().toJson(instance.createdAt),
};

const _$LeadTypeEnumMap = {
  LeadType.contact: 'contact',
  LeadType.visit: 'visit',
  LeadType.info: 'info',
};

const _$LeadStatusEnumMap = {
  LeadStatus.fresh: 'new',
  LeadStatus.inProgress: 'in_progress',
  LeadStatus.visitScheduled: 'visit_scheduled',
  LeadStatus.closed: 'closed',
};

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String? ?? '',
  fromUid: json['fromUid'] as String,
  fromRole: json['fromRole'] as String? ?? 'client',
  text: json['text'] as String? ?? '',
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'fromUid': instance.fromUid,
      'fromRole': instance.fromRole,
      'text': instance.text,
      'createdAt': ?const TimestampConverter().toJson(instance.createdAt),
    };
