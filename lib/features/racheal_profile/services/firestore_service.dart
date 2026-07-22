import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../models/pharmacy.dart';

/// Firestore/Auth calls needed by the Profile page.
class FirestoreService {
  FirestoreService._internal();
  static final FirestoreService instance = FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  /// Live stream of the logged-in user's profile document.
  Stream<UserProfile?> watchUserProfile() {
    final uid = currentUid;
    if (uid == null) return Stream.value(null);
    return _userDoc(uid).snapshots().map((snap) {
      if (!snap.exists) return null;
      return UserProfile.fromMap(uid, snap.data()!);
    });
  }

  /// Live stream of saved pharmacies, ordered by distance.
  Stream<List<Pharmacy>> watchSavedPharmacies() {
    final uid = currentUid;
    if (uid == null) return Stream.value([]);
    return _userDoc(uid)
        .collection('savedPharmacies')
        .orderBy('distanceKm')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Pharmacy.fromMap(d.id, d.data())).toList(),
        );
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _userDoc(profile.uid).set(profile.toMap(), SetOptions(merge: true));
  }

  Future<void> signOut() => _auth.signOut();
}
