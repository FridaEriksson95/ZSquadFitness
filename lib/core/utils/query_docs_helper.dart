import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zsquadfitness/core/utils/date_utils.dart';

class QueryDocsHelper {
  static int compareByDateRaw(
    QueryDocumentSnapshot<Map<String, dynamic>> a,
    QueryDocumentSnapshot<Map<String, dynamic>> b,
  ) {
    final aTs = a.data()['dateRaw'] as Timestamp?;
    final bTs = b.data()['dateRaw'] as Timestamp?;
    final aDate = aTs?.toDate() ?? DateTime(0);
    final bDate = bTs?.toDate() ?? DateTime(0);

    return aDate.compareTo(bDate);
  }

  static List<QueryDocumentSnapshot<Map<String, dynamic>>> allSorted(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final sorted = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(docs);
    sorted.sort(compareByDateRaw);
    return sorted;
  }

  static List<QueryDocumentSnapshot<Map<String, dynamic>>> pastOnly(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs.where((doc) {
      final ts = doc.data()['dateRaw'] as Timestamp?;
      return ts.isPast;
    }).toList();
  }

  static List<QueryDocumentSnapshot<Map<String, dynamic>>> upcomingOnly(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs.where((doc) {
      final ts = doc.data()['dateRaw'] as Timestamp?;
      return ts.isUpcomingOrToday;
    }).toList();
  }
}
