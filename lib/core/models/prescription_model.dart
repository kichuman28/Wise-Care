import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine {
  final String name;
  final String dosage;
  final String duration;
  final String frequency;

  Medicine({
    required this.name,
    required this.dosage,
    required this.duration,
    required this.frequency,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dosage': dosage,
      'duration': duration,
      'frequency': frequency,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      duration: map['duration'] ?? '',
      frequency: map['frequency'] ?? '',
    );
  }
}

class Prescription {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime createdAt;
  final String diagnosis;
  final String instructions;
  final List<Medicine> medicines;
  final String symptoms;
  final String followUpDate;

  Prescription({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.createdAt,
    required this.diagnosis,
    required this.instructions,
    required this.medicines,
    required this.symptoms,
    required this.followUpDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'createdAt': Timestamp.fromDate(createdAt),
      'diagnosis': diagnosis,
      'instructions': instructions,
      'medicines': medicines.map((m) => m.toMap()).toList(),
      'symptoms': symptoms,
      'followUpDate': followUpDate,
    };
  }

  factory Prescription.fromMap(Map<String, dynamic> map, String id) {
    return Prescription(
      id: id,
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      diagnosis: map['diagnosis'] ?? '',
      instructions: map['instructions'] ?? '',
      medicines: List<Medicine>.from(
        (map['medicines'] as List? ?? []).map(
          (m) => Medicine.fromMap(m as Map<String, dynamic>),
        ),
      ),
      symptoms: map['symptoms'] ?? '',
      followUpDate: map['followUpDate'] ?? '',
    );
  }
}
