import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> cancelBooking({
    required DocumentReference bookingRef,
    required String classId,
  }) async {
    await _firestore.runTransaction((transaction) async {
      final classRef = _firestore.collection('classes').doc(classId);
      final classSnap = await transaction.get(classRef);

      final booked = classSnap.data()?['spotsBooked'] ?? 0;
      if (booked > 0) {
        transaction.update(classRef, {'spotsBooked': booked - 1});
      }

      transaction.delete(bookingRef);
    });
  }

  Future<void> bookRepeatingClasses({
    required String baseClassId,
    required Map<String, dynamic> baseClassData,
    required int weeks,
    required int targetWeekday,
  }) async {
    final user = currentUser;
    if (user == null || weeks <= 0) return;

    final currentTs = baseClassData['dateRaw'] as Timestamp?;
    if (currentTs == null) return;
    final currentDate = currentTs.toDate();
    final endDate = currentDate.add(Duration(days: 7 * weeks));

    final query = await _firestore
        .collection('classes')
        .where('dateRaw', isGreaterThan: Timestamp.fromDate(currentDate))
        .where('dateRaw', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('dateRaw')
        .get();

    for (final doc in query.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final ts = data['dateRaw'] as Timestamp?;
      if (ts == null) continue;
      final date = ts.toDate();

      if (date.weekday != targetWeekday) continue;

      final classId = doc.id;

      final existing = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .where('classId', isEqualTo: classId)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) continue;

      final classRef = _firestore.collection('classes').doc(classId);

      await _firestore.runTransaction((transaction) async {
        final snap = await transaction.get(classRef);
        if (!snap.exists) return;
        final booked = snap.data()?['spotsBooked'] ?? 0;
        final total = snap.data()?['spotsTotal'] ?? 0;
        if (booked >= total) return;

        transaction.update(classRef, {'spotsBooked': booked + 1});

        final bookingRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('bookings')
            .doc();

        transaction.set(bookingRef, {
          'classId': classId,
          'date': data['date'],
          'time': data['time'],
          'dateRaw': data['dateRaw'],
          'bookedAt': FieldValue.serverTimestamp(),
        });
      });
    }
  }
}
