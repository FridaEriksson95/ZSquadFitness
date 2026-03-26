import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/constants/confirmation_status.dart';

class BookingService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  /// Cancel booking and delete from bookingRef in Firestore
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

  /// Book one class only and add data in Firestore
  Future<void> bookSingleClass({
    required User user,
    required String classId,
    required Map<String, dynamic> classData,
    required bool sendConfirmation,
  }) async {
    final classRef = _firestore.collection('classes').doc(classId);

    await _firestore.runTransaction((transaction) async {
      final classSnapshot = await transaction.get(classRef);

      if (!classSnapshot.exists) {
        throw AppStrings.classRemoved;
      }
      final currentBooked = classSnapshot.data()?['spotsBooked'] ?? 0;
      final total = classSnapshot.data()?['spotsTotal'] ?? 0;

      if (currentBooked >= total) {
        throw AppStrings.classFull;
      }

      transaction.update(classRef, {'spotsBooked': currentBooked + 1});

      final bookingRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .doc();

      transaction.set(bookingRef, {
        'classId': classId,
        'title': classData['title'],
        'date': classData['date'],
        'time': classData['time'],
        'dateRaw': classData['dateRaw'],
        'locationName': classData['locationName'],
        'locationAddress': classData['locationAddress'],
        'room': classData['room'] ?? '',
        'sendConfirmation': sendConfirmation,
        'confirmationStatus': sendConfirmation
            ? ConfirmationStatus.pending
            : ConfirmationStatus.skipped,
        'bookedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Book several classes and add data in Firestore
  Future<void> bookRepeatingClasses({
    required Map<String, dynamic> baseClassData,
    required int weeks,
    required int targetWeekday,
    required bool sendConfirmation,
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
      final data = doc.data();
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
          'title': data['title'],
          'date': data['date'],
          'time': data['time'],
          'dateRaw': data['dateRaw'],
          'locationName': data['locationName'],
          'locationAddress': data['locationAddress'],
          'room': data['room'] ?? '',
          'sendConfirmation': sendConfirmation,
          'confirmationStatus': sendConfirmation
              ? ConfirmationStatus.pending
              : ConfirmationStatus.skipped,
          'bookedAt': FieldValue.serverTimestamp(),
        });
      });
    }
  }

  /// Repeat bookings and add data in Firestore
  Future<void> bookRepeating({
    required bool repeatBooking,
    required int weeks,
    required int targetWeekday,
    required Map<String, dynamic> classData,
    required bool sendConfirmation,
  }) async {
    if (!repeatBooking || weeks <= 0) return;

    await bookRepeatingClasses(
      baseClassData: classData,
      weeks: weeks,
      targetWeekday: targetWeekday,
      sendConfirmation: sendConfirmation,
    );
  }
}
