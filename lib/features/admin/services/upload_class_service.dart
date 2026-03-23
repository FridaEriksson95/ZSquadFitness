import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zsquadfitness/features/admin/helpers/upload_class_helper.dart';

class UploadClassService {
  final FirebaseFirestore _firestore;

  UploadClassService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveClass({
    required String? classId,
    required Map<String, dynamic> classData,
    required bool repeatUpload,
    required int repeatWeeks,
  }) async {
    if (classId != null) {
      await _firestore.collection('classes').doc(classId).update(classData);
      return;
    }

    await _firestore.collection('classes').add(classData);

    if (repeatUpload && repeatWeeks > 0) {
      final baseDateTs = classData['dateRaw'] as Timestamp?;
      if (baseDateTs == null) return;

      await _createRepeatingClasses(
        baseDate: baseDateTs.toDate(),
        baseData: classData,
        weeks: repeatWeeks,
      );
    }
  }

  Future<void> _createRepeatingClasses({
    required DateTime baseDate,
    required Map<String, dynamic> baseData,
    required int weeks,
  }) async {
    for (int i = 1; i <= weeks; i++) {
      final nextDate = baseDate.add(Duration(days: 7 * i));
      if (nextDate.isBefore(DateTime.now())) continue;

      final data = Map<String, dynamic>.from(baseData);
      data['dateRaw'] = Timestamp.fromDate(nextDate);
      data['date'] = UploadClassHelper.formatSwedishDisplayDate(nextDate);
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final existing = await FirebaseFirestore.instance
          .collection('classes')
          .where('title', isEqualTo: data['title'])
          .where('dateRaw', isEqualTo: data['dateRaw'])
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) continue;

      await _firestore.collection('classes').add(data);
    }
  }
}
