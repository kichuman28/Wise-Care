class UserAddress {
  final String? id;
  final String userId;
  final String address;
  final String? additionalInfo;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  UserAddress({
    this.id,
    required this.userId,
    required this.address,
    this.additionalInfo,
    this.latitude,
    this.longitude,
    this.isDefault = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'address': address,
      'additionalInfo': additionalInfo,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  factory UserAddress.fromMap(Map<String, dynamic> map, String id) {
    return UserAddress(
      id: id,
      userId: map['userId'] ?? '',
      address: map['address'] ?? '',
      additionalInfo: map['additionalInfo'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      isDefault: map['isDefault'] ?? true,
    );
  }

  UserAddress copyWith({
    String? address,
    String? additionalInfo,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return UserAddress(
      id: id,
      userId: userId,
      address: address ?? this.address,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
