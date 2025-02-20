import 'package:intl/intl.dart';
import '../models/prescription_model.dart';

class MedicationTime {
  final String medicineName;
  final String dosage;
  final DateTime scheduledTime;

  MedicationTime({
    required this.medicineName,
    required this.dosage,
    required this.scheduledTime,
  });
}

class MedicationScheduler {
  static List<MedicationTime> _parseFrequency(Medicine medicine) {
    final times = <MedicationTime>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Parse frequency and create time slots
    switch (medicine.frequency.toLowerCase()) {
      case 'once daily':
        times.add(MedicationTime(
          medicineName: medicine.name,
          dosage: medicine.dosage,
          scheduledTime: today.add(const Duration(hours: 9)), // 9 AM
        ));
        break;
      case 'twice daily':
        times.addAll([
          MedicationTime(
            medicineName: medicine.name,
            dosage: medicine.dosage,
            scheduledTime: today.add(const Duration(hours: 9)), // 9 AM
          ),
          MedicationTime(
            medicineName: medicine.name,
            dosage: medicine.dosage,
            scheduledTime: today.add(const Duration(hours: 21)), // 9 PM
          ),
        ]);
        break;
      case 'thrice daily':
        times.addAll([
          MedicationTime(
            medicineName: medicine.name,
            dosage: medicine.dosage,
            scheduledTime: today.add(const Duration(hours: 9)), // 9 AM
          ),
          MedicationTime(
            medicineName: medicine.name,
            dosage: medicine.dosage,
            scheduledTime: today.add(const Duration(hours: 15)), // 3 PM
          ),
          MedicationTime(
            medicineName: medicine.name,
            dosage: medicine.dosage,
            scheduledTime: today.add(const Duration(hours: 21)), // 9 PM
          ),
        ]);
        break;
      // Add more frequency patterns as needed
    }

    return times;
  }

  static MedicationTime? getNextMedication(List<Prescription> prescriptions) {
    if (prescriptions.isEmpty) return null;

    final now = DateTime.now();
    final allMedications = <MedicationTime>[];

    // Get all medications for today
    for (final prescription in prescriptions) {
      for (final medicine in prescription.medicines) {
        allMedications.addAll(_parseFrequency(medicine));
      }
    }

    // Sort by time
    allMedications.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

    // Find the next medication after current time
    for (final medication in allMedications) {
      if (medication.scheduledTime.isAfter(now)) {
        return medication;
      }
    }

    // If no medication is found for today after current time,
    // return the first medication for tomorrow
    if (allMedications.isNotEmpty) {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final firstMed = allMedications.first;
      return MedicationTime(
        medicineName: firstMed.medicineName,
        dosage: firstMed.dosage,
        scheduledTime: DateTime(
          tomorrow.year,
          tomorrow.month,
          tomorrow.day,
          firstMed.scheduledTime.hour,
          firstMed.scheduledTime.minute,
        ),
      );
    }

    return null;
  }

  static String formatMedicationTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
}
