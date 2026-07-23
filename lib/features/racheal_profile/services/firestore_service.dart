import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';

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
  //
  // Built on authStateChanges() instead of reading currentUid once —
  // on Chrome, Firebase restores the signed-in session asynchronously,
  // so right after opening the app currentUser can still be null for a
  // moment. Reading it once and returning Stream.value(null) would show
  // "No profile found" forever (nothing re-triggers the stream), which
  // is why a hot reload/restart used to "fix" it. Listening to
  // authStateChanges keeps this stream reactive to that late uid.
  Stream<UserProfile?> watchUserProfile() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(null);
      return _userDoc(user.uid).snapshots().map((snap) {
        if (!snap.exists) return null;
        return UserProfile.fromMap(user.uid, snap.data()!);
      });
    });
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _userDoc(profile.uid).set(profile.toMap(), SetOptions(merge: true));
  }

  Future<void> signOut() => _auth.signOut();
}
