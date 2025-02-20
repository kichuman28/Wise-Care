import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String email;
  final String specialization;
  final String imageUrl;
  final String about;
  final double rating;
  final int experience;
  final int patientsServed;
  final double consultationFee;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> availableDays;
  final Map<String, List<String>> availableTimeSlots;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.imageUrl,
    required this.about,
    required this.rating,
    required this.experience,
    required this.patientsServed,
    required this.consultationFee,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
    required this.availableDays,
    required this.availableTimeSlots,
  });

  factory Doctor.fromMap(Map<String, dynamic> map, String id) {
    return Doctor(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      specialization: map['specialization'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      about: map['about'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      experience: map['experience'] ?? 0,
      patientsServed: map['patientsServed'] ?? 0,
      consultationFee: (map['consultationFee'] ?? 0.0).toDouble(),
      isAvailable: map['isAvailable'] ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      availableDays: List<String>.from(map['availableDays'] ?? []),
      availableTimeSlots: Map<String, List<String>>.from(
        map['availableTimeSlots']?.map(
              (key, value) => MapEntry(
                key.toString(),
                List<String>.from(value),
              ),
            ) ??
            {},
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'specialization': specialization,
      'imageUrl': imageUrl,
      'about': about,
      'rating': rating,
      'experience': experience,
      'patientsServed': patientsServed,
      'consultationFee': consultationFee,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'availableDays': availableDays,
      'availableTimeSlots': availableTimeSlots,
    };
  }
}
