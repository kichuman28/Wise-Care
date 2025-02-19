import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';

class DoctorProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Doctor> _doctors = [];
  bool _isLoading = false;
  String? _error;

  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDoctors() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final QuerySnapshot snapshot = await _firestore.collection('doctors').get();
      _doctors = snapshot.docs.map((doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addDoctor(Doctor doctor) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('doctors').add(doctor.toMap());
      await loadDoctors();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('doctors').doc(doctor.id).update(doctor.toMap());
      await loadDoctors();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteDoctor(String doctorId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('doctors').doc(doctorId).delete();
      await loadDoctors();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addStaticDoctors() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final List<Map<String, dynamic>> staticDoctors = [
        {
          'name': 'Dr. Sarah Johnson',
          'mail': 'sarah@wisecare.in',
          'specialization': 'Cardiologist',
          'imageUrl': 'https://picsum.photos/200',
          'about': 'Experienced cardiologist with over 15 years of practice in treating heart conditions.',
          'rating': 4.8,
          'experience': 15,
          'patientsServed': 10000,
          'availableDays': ['Monday', 'Wednesday', 'Friday'],
          'availableTimeSlots': {
            'Monday': ['09:00', '10:00', '11:00', '14:00', '15:00'],
            'Wednesday': ['10:00', '11:00', '14:00', '15:00', '16:00'],
            'Friday': ['09:00', '10:00', '11:00', '14:00', '15:00'],
          },
          'consultationFee': 150.0,
          'isAvailable': true,
        },
        {
          'name': 'Dr. Michael Chen',
          'mail': 'michael@wisecare.in',
          'specialization': 'Neurologist',
          'imageUrl': 'https://picsum.photos/200',
          'about': 'Specialized in treating neurological disorders with a focus on innovative treatments.',
          'rating': 4.9,
          'experience': 12,
          'patientsServed': 8000,
          'availableDays': ['Tuesday', 'Thursday', 'Saturday'],
          'availableTimeSlots': {
            'Tuesday': ['09:00', '10:00', '11:00', '14:00', '15:00'],
            'Thursday': ['10:00', '11:00', '14:00', '15:00', '16:00'],
            'Saturday': ['09:00', '10:00', '11:00'],
          },
          'consultationFee': 180.0,
          'isAvailable': true,
        },
        {
          'name': 'Dr. Emily Rodriguez',
          'mail': 'emily@wisecare.in',
          'specialization': 'Pediatrician',
          'imageUrl': 'https://picsum.photos/200',
          'about': 'Dedicated alzheimer\'s care doctor.',
          'rating': 4.7,
          'experience': 8,
          'patientsServed': 6000,
          'availableDays': ['Monday', 'Tuesday', 'Thursday', 'Friday'],
          'availableTimeSlots': {
            'Monday': ['09:00', '10:00', '11:00', '14:00', '15:00'],
            'Tuesday': ['10:00', '11:00', '14:00', '15:00'],
            'Thursday': ['09:00', '10:00', '11:00', '14:00'],
            'Friday': ['10:00', '11:00', '14:00', '15:00'],
          },
          'consultationFee': 120.0,
          'isAvailable': true,
        },
      ];

      for (final doctorData in staticDoctors) {
        await _firestore.collection('doctors').add(doctorData);
      }

      await loadDoctors();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
