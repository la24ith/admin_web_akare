import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/property_moderation_entities.dart';

abstract class PropertyModerationRepository {
  /// كل العقارات بحالة pending، الأقدم أولًا (FIFO)
  Future<Either<Failure, List<PropertyQueueItem>>> getPendingProperties();

  /// كل بيانات شاشة المراجعة لعقار واحد (عقار + بطاقة ثقة الوكيل)
  Future<Either<Failure, PropertyReviewDetail>> getPropertyReviewDetail(
    String propertyId,
  );

  /// قبول العقار: status = 'active' — الـ Trigger بيرسل إشعار الوكيل تلقائيًا
  Future<Either<Failure, void>> approveProperty(String propertyId);

  /// رفض العقار: status = 'rejected' + rejection_reason — نفس الأمر، بدون كود إشعار إضافي
  Future<Either<Failure, void>> rejectProperty({
    required String propertyId,
    required String reason,
  });
}
