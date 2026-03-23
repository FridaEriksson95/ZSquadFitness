import 'package:cloud_firestore/cloud_firestore.dart';

class WeekCalendarHelper {
  static DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime mondayOf(DateTime d) =>
      d.subtract(Duration(days: d.weekday - 1));

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static Set<DateTime> daysWithClasses(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final days = <DateTime>{};
    for (final doc in docs) {
      final ts = doc.data()['dateRaw'] as Timestamp?;
      if (ts == null) continue;
      days.add(normalize(ts.toDate()));
    }
    return days;
  }

  static List<QueryDocumentSnapshot<Map<String, dynamic>>> classesForDay(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    DateTime day,
  ) {
    return docs.where((doc) {
      final ts = doc.data()['dateRaw'] as Timestamp?;
      if (ts == null) return false;
      return isSameDay(ts.toDate(), day);
    }).toList();
  }
}
