import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zsquadfitness/core/utils/query_docs_helper.dart';

class UserBookingsView {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> upcoming;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> past;

  const UserBookingsView({required this.upcoming, required this.past});

  bool get isEmpty => upcoming.isEmpty && past.isEmpty;
}

class UserBookingsHelper {
  static final _firestore = FirebaseFirestore.instance;

  static Stream<UserBookingsView> streamBookings(String? userId) {
    if (userId == null || userId.isEmpty) {
      return Stream.value(const UserBookingsView(upcoming: [], past: []));
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .orderBy('dateRaw')
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs;
          final past = QueryDocsHelper.allSorted(
            QueryDocsHelper.pastOnly(docs),
          );

          final upcoming = QueryDocsHelper.allSorted(
            QueryDocsHelper.upcomingOnly(docs),
          );

          return UserBookingsView(upcoming: upcoming, past: past);
        });
  }
}
