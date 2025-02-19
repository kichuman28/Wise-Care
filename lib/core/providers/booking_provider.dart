import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Booking> _bookings = [];
  bool _isLoading = false;
  String? _error;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserBookings(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('appointmentDate', descending: true)
          .get();

      _bookings = snapshot.docs.map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<String> createBooking(Booking booking) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final docRef = await _firestore.collection('bookings').add(booking.toMap());
      await loadUserBookings(booking.userId);

      return docRef.id;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status.toString().split('.').last,
      });

      final booking = _bookings.firstWhere((b) => b.id == bookingId);
      await loadUserBookings(booking.userId);
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    await updateBookingStatus(bookingId, BookingStatus.cancelled);
  }

  Future<List<Booking>> getDoctorBookings(String doctorId, DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isGreaterThanOrEqualTo: startOfDay)
          .where('appointmentDate', isLessThan: endOfDay)
          .get();

      return snapshot.docs.map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<bool> isTimeSlotAvailable(
    String doctorId,
    DateTime date,
    String timeSlot,
  ) async {
    try {
      final bookings = await getDoctorBookings(doctorId, date);
      return !bookings.any((booking) => booking.timeSlot == timeSlot && booking.status != BookingStatus.cancelled);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
