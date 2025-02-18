import 'package:google_sign_in/google_sign_in.dart';
import 'package:health/health.dart' show Health, HealthDataPoint, HealthDataType;

class GoogleFitService {
  static final Health health = Health();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/fitness.activity.read',
      'https://www.googleapis.com/auth/fitness.heart_rate.read',
      'https://www.googleapis.com/auth/fitness.sleep.read',
    ],
  );

  Future<bool> authorize() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return false;

      final isAuthorized = await health.requestAuthorization([
        HealthDataType.HEART_RATE,
        HealthDataType.STEPS,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      ]);

      return isAuthorized;
    } catch (e) {
      print('Authorization error: $e');
      return false;
    }
  }

  Future<List<HealthDataPoint>> getHealthData(HealthDataType type, {DateTime? start, DateTime? end}) async {
    try {
      final now = DateTime.now();
      return await health.getHealthDataFromTypes(
        startTime: start ?? now.subtract(const Duration(days: 1)),
        endTime: end ?? now,
        types: [type],
      );
    } catch (e) {
      print('Error getting health data: $e');
      return [];
    }
  }
}
