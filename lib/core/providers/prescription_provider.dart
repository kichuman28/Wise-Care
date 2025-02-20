import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prescription_model.dart';

class PrescriptionProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Prescription> _prescriptions = [];
  bool _isLoading = false;
  String? _error;

  List<Prescription> get prescriptions => _prescriptions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserPrescriptions(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final QuerySnapshot snapshot = await _firestore
          .collection('prescriptions')
          .where('patientId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _prescriptions =
          snapshot.docs.map((doc) => Prescription.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Stream<List<Prescription>> getUserPrescriptionsStream(String userId) {
    return _firestore
        .collection('prescriptions')
        .where('patientId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Prescription.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<void> addPrescription(Prescription prescription) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('prescriptions').add(prescription.toMap());
      await loadUserPrescriptions(prescription.patientId);
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePrescription(Prescription prescription) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('prescriptions').doc(prescription.id).update(prescription.toMap());
      await loadUserPrescriptions(prescription.patientId);
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deletePrescription(Prescription prescription) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestore.collection('prescriptions').doc(prescription.id).delete();
      await loadUserPrescriptions(prescription.patientId);
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
