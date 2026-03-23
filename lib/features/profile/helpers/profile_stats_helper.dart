import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileStatsHelper {
  static int rangeToMonths(String range, String latest2, String latest3) {
    if (range == latest2) return 2;
    if (range == latest3) return 3;
    return 4;
  }

  static int rangeToWeeks(String range, String latest2, String latest3) {
    if (range == latest2) return 8;
    if (range == latest3) return 12;
    return 4;
  }

  static List<DateTime> monthBuckets(int months) {
    final now = DateTime.now();
    final buckets = <DateTime>[];
    for (int i = months - 1; i >= 0; i--) {
      buckets.add(DateTime(now.year, now.month - i, 1));
    }
    return buckets;
  }

  static String monthLabelSv(DateTime d) {
    const names = [
      'jan',
      'feb',
      'mar',
      'apr',
      'maj',
      'jun',
      'jul',
      'aug',
      'sep',
      'okt',
      'nov',
      'dec',
    ];
    return names[d.month - 1];
  }

  static List<int> monthlyClientCounts(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    List<DateTime> buckets,
  ) {
    final counts = List<int>.filled(buckets.length, 0);
    final now = DateTime.now();

    final first = buckets.first;
    final firstKey = first.year * 12 + first.month;

    for (final doc in docs) {
      final data = doc.data();
      final ts = data['dateRaw'] as Timestamp?;
      if (ts == null) continue;

      final date = ts.toDate();
      if (date.isAfter(now)) continue;

      final key = date.year * 12 + date.month;
      final idx = key - firstKey;
      if (idx < 0 || idx >= counts.length) continue;

      final booked = (data['spotsBooked'] ?? 0) as int;
      counts[idx] += booked;
    }
    return counts;
  }

  static List<int> weeklyCompletedCounts(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    int weeks,
  ) {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: 7 * weeks));
    final counts = List<int>.filled(weeks, 0);

    for (final doc in docs) {
      final data = doc.data();
      final ts = data['dateRaw'] as Timestamp?;
      if (ts == null) continue;

      final date = ts.toDate();
      if (date.isAfter(now) || date.isBefore(start)) continue;

      final diffDays = now.difference(date).inDays;
      final weekFromNow = (diffDays / 7).floor();
      if (weekFromNow < 0 || weekFromNow >= weeks) continue;

      final chartIndex = weeks - 1 - weekFromNow;
      counts[chartIndex] += 1;
    }

    return counts;
  }
}
