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

      final QuerySnapshot snapshot = await _firestore.collection('doctors').where('isAvailable', isEqualTo: true).get();

      _doctors = snapshot.docs.map((doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('doctors').doc(doctorId).get();
      if (!doc.exists) return null;
      return Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
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
}
