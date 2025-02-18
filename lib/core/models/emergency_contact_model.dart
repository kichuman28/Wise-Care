class EmergencyContact {
  final String? id;
  final String name;
  final String phoneNumber;
  final String relation;
  final String userId;

  EmergencyContact({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.relation,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'relation': relation,
      'userId': userId,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map, String id) {
    return EmergencyContact(
      id: id,
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      relation: map['relation'] ?? '',
      userId: map['userId'] ?? '',
    );
  }
}
