import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zsquadfitness/core/constants/app_strings.dart';

class BookedUserRow {
  final DocumentReference bookingRef;
  final String name;
  final String phone;
  final String email;

  const BookedUserRow({
    required this.bookingRef,
    required this.name,
    required this.phone,
    required this.email,
  });
}

class ClassInfoBookedUsersHelper {
  static Future<List<BookedUserRow>> loadBookedUsers(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> bookingDocs,
  ) async {
    final futures = bookingDocs.map((doc) async {
      final userId = doc.reference.parent.parent!.id;
      final userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final data = userSnap.data();

      return BookedUserRow(
        bookingRef: doc.reference,
        name: data?['Name'] as String? ?? AppStrings.unknown,
        phone: data?['Phone'] as String? ?? AppStrings.unknown,
        email: data?['Email'] as String? ?? AppStrings.unknown,
      );
    });
    return Future.wait(futures);
  }

  static List<String> extractValidEmails(List<BookedUserRow> rows) {
    return rows
        .map((e) => e.email)
        .where(
          (e) => e.isNotEmpty && e != AppStrings.unknown && e.contains('@'),
        )
        .toList();
  }
}
