import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

class Booking {
  final String id;
  final String userId;
  final String doctorId;
  final DateTime appointmentDate;
  final String timeSlot;
  final BookingStatus status;
  final DateTime createdAt;
  final String? notes;
  final double consultationFee;

  Booking({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.appointmentDate,
    required this.timeSlot,
    required this.status,
    required this.createdAt,
    required this.consultationFee,
    this.notes,
  });

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      id: id,
      userId: map['userId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      appointmentDate: (map['appointmentDate'] as Timestamp).toDate(),
      timeSlot: map['timeSlot'] ?? '',
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${map['status']}',
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      consultationFee: (map['consultationFee'] ?? 0.0).toDouble(),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'doctorId': doctorId,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'timeSlot': timeSlot,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'consultationFee': consultationFee,
      'notes': notes,
    };
  }

  Booking copyWith({
    String? userId,
    String? doctorId,
    DateTime? appointmentDate,
    String? timeSlot,
    BookingStatus? status,
    String? notes,
    double? consultationFee,
  }) {
    return Booking(
      id: id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      createdAt: createdAt,
      consultationFee: consultationFee ?? this.consultationFee,
      notes: notes ?? this.notes,
    );
  }
}
