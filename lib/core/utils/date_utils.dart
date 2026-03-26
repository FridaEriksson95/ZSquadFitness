import 'package:cloud_firestore/cloud_firestore.dart';

/// Helpers for Firestore timestamps used in date filtering
extension TimestampX on Timestamp? {
  DateTime? toDateOrNull() => this?.toDate();

  bool get isPast {
    final d = toDateOrNull();
    if (d == null) return false;
    return d.isBefore(DateTime.now());
  }

  bool get isUpcomingOrToday {
    final d = toDateOrNull();
    if (d == null) return false;
    return !d.isBefore(DateTime.now());
  }
}

extension DateTimeX on DateTime {
  bool get isPast => isBefore(DateTime.now());
  bool get isUpcomingOrToday => !isBefore(DateTime.now());
}
