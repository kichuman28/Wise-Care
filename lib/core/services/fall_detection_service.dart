import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/material.dart';
import 'sos_service.dart';

class FallDetectionService {
  static const double FALL_THRESHOLD = 20.0;
  static const int WARNING_DURATION = 15; // seconds

  final SOSService _sosService;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;
  final GlobalKey<NavigatorState> navigatorKey;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  bool _isMonitoring = false;
  Timer? _warningTimer;
  bool _isWarningShown = false;

  FallDetectionService(
    this._sosService, {
    required this.scaffoldKey,
    required this.navigatorKey,
  });

  void startMonitoring() {
    if (_isMonitoring) return;
    _isMonitoring = true;

    try {
      _accelerometerSubscription = userAccelerometerEvents.listen((event) {
        final magnitude = vector.Vector3(event.x, event.y, event.z).length;
        if (magnitude > FALL_THRESHOLD && !_isWarningShown) {
          _handlePotentialFall(magnitude);
        }
      });
    } catch (e) {
      print('Error starting fall detection: $e');
    }
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _accelerometerSubscription?.cancel();
    _warningTimer?.cancel();
    _isWarningShown = false;
  }

  Future<void> _handlePotentialFall(double magnitude) async {
    _isWarningShown = true;

    // Show warning dialog
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Fall Detected!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SOS will be triggered in $WARNING_DURATION seconds'),
                const Text('Tap Cancel if this was a false alarm'),
              ],
            ),
            backgroundColor: Colors.orange[100],
            icon: const Icon(Icons.warning_amber, color: Colors.orange),
            actions: [
              TextButton(
                onPressed: () {
                  _cancelWarning();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );

    // Start countdown timer
    _warningTimer = Timer(Duration(seconds: WARNING_DURATION), () async {
      if (_isWarningShown) {
        try {
          final position = await _sosService.getCurrentLocation();
          await _sosService.createSOSAlert(
            latitude: position.latitude,
            longitude: position.longitude,
            priority: 'high',
            medicalInfo: {'fallDetected': true, 'impactMagnitude': magnitude},
          );
          scaffoldKey.currentState?.hideCurrentMaterialBanner();
          scaffoldKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text('SOS Alert Activated'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        } catch (e) {
          print('Failed to send automatic SOS alert: $e');
        }
      }
    });
  }

  void _cancelWarning() {
    _warningTimer?.cancel();
    _isWarningShown = false;
  }

  bool get isMonitoring => _isMonitoring;
}
