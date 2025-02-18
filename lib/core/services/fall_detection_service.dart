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
    int remainingSeconds = WARNING_DURATION;

    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          // Start countdown timer only once
          if (_warningTimer == null || !_warningTimer!.isActive) {
            _warningTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
              if (remainingSeconds > 0) {
                setState(() => remainingSeconds--);
              } else {
                timer.cancel();
              }
            });
          }

          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.warning_amber, color: Colors.red, size: 30),
                const SizedBox(width: 10),
                const Text('Fall Detected!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'A potential fall has been detected.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$remainingSeconds',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'SOS will be triggered in $remainingSeconds seconds',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Tap Cancel if this was a false alarm'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _cancelWarning();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Start SOS timer
    Timer(Duration(seconds: WARNING_DURATION), () async {
      if (_isWarningShown) {
        try {
          final position = await _sosService.getCurrentLocation();
          await _sosService.createSOSAlert(
            latitude: position.latitude,
            longitude: position.longitude,
            priority: 'high',
            medicalInfo: {'fallDetected': true, 'impactMagnitude': magnitude},
          );

          Navigator.of(navigatorKey.currentContext!).pop(); // Close warning dialog

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
