import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  bool _isLoading = false;
  List<Order> _orders = [];

  bool get isLoading => _isLoading;
  List<Order> get orders => _orders;

  Future<void> createOrder(Order order) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('orders').add(order.toJson());

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Stream<List<Order>> getUserOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Order.fromJson(doc.data(), doc.id)).toList());
  }

  Future<void> loadUserOrders(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('orderDate', descending: true)
          .get();

      _orders = snapshot.docs.map((doc) => Order.fromJson(doc.data(), doc.id)).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({'status': status});

      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        final updatedOrder = Order(
          id: _orders[index].id,
          userId: _orders[index].userId,
          prescriptionId: _orders[index].prescriptionId,
          medicines: _orders[index].medicines,
          orderDate: _orders[index].orderDate,
          status: status,
          totalAmount: _orders[index].totalAmount,
          deliveryAddress: _orders[index].deliveryAddress,
        );
        _orders[index] = updatedOrder;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
