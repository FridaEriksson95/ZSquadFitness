import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future addUserData(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Stream<DocumentSnapshot> getUserData(String id) {
    return FirebaseFirestore.instance.collection("users").doc(id).snapshots();
  }
}
