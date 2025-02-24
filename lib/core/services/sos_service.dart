import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'emergency_notification_service.dart';

class SOSService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Battery _battery = Battery();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final EmergencyNotificationService _notificationService = EmergencyNotificationService();

  Future<String> createSOSAlert({
    required double latitude,
    required double longitude,
    required String priority,
    Map<String, dynamic>? medicalInfo,
  }) async {
    try {
      // Get current user
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get device info
      final androidInfo = await _deviceInfo.androidInfo;
      final batteryLevel = await _battery.batteryLevel;
      final connectivity = await Connectivity().checkConnectivity();

      // Create alert data
      final alertData = {
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'location': {
          'latitude': latitude,
          'longitude': longitude,
          'accuracy': 0, // Will be updated with actual accuracy
        },
        'status': 'pending',
        'priority': priority,
        'deviceInfo': {
          'model': androidInfo.model,
          'batteryLevel': batteryLevel,
          'platform': 'android',
          'osVersion': androidInfo.version.release,
          'networkType': connectivity.toString(),
        },
        'medicalInfo': medicalInfo,
        'responseTimeline': {
          'created': FieldValue.serverTimestamp(),
        },
        'responder': null,
        'assignedTo': null,
        'resolvedAt': null,
        'notes': [],
        'detectionMethod': medicalInfo?['fallDetected'] == true ? 'automatic' : 'manual',
      };

      // Add to Firestore
      final docRef = await _firestore.collection('sos_alerts').add(alertData);

      // Send emergency notifications
      await _notificationService.sendEmergencyNotification(
        alertId: docRef.id,
        latitude: latitude,
        longitude: longitude,
        isFallDetected: medicalInfo?['fallDetected'] == true,
      );

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create SOS alert: $e');
    }
  }

  Future<void> cancelSOSAlert(String alertId) async {
    try {
      await _firestore.collection('sos_alerts').doc(alertId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'responseTimeline.cancelled': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel SOS alert: $e');
    }
  }

  Stream<DocumentSnapshot> listenToSOSAlert(String alertId) {
    return _firestore.collection('sos_alerts').doc(alertId).snapshots();
  }

  Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return true;
  }

  Future<Position> getCurrentLocation() async {
    await requestLocationPermission();
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
