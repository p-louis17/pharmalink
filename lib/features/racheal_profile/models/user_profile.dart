/// Maps to a document in Firestore: users/{uid}
class UserProfile {
  final String uid;
  final String fullName;
  final String? photoUrl;
  final bool isVerifiedPatient;
  final String? insuranceProvider;
  final String appVersion;
  final DateTime? lastSyncAt;

  UserProfile({
    required this.uid,
    required this.fullName,
    this.photoUrl,
    this.isVerifiedPatient = false,
    this.insuranceProvider,
    this.appVersion = '2.4.0',
    this.lastSyncAt,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      fullName: data['fullName'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
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
      'photoUrl': photoUrl,
      'isVerifiedPatient': isVerifiedPatient,
      'insuranceProvider': insuranceProvider,
      'appVersion': appVersion,
      'lastSyncAt': lastSyncAt?.toIso8601String(),
    };
  }
}
