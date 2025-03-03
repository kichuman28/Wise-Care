import 'package:cloud_firestore/cloud_firestore.dart';

class OrderMedicine {
  final String medicineId;
  final String medicineName;
  final String dosage;
  final String frequency;
  final int daysSupply;
  final int quantity;
  final double pricePerUnit;
  final double totalPrice;

  OrderMedicine({
    required this.medicineId,
    required this.medicineName,
    required this.dosage,
    required this.frequency,
    required this.daysSupply,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'medicineName': medicineName,
        'dosage': dosage,
        'frequency': frequency,
        'daysSupply': daysSupply,
        'quantity': quantity,
        'pricePerUnit': pricePerUnit,
        'totalPrice': totalPrice,
      };

  factory OrderMedicine.fromJson(Map<String, dynamic> json) => OrderMedicine(
        medicineId: json['medicineId'] as String,
        medicineName: json['medicineName'] as String,
        dosage: json['dosage'] as String,
        frequency: json['frequency'] as String,
        daysSupply: json['daysSupply'] as int,
        quantity: json['quantity'] as int,
        pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
        totalPrice: (json['totalPrice'] as num).toDouble(),
      );
}

class Order {
  final String? id;
  final String userId;
  final String prescriptionId;
  final List<OrderMedicine> medicines;
  final DateTime orderDate;
  final String status;
  final double totalAmount;
  final String? addressId;

  Order({
    this.id,
    required this.userId,
    required this.prescriptionId,
    required this.medicines,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    this.addressId,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'prescriptionId': prescriptionId,
        'medicines': medicines.map((m) => m.toJson()).toList(),
        'orderDate': Timestamp.fromDate(orderDate),
        'status': status,
        'totalAmount': totalAmount,
        'addressId': addressId,
      };

  factory Order.fromJson(Map<String, dynamic> json, String orderId) => Order(
        id: orderId,
        userId: json['userId'] as String,
        prescriptionId: json['prescriptionId'] as String,
        medicines: (json['medicines'] as List)
            .map((m) => OrderMedicine.fromJson(m as Map<String, dynamic>))
            .toList(),
        orderDate: (json['orderDate'] as Timestamp).toDate(),
        status: json['status'] as String,
        totalAmount: (json['totalAmount'] as num).toDouble(),
        addressId: json['addressId'] as String?,
      );
}
