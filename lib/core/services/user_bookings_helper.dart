import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zsquadfitness/core/utils/date_utils.dart';

class UserBookingsView {
  final List<QueryDocumentSnapshot> upcoming;
  final List<QueryDocumentSnapshot> past;

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
          final past = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final ts = data['dateRaw'] as Timestamp?;
            return ts.isPast;
          }).toList();
          final upcoming = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final ts = data['dateRaw'] as Timestamp?;
            return ts.isUpcomingOrToday;
          }).toList();

          past.sort(_compareByDateRaw);
          upcoming.sort(_compareByDateRaw);

          return UserBookingsView(upcoming: upcoming, past: past);
        });
  }

  static int _compareByDateRaw(
    QueryDocumentSnapshot a,
    QueryDocumentSnapshot b,
  ) {
    final aData = a.data() as Map<String, dynamic>;
    final bData = b.data() as Map<String, dynamic>;
    final aTs = aData['dateRaw'] as Timestamp?;
    final bTs = bData['dateRaw'] as Timestamp?;
    final aDate = aTs?.toDate() ?? DateTime(0);
    final bDate = bTs?.toDate() ?? DateTime(0);

    return aDate.compareTo(bDate);
  }
}
