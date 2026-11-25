import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firestore_json.dart';
import '../../../core/money.dart';

part 'requests.freezed.dart';
part 'requests.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum BookingStatus {
  pending,
  infoRequested,
  accepted,
  rejected,
  cancelled,
  expired,
  completed;

  /// En attente d'une réponse de l'hôtel (soumise au délai de 48 h).
  bool get isOpen => this == pending || this == infoRequested;
}

@JsonEnum(fieldRename: FieldRename.snake)
enum BookingPayment { unpaid, paidSimulated, refundedSimulated, paid }

/// Actions sur une demande (fonction `updateBookingStatus`).
enum BookingAction {
  accept('accept'),
  reject('reject'),
  requestInfo('request_info'),
  complete('complete'),
  cancel('cancel');

  const BookingAction(this.key);

  final String key;
}

@freezed
abstract class ClientSnapshot with _$ClientSnapshot {
  const factory ClientSnapshot({@Default('') String name, String? phone, String? email}) = _ClientSnapshot;

  factory ClientSnapshot.fromJson(Map<String, dynamic> json) => _$ClientSnapshotFromJson(json);
}

@freezed
abstract class StatusEvent with _$StatusEvent {
  const factory StatusEvent({
    @Default('') String status,
    String? by,
    @TimestampConverter() DateTime? at,
    String? note,
  }) = _StatusEvent;

  factory StatusEvent.fromJson(Map<String, dynamic> json) => _$StatusEventFromJson(json);
}

/// Document `bookingRequests/{id}` (écrit par les Cloud Functions).
@freezed
abstract class BookingRequest with _$BookingRequest {
  const BookingRequest._();

  const factory BookingRequest({
    @JsonKey(includeToJson: false) @Default('') String id,
    required String hotelId,
    @Default('') String hotelName,
    String? hotelCity,
    String? hotelPhoto,
    required String orgId,
    String? orgName,
    @Default('') String roomTypeId,
    @Default('') String roomTypeName,
    String? offerTitle,
    @Default(0) int discountPercent,
    required String clientUid,
    @Default(ClientSnapshot()) ClientSnapshot clientSnapshot,
    @TimestampConverter() DateTime? checkIn,
    @TimestampConverter() DateTime? checkOut,
    @Default(1) int nights,
    @Default(1) int adults,
    @Default(0) int children,
    @Default(1) int rooms,
    Money? pricePerNight,
    @Default(Money.zero) Money estimatedTotal,
    @Default('') String message,
    @Default(BookingStatus.pending) BookingStatus status,
    @Default(BookingPayment.unpaid) BookingPayment paymentStatus,
    @TimestampConverter() DateTime? expiresAt,
    @Default([]) List<StatusEvent> statusHistory,
    Money? commissionAmount,
    @TimestampConverter() DateTime? createdAt,
  }) = _BookingRequest;

  factory BookingRequest.fromJson(Map<String, dynamic> json) => _$BookingRequestFromJson(json);

  bool get isPaid => paymentStatus == BookingPayment.paidSimulated || paymentStatus == BookingPayment.paid;

  bool get canPay => status == BookingStatus.accepted && paymentStatus == BookingPayment.unpaid;

  /// Le séjour a commencé : l'hôtel peut le déclarer terminé.
  bool hasStarted(DateTime now) => checkIn != null && !now.isBefore(checkIn!);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum LeadType { contact, visit, info }

@JsonEnum(fieldRename: FieldRename.snake)
enum LeadStatus {
  @JsonValue('new')
  fresh,
  inProgress,
  visitScheduled,
  closed;

  String get key => switch (this) {
    fresh => 'new',
    inProgress => 'in_progress',
    visitScheduled => 'visit_scheduled',
    closed => 'closed',
  };
}

/// Document `leads/{id}` : demande de contact, de visite ou d'information.
@freezed
abstract class Lead with _$Lead {
  const factory Lead({
    @JsonKey(includeToJson: false) @Default('') String id,
    @Default(LeadType.contact) LeadType type,
    @Default('property') String targetType,
    required String targetId,
    @Default('') String targetTitle,
    String? targetCity,
    String? targetPhoto,
    String? unitLabel,
    required String orgId,
    String? orgName,
    required String clientUid,
    @Default(ClientSnapshot()) ClientSnapshot clientSnapshot,
    @Default('') String message,
    @Default('') String preferredDates,
    @Default(LeadStatus.fresh) LeadStatus status,
    @TimestampConverter() DateTime? visitAt,
    @TimestampConverter() DateTime? createdAt,
  }) = _Lead;

  factory Lead.fromJson(Map<String, dynamic> json) => _$LeadFromJson(json);
}

/// Message d'une discussion (`.../messages/{id}`).
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @JsonKey(includeToJson: false) @Default('') String id,
    required String fromUid,
    @Default('client') String fromRole,
    @Default('') String text,
    @TimestampConverter() DateTime? createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
