class Doctor {
  final String id;
  final String name;
  final String mail;
  final String specialization;
  final String imageUrl;
  final String about;
  final double rating;
  final int experience;
  final int patientsServed;
  final List<String> availableDays;
  final Map<String, List<String>> availableTimeSlots;
  final double consultationFee;
  final bool isAvailable;

  Doctor({
    required this.id,
    required this.name,
    required this.mail,
    required this.specialization,
    required this.imageUrl,
    required this.about,
    required this.rating,
    required this.experience,
    required this.patientsServed,
    required this.availableDays,
    required this.availableTimeSlots,
    required this.consultationFee,
    this.isAvailable = true,
  });

  factory Doctor.fromMap(Map<String, dynamic> map, String id) {
    return Doctor(
      id: id,
      name: map['name'] ?? '',
      mail: map['mail'] ?? '',
      specialization: map['specialization'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      about: map['about'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      experience: map['experience'] ?? 0,
      patientsServed: map['patientsServed'] ?? 0,
      availableDays: List<String>.from(map['availableDays'] ?? []),
      availableTimeSlots: Map<String, List<String>>.from(
        map['availableTimeSlots']?.map(
              (key, value) => MapEntry(
                key,
                List<String>.from(value),
              ),
            ) ??
            {},
      ),
      consultationFee: (map['consultationFee'] ?? 0.0).toDouble(),
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mail': mail,
      'specialization': specialization,
      'imageUrl': imageUrl,
      'about': about,
      'rating': rating,
      'experience': experience,
      'patientsServed': patientsServed,
      'availableDays': availableDays,
      'availableTimeSlots': availableTimeSlots,
      'consultationFee': consultationFee,
      'isAvailable': isAvailable,
    };
  }
}
