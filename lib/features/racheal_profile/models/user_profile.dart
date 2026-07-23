/// Maps to a document in Firestore: users/{uid}
class UserProfile {
  final String uid;
  final String fullName;
  final String? email;
  final String? phone;
  final DateTime? dob;
  final String? address;
  final bool isVerifiedPatient;
  final String? insuranceProvider;
  final String appVersion;
  final DateTime? lastSyncAt;

  UserProfile({
    required this.uid,
    required this.fullName,
    this.email,
    this.phone,
    this.dob,
    this.address,
    this.isVerifiedPatient = false,
    this.insuranceProvider,
    this.appVersion = '2.4.0',
    this.lastSyncAt,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      dob: data['dob'] != null ? DateTime.tryParse(data['dob'].toString()) : null,
      address: data['address'] as String?,
      isVerifiedPatient: data['isVerifiedPatient'] as bool? ?? false,
      insuranceProvider: data['insuranceProvider'] as String?,
      appVersion: data['appVersion'] as String? ?? '2.4.0',
      lastSyncAt: data['lastSyncAt'] != null
          ? DateTime.tryParse(data['lastSyncAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'dob': dob?.toIso8601String(),
      'address': address,
      'isVerifiedPatient': isVerifiedPatient,
      'insuranceProvider': insuranceProvider,
      'appVersion': appVersion,
      'lastSyncAt': lastSyncAt?.toIso8601String(),
    };
  }

  // Used to save just the field(s) that changed, without having to
  // re-type every other field by hand.
  UserProfile copyWith({
    String? fullName,
    String? phone,
    DateTime? dob,
    String? address,
    String? insuranceProvider,
  }) {
    return UserProfile(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      address: address ?? this.address,
      isVerifiedPatient: isVerifiedPatient,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      appVersion: appVersion,
      lastSyncAt: lastSyncAt,
    );
  }
}
