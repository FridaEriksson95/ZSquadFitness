import 'package:cloud_firestore/cloud_firestore.dart';

class ClassScheduleHelper {
  static final _firestore = FirebaseFirestore.instance;

  static const Map<int, String> weekdayNamesSv = {
    DateTime.monday: 'Måndagar',
    DateTime.tuesday: 'Tisdagar',
    DateTime.wednesday: 'Onsdagar',
    DateTime.thursday: 'Torsdagar',
    DateTime.friday: 'Fredagar',
    DateTime.saturday: 'Lördagar',
    DateTime.sunday: 'Söndagar',
  };

  static Future<List<int>> getAvailableWeekdays({
    Duration range = const Duration(days: 90),
  }) async {
    final now = DateTime.now();
    final end = now.add(range);

    final query = await _firestore
        .collection('classes')
        .where('dateRaw', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .where('dateRaw', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();

    final days = <int>{};
    for (final doc in query.docs) {
      final ts = doc.data()['dateRaw'] as Timestamp?;
      if (ts == null) continue;
      days.add(ts.toDate().weekday);
    }

    final sortedDays = days.toList()..sort();
    return sortedDays;
  }

  static String weekdayLabel(int weekday) {
    return weekdayNamesSv[weekday] ?? '';
  }

  static int weekdayFromLabel(String label) {
    return weekdayNamesSv.entries
        .firstWhere((entry) => entry.value == label)
        .key;
  }
}
