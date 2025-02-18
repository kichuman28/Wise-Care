import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/emergency_contact_model.dart';

class EmergencyContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<EmergencyContact>> getEmergencyContacts(String userId) async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('users').doc(userId).collection('emergency_contacts').get();

      return snapshot.docs.map((doc) {
        return EmergencyContact.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get emergency contacts: $e');
    }
  }

  Future<void> addEmergencyContact(EmergencyContact contact) async {
    try {
      await _firestore.collection('users').doc(contact.userId).collection('emergency_contacts').add(contact.toMap());
    } catch (e) {
      throw Exception('Failed to add emergency contact: $e');
    }
  }

  Future<void> updateEmergencyContact(EmergencyContact contact) async {
    try {
      await _firestore
          .collection('users')
          .doc(contact.userId)
          .collection('emergency_contacts')
          .doc(contact.id)
          .update(contact.toMap());
    } catch (e) {
      throw Exception('Failed to update emergency contact: $e');
    }
  }

  Future<void> deleteEmergencyContact(String userId, String contactId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('emergency_contacts').doc(contactId).delete();
    } catch (e) {
      throw Exception('Failed to delete emergency contact: $e');
    }
  }
}
