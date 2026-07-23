import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pharmacy_listing.dart';

// Reads medicine stock data from the "medicineStock" Firestore collection.
// Each document there is one pharmacy's stock entry for one medicine —
// see the field list in the project notes / README.
class SearchService {
  final _db = FirebaseFirestore.instance;

  // Firestore can't do case-insensitive or "contains" text search, so stock
  // documents also store a lowercase copy of the name ("medicineNameLower")
  // and we do a prefix match against that: everything from q up to
  // q + the highest unicode character sorts as "starts with q".
  Stream<List<PharmacyListing>> watchListings(String query) {
    final q = query.trim().toLowerCase();
    final base = _db.collection('medicineStock');

    final firestoreQuery = q.isEmpty
        ? base.orderBy('updatedAt', descending: true).limit(30)
        : base
            .orderBy('medicineNameLower')
            .startAt([q])
            .endAt(['$q\uf8ff']);

    return firestoreQuery.snapshots().map(
          (snap) => snap.docs
              .map((doc) => PharmacyListing.fromMap(doc.data()))
              .toList(),
        );
  }
}
