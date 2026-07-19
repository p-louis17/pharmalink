class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;

  const AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phoneNumber = '',
    this.address = '',
    this.dateOfBirth,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] as String,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      address: json['address'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  AppUser copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    DateTime? dateOfBirth,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
