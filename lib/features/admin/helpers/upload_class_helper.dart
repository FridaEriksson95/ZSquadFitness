import 'package:intl/intl.dart';

class UploadClassHelper {
  static const Map<String, int> _monthMap = {
    'jan': 1,
    'januari': 1,
    'feb': 2,
    'februari': 2,
    'mar': 3,
    'mars': 3,
    'apr': 4,
    'april': 4,
    'maj': 5,
    'jun': 6,
    'juni': 6,
    'jul': 7,
    'juli': 7,
    'aug': 8,
    'augusti': 8,
    'sep': 9,
    'september': 9,
    'okt': 10,
    'oktober': 10,
    'nov': 11,
    'november': 11,
    'dec': 12,
    'december': 12,
  };

  static int repeatWeeksToInt(String value) {
    if (value.startsWith('4')) return 4;
    if (value.startsWith('6')) return 6;
    if (value.startsWith('8')) return 8;
    return 0;
  }

  static DateTime? parseClassDateTime({
    required String dateTextRaw,
    required String timeTextRaw,
    DateTime? nowOverride,
  }) {
    final now = nowOverride ?? DateTime.now();
    var dateText = dateTextRaw.trim();

    final dayStart = dateText.indexOf(RegExp(r'\d'));
    if (dayStart > 0) {
      dateText = dateText.substring(dayStart).trim();
    }
    final parts = dateText.split(RegExp(r'\s+'));
    if (parts.length < 2) return null;
    final day = int.tryParse(parts[0]);
    final monthStr = parts[1].toLowerCase();
    final month = _monthMap[monthStr];

    if (day == null || month == null) return null;

    int hour = 0, minute = 0;
    final timeStr = timeTextRaw.trim();

    if (timeStr.isNotEmpty) {
      final startPart = timeStr.split(' - ').first.trim();
      final timeParts = startPart.replaceAll('.', ':').split(':');
      if (timeParts.length >= 2) {
        hour = int.tryParse(timeParts[0]) ?? 0;
        minute = int.tryParse(timeParts[1]) ?? 0;
      }
    }

    var parsed = DateTime(now.year, month, day, hour, minute);
    if (parsed.isBefore(now.subtract(const Duration(days: 1)))) {
      parsed = DateTime(
        parsed.year + 1,
        parsed.month,
        parsed.day,
        parsed.hour,
        parsed.minute,
      );
    }
    return parsed;
  }

  static String formatSwedishDisplayDate(DateTime date) {
    final formatted = DateFormat('EEEE d MMMM', 'sv_SE').format(date);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}
