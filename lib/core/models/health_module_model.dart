import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../services/google_fit_service.dart';

class HealthModuleModel extends ChangeNotifier {
  List<VitalSign> vitalSigns = [];
  List<HealthRecord> healthRecords = [];
  List<DietPlan> dietPlans = [];
  List<ExerciseRoutine> exerciseRoutines = [];
  SleepData? sleepData;
  final GoogleFitService _googleFitService;

  HealthModuleModel(this._googleFitService);

  Future<void> updateVitalSigns(VitalSign vitalSign) async {
    try {
      vitalSigns.add(vitalSign);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating vital signs: $e');
      rethrow;
    }
  }

  Future<void> syncWithGoogleFit() async {
    try {
      final authorized = await _googleFitService.authorize();
      if (!authorized) return;

      final heartRateData = await _googleFitService.getHealthData(
        HealthDataType.HEART_RATE,
      );

      // Process and store the data
      vitalSigns = heartRateData
          .map((point) => VitalSign(
                timestamp: point.dateFrom,
                heartRate: (point.value as double).toInt(),
                bloodPressure: 0.0, // Default value
                temperature: 0.0, // Default value
                oxygenLevel: 0, // Default value
              ))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Google Fit sync error: $e');
    }
  }
}

class VitalSign {
  final DateTime timestamp;
  final double bloodPressure;
  final int heartRate;
  final double temperature;
  final int oxygenLevel;

  VitalSign({
    required this.timestamp,
    required this.bloodPressure,
    required this.heartRate,
    required this.temperature,
    required this.oxygenLevel,
  });
}

class HealthRecord {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final String doctorName;
  final List<String> attachments;

  HealthRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.doctorName,
    required this.attachments,
  });
}

class DietPlan {
  final String id;
  final String name;
  final List<Meal> meals;
  final List<String> restrictions;
  final int calorieTarget;

  DietPlan({
    required this.id,
    required this.name,
    required this.meals,
    required this.restrictions,
    required this.calorieTarget,
  });
}

class Meal {
  final String name;
  final String time;
  final List<String> items;
  final int calories;

  Meal({
    required this.name,
    required this.time,
    required this.items,
    required this.calories,
  });
}

class ExerciseRoutine {
  final String id;
  final String name;
  final String difficulty;
  final int durationMinutes;
  final List<Exercise> exercises;

  ExerciseRoutine({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.durationMinutes,
    required this.exercises,
  });
}

class Exercise {
  final String name;
  final String description;
  final int repetitions;
  final int sets;
  final String videoUrl;

  Exercise({
    required this.name,
    required this.description,
    required this.repetitions,
    required this.sets,
    required this.videoUrl,
  });
}

class SleepData {
  final DateTime startTime;
  final DateTime endTime;
  final int qualityScore;
  final List<SleepPhase> phases;

  SleepData({
    required this.startTime,
    required this.endTime,
    required this.qualityScore,
    required this.phases,
  });
}

class SleepPhase {
  final String phase;
  final DateTime startTime;
  final DateTime endTime;

  SleepPhase({
    required this.phase,
    required this.startTime,
    required this.endTime,
  });
}
