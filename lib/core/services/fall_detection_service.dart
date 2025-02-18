import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          final alertId = await _sosService.createSOSAlert(
            latitude: position.latitude,
            longitude: position.longitude,
            priority: 'high',
            medicalInfo: {'fallDetected': true, 'impactMagnitude': magnitude},
          );

          Navigator.of(navigatorKey.currentContext!).pop(); // Close warning dialog
          _showSOSResponseDialog(alertId); // Show response tracking dialog
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

  void _showSOSResponseDialog(String alertId) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.emergency, color: Colors.red),
            const SizedBox(width: 10),
            const Text('SOS Alert Active'),
          ],
        ),
        content: StreamBuilder<DocumentSnapshot>(
          stream: _sosService.listenToSOSAlert(alertId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Connecting to emergency services...'),
                ],
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final status = data['status'] as String;
            final responder = data['responder'] as Map<String, dynamic>?;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusInfo(status),
                if (responder != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Responder Details:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildResponderInfo(responder),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Stay calm and wait for help to arrive.',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _sosService.cancelSOSAlert(alertId);
              Navigator.of(context).pop();
            },
            child: const Text('Cancel SOS'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(String status) {
    IconData icon;
    String message;
    Color color;

    switch (status) {
      case 'pending':
        icon = Icons.access_time;
        message = 'Emergency services have been notified';
        color = Colors.orange;
        break;
      case 'assigned':
        icon = Icons.local_hospital;
        message = 'Responder is on the way';
        color = Colors.blue;
        break;
      case 'resolved':
        icon = Icons.check_circle;
        message = 'Emergency has been resolved';
        color = Colors.green;
        break;
      default:
        icon = Icons.info;
        message = 'Processing your emergency alert';
        color = Colors.grey;
    }

    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildResponderInfo(Map<String, dynamic> responder) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${responder['name'] ?? 'Not assigned'}'),
            Text('ETA: ${responder['eta'] ?? 'Calculating...'}'),
            if (responder['unit'] != null) Text('Unit: ${responder['unit']}'),
          ],
        ),
      ),
    );
  }

  bool get isMonitoring => _isMonitoring;
}
