import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper for weekday schedule logic used by repeat booking flows
class ClassScheduleHelper {
  static final _firestore = FirebaseFirestore.instance;

  // Sets weekdays to swedish names
  static const Map<int, String> weekdayNamesSv = {
    DateTime.monday: 'Måndagar',
    DateTime.tuesday: 'Tisdagar',
    DateTime.wednesday: 'Onsdagar',
    DateTime.thursday: 'Torsdagar',
    DateTime.friday: 'Fredagar',
    DateTime.saturday: 'Lördagar',
    DateTime.sunday: 'Söndagar',
  };

  /// Returns weekdays that have classes within the given date range
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

  // Maps a swedish weekday label back to DateTime weekday int
  static int weekdayFromLabel(String label) {
    final match = weekdayNamesSv.entries.where((entry) => entry.value == label);
    if (match.isEmpty) {
      throw ArgumentError('Unknown weekday label: $label');
    }
    return match.first.key;
  }

  static int? weekdayFromDateRaw(dynamic dateRaw) {
    if (dateRaw is Timestamp) return dateRaw.toDate().weekday;
    if (dateRaw is DateTime) return dateRaw.weekday;
    return null;
  }

  static int? currentClassWeekdayFromData(Map<String, dynamic> classData) {
    return weekdayFromDateRaw(classData['dateRaw']);
  }
}
