import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'emergency_contact_service.dart';
import '../models/emergency_contact_model.dart';

class EmergencyNotificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmergencyContactService _contactService = EmergencyContactService();

  // In production, this should be configured via environment variables
  static const String apiUrl = 'https://nodejs-test-hosting.onrender.com/sendchat';

  Future<void> sendEmergencyNotification({
    required String alertId,
    required double latitude,
    required double longitude,
    bool isFallDetected = false,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Fetch emergency contacts using the dedicated service
      final List<EmergencyContact> contacts = await _contactService.getEmergencyContacts(user.uid);

      if (contacts.isEmpty) {
        throw Exception('No emergency contacts found');
      }

      // Send notification to each emergency contact
      for (final contact in contacts) {
        if (contact.phoneNumber.isEmpty) continue;

        final message = _createEmergencyMessage(
          userName: user.displayName ?? 'User',
          latitude: latitude,
          longitude: longitude,
          isFallDetected: isFallDetected,
        );

        await _sendApiRequest(phoneNumber: contact.phoneNumber, message: message);
      }
    } catch (e) {
      print('Failed to send emergency notification: $e');
      rethrow;
    }
  }

  String _createEmergencyMessage({
    required String userName,
    required double latitude,
    required double longitude,
    required bool isFallDetected,
  }) {
    final locationUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    final eventType = isFallDetected ? 'A fall was detected' : 'An SOS alert was triggered';

    return '''EMERGENCY ALERT: $eventType for $userName. 
Location: $locationUrl
Please respond immediately or contact emergency services.''';
  }

  Future<void> _sendApiRequest({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'message': message,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('API request failed with status: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      print('SendChat Response: $data');
    } catch (e) {
      print('API request error: $e');
      rethrow;
    }
  }
}
