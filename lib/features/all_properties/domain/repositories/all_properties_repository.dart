import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/property_list_row.dart';

abstract class AllPropertiesRepository {
  /// [status] = null يعني بدون فلترة (الكل)، [searchQuery] بحث بالعنوان فقط.
  Future<Either<Failure, List<PropertyListRow>>> getAllProperties({
    String? status,
    String? searchQuery,
  });

  /// تعطيل فوري لعقار (حالات طارئة بعد النشر) — status = rejected
  /// مع سبب افتراضي "أُزيل من قبل الإدارة".
  Future<Either<Failure, void>> disableProperty(String propertyId);
}
