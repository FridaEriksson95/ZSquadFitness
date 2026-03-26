import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  /// Creates or updates user profile data in Firestore
  Future<void> addUserData(Map<String, dynamic> userInfoMap, String id) async {
    await _firestore
        .collection("users")
        .doc(id)
        .set(userInfoMap, SetOptions(merge: true));
  }

  /// Streams live updates for user document
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserData(String id) {
    return _firestore.collection("users").doc(id).snapshots();
  }
}
