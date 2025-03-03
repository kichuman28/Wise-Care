import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_address_model.dart';

class UserAddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserAddress>> getUserAddresses(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .get();

      return snapshot.docs.map((doc) {
        return UserAddress.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get user addresses: $e');
    }
  }

  Future<UserAddress?> getDefaultAddress(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return UserAddress.fromMap(
        snapshot.docs.first.data() as Map<String, dynamic>,
        snapshot.docs.first.id,
      );
    } catch (e) {
      throw Exception('Failed to get default address: $e');
    }
  }

  Future<String> addUserAddress(UserAddress address) async {
    try {
      // If this is the first address or marked as default, ensure it's the only default
      if (address.isDefault) {
        await _clearDefaultAddresses(address.userId);
      }

      final docRef = await _firestore
          .collection('users')
          .doc(address.userId)
          .collection('addresses')
          .add(address.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add user address: $e');
    }
  }

  Future<void> updateUserAddress(UserAddress address) async {
    try {
      if (address.id == null) {
        throw Exception('Address ID cannot be null for update operation');
      }

      // If this address is being set as default, clear other defaults
      if (address.isDefault) {
        await _clearDefaultAddresses(address.userId);
      }

      await _firestore
          .collection('users')
          .doc(address.userId)
          .collection('addresses')
          .doc(address.id)
          .update(address.toMap());
    } catch (e) {
      throw Exception('Failed to update user address: $e');
    }
  }

  Future<void> deleteUserAddress(String userId, String addressId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete user address: $e');
    }
  }

  Future<void> _clearDefaultAddresses(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .where('isDefault', isEqualTo: true)
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }

      if (snapshot.docs.isNotEmpty) {
        await batch.commit();
      }
    } catch (e) {
      throw Exception('Failed to clear default addresses: $e');
    }
  }
}
