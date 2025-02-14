import 'package:flutter/foundation.dart';

class SafetyModuleModel extends ChangeNotifier {
  List<EmergencyContact> emergencyContacts = [];
  List<SafetyAlert> safetyAlerts = [];
  List<FallPrevention> fallPreventionTips = [];
  List<MedicationInteraction> medicationInteractions = [];
  HomeSafetyChecklist? safetyChecklist;

  Future<void> triggerEmergencyAlert(String userId) async {
    try {
      final alert = SafetyAlert(
        id: DateTime.now().toString(),
        userId: userId,
        timestamp: DateTime.now(),
        type: AlertType.sos,
        status: AlertStatus.active,
        location: await getCurrentLocation(),
      );
      safetyAlerts.add(alert);
      notifyListeners();
      await notifyEmergencyContacts(alert);
    } catch (e) {
      debugPrint('Error triggering emergency alert: $e');
      rethrow;
    }
  }

  Future<Map<String, double>> getCurrentLocation() async {
    // Implementation would use actual location services
    return {'latitude': 0.0, 'longitude': 0.0};
  }

  Future<void> notifyEmergencyContacts(SafetyAlert alert) async {
    // Implementation would handle actual notifications
  }
}

class EmergencyContact {
  final String id;
  final String name;
  final String relationship;
  final String phoneNumber;
  final String email;
  final bool isPrimaryContact;
  final List<String> notificationPreferences;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    required this.email,
    required this.isPrimaryContact,
    required this.notificationPreferences,
  });
}

class SafetyAlert {
  final String id;
  final String userId;
  final DateTime timestamp;
  final AlertType type;
  final AlertStatus status;
  final Map<String, double> location;

  SafetyAlert({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.location,
  });
}

enum AlertType { sos, fall, medication, geofence, inactivity }

enum AlertStatus { active, resolved, falseAlarm }

class FallPrevention {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> recommendations;
  final List<String> exercises;

  FallPrevention({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.recommendations,
    required this.exercises,
  });
}

class MedicationInteraction {
  final String id;
  final String medicationName;
  final List<String> interactingMedications;
  final String severityLevel;
  final String description;
  final List<String> recommendations;

  MedicationInteraction({
    required this.id,
    required this.medicationName,
    required this.interactingMedications,
    required this.severityLevel,
    required this.description,
    required this.recommendations,
  });
}

class HomeSafetyChecklist {
  final String id;
  final List<SafetyCheckItem> items;
  final DateTime lastUpdated;
  final int completedItems;
  final String overallStatus;

  HomeSafetyChecklist({
    required this.id,
    required this.items,
    required this.lastUpdated,
    required this.completedItems,
    required this.overallStatus,
  });
}

class SafetyCheckItem {
  final String id;
  final String category;
  final String description;
  final bool isCompleted;
  final String priority;
  final List<String> recommendations;

  SafetyCheckItem({
    required this.id,
    required this.category,
    required this.description,
    required this.isCompleted,
    required this.priority,
    required this.recommendations,
  });
}
