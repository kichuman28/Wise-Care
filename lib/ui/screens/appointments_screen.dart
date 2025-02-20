import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/appointment_details_card.dart';

class AppointmentsScreen extends StatelessWidget {
  final String userId;

  const AppointmentsScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .orderBy('appointmentDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No appointments found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return AppointmentDetailsCard(
                appointmentId: doc.id,
                doctorId: data['doctorId'] ?? '',
                patientId: data['userId'] ?? '',
                appointmentTime: (data['appointmentDate'] as Timestamp).toDate(),
                status: data['status'] ?? 'pending',
                timeSlot: data['timeSlot'] ?? '',
                consultationFee: (data['consultationFee'] as num?)?.toDouble() ?? 0.0,
              );
            },
          );
        },
      ),
    );
  }
}
