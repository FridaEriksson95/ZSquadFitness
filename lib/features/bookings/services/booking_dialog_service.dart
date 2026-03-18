import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';
import 'package:zsquadfitness/core/services/booking_service.dart';

class BookingDialogService {
  final BookingService bookingService;
  static final _firestore = FirebaseFirestore.instance;

  BookingDialogService({required this.bookingService});

  Future<void> bookSingleClass({
    required User user,
    required String classId,
    required Map<String, dynamic> classData,
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
        'date': classData['date'],
        'time': classData['time'],
        'dateRaw': classData['dateRaw'],
        'bookedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> bookRepeating({
    required bool repeatBooking,
    required int weeks,
    required int targetWeekday,
    required String classId,
    required Map<String, dynamic> classData,
  }) async {
    if (!repeatBooking || weeks <= 0) return;

    await bookingService.bookRepeatingClasses(
      baseClassId: classId,
      baseClassData: classData,
      weeks: weeks,
      targetWeekday: targetWeekday,
    );
  }
}
