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
  static const int maxRetries = 3;
  static const int batchSize = 3; // Send notifications to 3 contacts at a time

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

      final message = _createEmergencyMessage(
        userName: user.displayName ?? 'User',
        latitude: latitude,
        longitude: longitude,
        isFallDetected: isFallDetected,
      );

      // Process contacts in batches
      for (var i = 0; i < contacts.length; i += batchSize) {
        final end = (i + batchSize < contacts.length) ? i + batchSize : contacts.length;
        final batch = contacts.sublist(i, end);

        // Send notifications to this batch concurrently
        await Future.wait(
          batch.map((contact) async {
            if (contact.phoneNumber.isEmpty) return;

            // Try sending with retries
            for (var attempt = 1; attempt <= maxRetries; attempt++) {
              try {
                await _sendApiRequest(
                  phoneNumber: contact.phoneNumber,
                  message: message,
                );
                break; // Success, exit retry loop
              } catch (e) {
                if (attempt == maxRetries) {
                  print('Failed to send notification to ${contact.phoneNumber} after $maxRetries attempts: $e');
                } else {
                  // Wait before retrying, with exponential backoff
                  await Future.delayed(Duration(milliseconds: 500 * attempt));
                }
              }
            }
          }),
        );
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
    print('SendChat Response for $phoneNumber: $data');
  }
}
